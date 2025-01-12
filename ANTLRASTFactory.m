/* ANTLRASTFactory.m
   Copyright (C) 1998, 1999  Helge Hess and Manuel Guesdon
   All rights reserved.

   Authors:	Helge Hess  	<helge@mdlink.de>
   			Manuel Guesdon	<mguesdon@sbuilders.com>

   This file is part of the ANTLR Objective-C Library.

   Permission to use, copy, modify, and distribute this software and its
   documentation for any purpose and without fee is hereby granted, provided
   that the above copyright notice appear in all copies and that both that
   copyright notice and this permission notice appear in supporting
   documentation.

   We disclaim all warranties with regard to this software, including all
   implied warranties of merchantability and fitness, in no event shall
   we be liable for any special, indirect or consequential damages or any
   damages whatsoever resulting from loss of use, data or profits, whether in
   an action of contract, negligence or other tortious action, arising out of
   or in connection with the use or performance of this software.

   ---------------------------------------------------------------------------
   This code is based on ANTLR toolkit (http://www.antlr.org)
   from MageLang Institute:
		"We encourage users to develop software with ANTLR. However,
		we do ask that credit is given to us for developing
		ANTLR. By "credit", we mean that if you use ANTLR or
		incorporate any source code into one of your programs
		(commercial product, research project, or otherwise) that
		you acknowledge this fact somewhere in the documentation,
		research report, etc... If you like ANTLR and have
		developed a nice tool with the output, please mention that
		you developed it using ANTLR."
*/

#include "ANTLRCommon.h"
#include "ANTLRBitSet.h"
#include "ANTLRAST.h"
#include "ANTLRASTFactory.h"
#include "ANTLRCommonAST.h"

@implementation ANTLRASTFactory

//--------------------------------------------------------------------
-(id)init
{
  LOGObjectFnStart();
  self=[super init];
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(nodeType);
  [super dealloc];
};
#endif
//--------------------------------------------------------------------
-(void)setASTNodeType:(NSString *)_nodeType
{
  LOGObjectFnStart();
  ASSIGN(nodeType,_nodeType);
  nodeTypeClass = NSClassFromString(_nodeType);
  if (!nodeTypeClass)
	{
	  [ANTLRLogErr writeString:[NSString stringWithFormat:@"Can't find/access AST Node type %@",_nodeType]];
	};
  LOGObjectFnStop();
};


