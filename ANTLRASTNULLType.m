/* ANTLRASTNULLType.m
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
#include "ANTLRASTNULLType.h"


@implementation ASTNULLType

//--------------------------------------------------------------------
-(id)initWithTokenType:(ANTLRTokenType)_ttype
				  text:(NSString*)_text
{
  LOGObjectFnStart();
  if ((self=[super init]))
	{
	  NSAssert(!_ttype,@"ASTNULLType can't be initialized with type");
	  NSAssert(!_text,@"ASTNULLType can't be initialized with text");
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithAST:(ANTLRDefAST)_AST
{
  LOGObjectFnStart();
  if ((self=[super init]))
	{
	  NSAssert(!_AST,@"ASTNULLType can't be initialized with AST");
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithToken:(ANTLRDefToken)_token;
{
  LOGObjectFnStart();
  if ((self=[super init]))
	{
	  NSAssert(!_token,@"ASTNULLType can't be initialized with token");
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)copyWithZone:(NSZone*)_zone
{
  ANTLRDefAST clone = [[isa allocWithZone:_zone] init];
  return clone;
};

//--------------------------------------------------------------------
-(void)addChild:(ANTLRDefAST)c
{
  LOGObjectFnStart();
  LOGObjectFnStop();
};


//------------------------------------------------------------------------------
-(void)doWorkForFindAll:(NSMutableArray*) v
						target:(ANTLRDefAST)target
						partialMatch:(BOOL)partialMatch
{
  LOGObjectFnStart();
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(BOOL) equalsList:(ANTLRDefAST)t
{
  return NO;
};

//------------------------------------------------------------------------------
//	Is 'sub' a subtree of this list?
//		The siblings of the root are NOT ignored.
-(BOOL) equalsListPartial:(ANTLRDefAST) sub
{
  return NO;
};

//------------------------------------------------------------------------------
//	Is tree rooted at 'this' equal to 't'?  The siblings
//		of 'this' are ignored.
-(BOOL)equalsTree:(ANTLRDefAST)t
{
  return NO;
};

//------------------------------------------------------------------------------
-(BOOL)equalsTreePartial:(ANTLRDefAST)sub
{
  return NO; 
}

//------------------------------------------------------------------------------
//	Walk the tree looking for all exact subtree matches.  Return
//		an ASTEnumerator that lets the caller walk the list
//		of subtree roots found herein.
-(ANTLRASTEnumerator*)findAll:(ANTLRDefAST)target
{
  return nil;
};

//------------------------------------------------------------------------------
//	Walk the tree looking for all subtrees.  Return
//		an ASTEnumerator that lets the caller walk the list
//		of subtree roots found herein.
-(ANTLRASTEnumerator*) findAllPartial:(ANTLRDefAST) sub
{
  return nil;
};

//------------------------------------------------------------------------------
//	Remove all children
-(void)removeChildren
{
};

//------------------------------------------------------------------------------
+(void)setVerboseStringConversion:(BOOL)verbose
						withNames:(NSString**) names
{
};

//--------------------------------------------------------------------
-(BOOL)isEqualToAST:(ANTLRDefAST)_ast
{
  return NO;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)firstChild
{
  return self;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)nextSibling
{
  return self;
};

//--------------------------------------------------------------------
-(void)setFirstChild:(ANTLRDefAST)c
{
};

//--------------------------------------------------------------------
-(void)setNextSibling:(ANTLRDefAST)n
{
};

//--------------------------------------------------------------------
-(NSString*)text
{
  return @"<ASTNULL>";
};

//--------------------------------------------------------------------
-(void)setText:(NSString*)_text
{
};

//--------------------------------------------------------------------
-(void)setTokenType:(ANTLRTokenType)_type
{
};

//--------------------------------------------------------------------
-(ANTLRTokenType)tokenType
{
  return ANTLRToken_NULL_TREE_LOOKAHEAD;
};

//--------------------------------------------------------------------
-(void)setWithToken:(ANTLRDefToken)_token
{
  LOGObjectFnStart();
  [self setTokenType:[_token tokenType]];
  [self setText:[_token text]];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)setWithAST:(ANTLRDefAST)_AST
{
  LOGObjectFnStart();
  [self setTokenType:[_AST tokenType]];
  [self setText:[_AST text]];
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(NSString*)description
{
  return [self toString];
};

//------------------------------------------------------------------------------
-(NSString*)toString
{
  return [self text];
}

//------------------------------------------------------------------------------
//	Print out a child-sibling tree in LISP notation
-(NSString*)toStringList
{
  return [self text];
}

//------------------------------------------------------------------------------
-(NSString*)toStringTree
{
  ANTLRDefAST t = self;
  NSString* ts=AUTORELEASE([NSString new]);
  LOGObjectFnStart();
  if ([t firstChild])
	ts=[ts stringByAppendingString:@" ("];

  ts=[ts stringByAppendingFormat:@" %@",
		  [self toString]];

  if ([t firstChild])
	  ts=[ts stringByAppendingString:[[t firstChild] toStringList]];

  if ([t firstChild])
	ts=[ts stringByAppendingString:@" )"];

  if ([t nextSibling])
	  ts=[ts stringByAppendingString:[[t nextSibling] toStringList]];
  LOGObjectFnStop();
  return ts;
};
//------------------------------------------------------------------------------
-(NSString*)toStringListWithSiblingSeparator:(NSString*)_siblingSep
			       openSeparator:(NSString*)_openSep
			      closeSeparator:(NSString*)_closeSep
{
  return nil;
}
@end