//--------------------------------------------------------------------
//	 Add a child to the current AST
-(void)addASTChild:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair;
{
  LOGObjectFnStart();
  if (_AST)
	{
	  if (![_ASTPair root])
		// Make new child the current root
		[_ASTPair setRoot:_AST];
	  else if (![_ASTPair child])
		// Add new child to current root
		[[_ASTPair root] setFirstChild:_AST];
	  else
		[[_ASTPair child] setNextSibling:_AST];

	  // Make new child the current child
	  [_ASTPair setChild:_AST];
	  [_ASTPair advanceChildToEnd];
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)create
{
  ANTLRDefAST t = nil;
  LOGObjectFnStart();
  if (!nodeTypeClass)
	  t = AUTORELEASE([ANTLRCommonAST new]);
  else
	{
	  NSString *fmt  = @"%@ ASTFactory catchException:%@ (%@)";
	  NSString *fmt2 = @"Can't create AST Node %@";
	  NS_DURING
		{
		  t = AUTORELEASE([nodeTypeClass new]);
		}
	  NS_HANDLER
		{
		  NSLog(fmt,
				ANTLRTIDInfo(),
				localException,
				[localException reason]);
		  [ANTLRLogErr writeString:[NSString stringWithFormat:fmt2,
											 nodeTypeClass]];
		}
	  NS_ENDHANDLER;
	};
  LOGObjectFnStop();
  return t;
};


//--------------------------------------------------------------------
-(ANTLRDefAST)create:(id<NSObject>)_unknown
{
  ANTLRDefAST t=nil;
  LOGObjectFnStart();
  if (_unknown)
	{
	  if ([_unknown conformsToProtocol:@protocol(ANTLRToken)])
		t=[self createWithToken:(ANTLRDefToken)_unknown];
	  else if ([_unknown conformsToProtocol:@protocol(ANTLRAST)])
		t=[self createWithAST:(ANTLRDefAST)_unknown];
	  else
		[NSException raise];
	}
  else
	{
	  t=[self create];
	};
  LOGObjectFnStop();
  return t;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_tokenType
{
  ANTLRDefAST t = nil;
  LOGObjectFnStart();
  t=[self create];
  [t setTokenType:_tokenType];
  LOGObjectFnStop();
  return t;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_tokenType
							 text:(NSString*)_text
{
  ANTLRDefAST t = nil;
  LOGObjectFnStart();
  t=[self create];
  [t setTokenType:_tokenType];
  [t setText:_text];
  LOGObjectFnStop();
  return t;
}

//--------------------------------------------------------------------
//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)createWithToken:(ANTLRDefToken)_token
{
  ANTLRDefAST t = nil;
  LOGObjectFnStart();
  t=[self create];
  [t setWithToken:_token];
  LOGObjectFnStop();
  return t;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)createWithAST:(ANTLRDefAST)_AST
{
  ANTLRDefAST t=nil;
  LOGObjectFnStart();
  if (_AST)
	{
	  t = [self create];
	  [t setWithAST:_AST];
	};
  LOGObjectFnStop();
  return t;
};

//--------------------------------------------------------------------
-(void)makeASTRoot:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair
{
  LOGObjectFnStart();
  if (_AST)
	{
	  // Add the current root as a child of new root
	  [_AST addChild:[_ASTPair root]];
	  // The new current child is the last sibling of the old root
	  [_ASTPair setChild:[_ASTPair root]];
	  [_ASTPair advanceChildToEnd];
	  // Set the new root
	  [_ASTPair setRoot:_AST];
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
//	Copy a single node.  clone() is not used because
//		we want to return an AST not a plain object...a type
//		safety issue.  Further, we want to have all AST node
//		creation go through the factory so creation can be
//		tracked.  Returns null if t is null.
-(ANTLRDefAST)dup:(ANTLRDefAST)_AST
{
  return [self createWithAST:_AST];               // if t==null, create returns null
};

//--------------------------------------------------------------------
//	Duplicate tree including siblings of root.
-(ANTLRDefAST)dupList:(ANTLRDefAST) t
{
  ANTLRDefAST result = [self dupTree:t];            // if t == null, then result==null
  ANTLRDefAST nt = result;
  while(t)                                             // for each sibling of the root
	{
	  t = [t nextSibling];
	  [nt setNextSibling:[self dupTree:t]];  // dup each subtree, building new tree
	  nt = [nt nextSibling];
	};
  return result;
};

//--------------------------------------------------------------------
//	Duplicate a tree, assuming this is a root node of a tree--
//		duplicate that node and what's below; ignore siblings of root node.
-(ANTLRDefAST)dupTree:(ANTLRDefAST)_AST
{
  ANTLRDefAST result = [self dup:_AST];         // make copy of root
  // copy all children of root.
  if (_AST)
	{
	  [result setFirstChild:[self dupList:[_AST firstChild]]];
	}
  return result;
};

//--------------------------------------------------------------------
//	Make a tree from a list of nodes.  The first element in the
//		array is the root.  If the root is null, then the tree is
//		a simple list not a tree.  Handles null children nodes correctly.
//		For example, build(a, b, null, c) yields tree (a b c).  build(null,a,b)
//		yields tree (nil a b).
-(ANTLRDefAST)make:(NSArray*)nodes
{
  ANTLRDefAST root = nil;
  LOGObjectFnStart();
  if (nodes && [nodes count]>0)
	{
	  ANTLRDefAST tail = nil;
	  int i=0;
	  root = [nodes objectAtIndex:0];
	  if (root)
		  [root setFirstChild:nil];       // don't leave any old pointers set

	  // link in children;
	  for (i=1; i<[nodes count]; i++)
		{
		  if (![nodes objectAtIndex:i])
			continue; // ignore null nodes
		  if (!root)
			// Set the root and set it up for a flat list
			root = tail = [nodes objectAtIndex:i];
		  else if (!tail)
			{
			  [root setFirstChild:[nodes objectAtIndex:i]];
			  tail = [root firstChild];
			}
		  else
			{
			  [tail setNextSibling:[nodes objectAtIndex:i]];
			  tail = [tail nextSibling];
			};
		  // Chase tail to last sibling
		  while ([tail nextSibling])
			  tail = [tail nextSibling];
		};
	};
  LOGObjectFnStop();
  return root;
};

//--------------------------------------------------------------------
//	Make a tree from a list of nodes, where the nodes are contained
//		in an ASTArray object
//        RefAST make(ASTArray* nodes);

@end


