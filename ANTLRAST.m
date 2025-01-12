/* ANTLRAST.m
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
#include "ANTLRASTEnumerator.h"
#include "ANTLRASTNULLType.h"

BOOL verboseStringConversion = NO;
NSString** tokenNames = NULL;

ANTLRDefAST ANTLRASTNULL=nil;

@implementation ANTLRAST

//--------------------------------------------------------------------
+(void)initialize
{
  ANTLRASTNULL=[ASTNULLType new];
};

//--------------------------------------------------------------------
#if !ANTLR_GC
+(void)dealloc
{
  DESTROY(ANTLRASTNULL);
};
#endif

//------------------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(down);
  DESTROY(right);
  [super dealloc];
};
#endif

//--------------------------------------------------------------------
-(id)copyWithZone:(NSZone*)_zone
{
  ANTLRDefAST clone = [[isa allocWithZone:_zone] init];
  [clone setFirstChild:[down copyWithZone:_zone]];
  [clone setNextSibling:[right copyWithZone:_zone]];
  return clone;
};

//------------------------------------------------------------------------------
-(void)addChild:(ANTLRDefAST)_ast // Add a (rightmost) child to this node
{
  LOGObjectFnStart();
  if (_ast)
    {
      ANTLRAST *tmp=down;
      if (tmp)
	{
	  while (tmp->right)
	    tmp=(ANTLRAST *)tmp->right;
	  [tmp setNextSibling:_ast];
        }
      else
	[self setFirstChild:_ast];
    };
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(void)doWorkForFindAll:(NSMutableArray*) v
						target:(ANTLRDefAST)target
						partialMatch:(BOOL)partialMatch
{
  // Start walking sibling lists, looking for matches.
  ANTLRDefAST sibling=nil;
  LOGObjectFnStart();
  for (sibling=self;
	   sibling;
	   sibling=[sibling nextSibling])
	{
	  if ( (partialMatch && [sibling equalsTreePartial:target])
		   || (!partialMatch && [sibling equalsTree:target]))
		  [v addObject:sibling];

	  // regardless of match or not, check any children for matches
	  if ([sibling firstChild])
		  [[sibling firstChild] doWorkForFindAll:v
								target:target
								partialMatch:partialMatch];
	};
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(BOOL) equalsList:(ANTLRDefAST)t
{
  ANTLRDefAST sibling;
  // the empty tree is not a match of any non-null tree.
  if (t) 
	{
	  // Otherwise, start walking sibling lists.  First mismatch, return NO.
	  for (sibling = self;
		   sibling && t;
		   sibling = [sibling nextSibling], t = [t nextSibling])
		{
		  // as a quick optimization, check roots first.
		  if (![sibling isEqualToAST:t])
			  return NO;
		  else
			{
			  // if roots match, do full list match test on children.
			  if ([sibling firstChild])
				{
				  if (![[sibling firstChild] equalsList:[t firstChild]])
					return NO;
				}
			  // sibling has no kids, make sure t doesn't either
			  else if ([t firstChild])
				return NO;
			};
        };
        if (!sibling && !t)
		  return YES;
	};
  // one sibling list has more than the other
  return NO;
};

//------------------------------------------------------------------------------
//	Is 'sub' a subtree of this list?
//		The siblings of the root are NOT ignored.
-(BOOL) equalsListPartial:(ANTLRDefAST) sub
{
  // the empty tree is always a subset of any tree.
  if (sub)
	{
	  ANTLRDefAST sibling;
	  // Otherwise, start walking sibling lists.  First mismatch, return NO.
	  for (sibling=self;
		   sibling && sub;
		   sibling=[sibling nextSibling], sub=[sub nextSibling])
        {
		  // as a quick optimization, check roots first.
		  if ([sibling tokenType] != [sub tokenType])
			return NO;
		  else if ([sibling firstChild]) // if roots match, do partial list match test on children.
			{
			  if (![[sibling firstChild] equalsListPartial:[sub firstChild]] )
				return NO;
			};
        };
        if (!sibling && sub)
		  // nothing left to match in this tree, but subtree has more
		  return NO;
	};
  // either both are null or sibling has more, but subtree doesn't        
  return YES;
};

//------------------------------------------------------------------------------
//	Is tree rooted at 'this' equal to 't'?  The siblings
//		of 'this' are ignored.
-(BOOL)equalsTree:(ANTLRDefAST)t
{
  // check roots first.
  if (![self isEqualToAST:t])
	return NO;
  else if ([self firstChild]) // if roots match, do full list match test on children.
	{
	  if (![[self firstChild] equalsList:[t firstChild]]) 
		return NO;
	}
  else if ([t firstChild]) // sibling has no kids, make sure t doesn't either
	return NO;
  return YES;            
};

//------------------------------------------------------------------------------
-(BOOL)equalsTreePartial:(ANTLRDefAST)sub
{
  // the empty tree is always a subset of any tree.
  if (sub)
	{
	  // check roots first.
	  if (![self isEqualToAST:sub])
		return NO;
	  else if ([self firstChild]) // if roots match, do full list partial match test on children.
		{
		  if (![[self firstChild] equalsListPartial:[sub firstChild]])
			return NO;
		};
	};
  return YES;            
}

//------------------------------------------------------------------------------
//	Walk the tree looking for all exact subtree matches.  Return
//		an ASTEnumerator that lets the caller walk the list
//		of subtree roots found herein.
-(ANTLRASTEnumerator*)findAll:(ANTLRDefAST)target
{
  ANTLRASTEnumerator* enumerator=nil;
  LOGObjectFnStart();
  // the empty tree cannot result in an enumeration
  if (target)
	{
	  NSMutableArray* roots = AUTORELEASE([NSMutableArray new]);
	  [self doWorkForFindAll:roots
			target:target
			partialMatch:NO];  // find all matches recursively
	  enumerator= [[ANTLRASTEnumerator alloc] initWithNodes:roots];
	};
  LOGObjectFnStop();
  return enumerator;
};

//------------------------------------------------------------------------------
//	Walk the tree looking for all subtrees.  Return
//		an ASTEnumerator that lets the caller walk the list
//		of subtree roots found herein.
-(ANTLRASTEnumerator*) findAllPartial:(ANTLRDefAST) sub
{
  ANTLRASTEnumerator* enumerator=nil;
  LOGObjectFnStart();
  // the empty tree cannot result in an enumeration
  if (sub)
	{
	  NSMutableArray* roots = AUTORELEASE([NSMutableArray new]);
	  [self doWorkForFindAll:roots
			target:sub
			partialMatch:YES];  // find all matches recursively
	  enumerator= [[ANTLRASTEnumerator alloc] initWithNodes:roots];
	};
  LOGObjectFnStop();
  return enumerator;
};

//------------------------------------------------------------------------------
//	Remove all children
-(void)removeChildren
{
  LOGObjectFnStart();
  ASSIGN(down,nil);
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
+(void)setVerboseStringConversion:(BOOL)verbose
						withNames:(NSString**) names
{
  verboseStringConversion = verbose;
  tokenNames = names;
};

//------------------------------------------------------------------------------
-(BOOL)isEqualToAST:(ANTLRDefAST)_ast
{
  if (!_ast)
	return NO;
  else
	return [self tokenType] == [_ast tokenType];
}

//------------------------------------------------------------------------------
// Set/Get the first child of this node; null if no children
-(void)setFirstChild:(ANTLRDefAST)_child
{
  LOGObjectFnStart();
  ASSIGN(down,_child);
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(ANTLRDefAST)firstChild
{
  return down;
};

//------------------------------------------------------------------------------
// Set/Get the next sibling in line after this one
-(void)setNextSibling:(ANTLRDefAST)_next
{
  LOGObjectFnStart();
  ASSIGN(right,_next);
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
-(ANTLRDefAST)nextSibling
{
  return right;
};

//------------------------------------------------------------------------------
// Set/Get the token text for this node
-(void)setText:(NSString *)_text
{
};
//------------------------------------------------------------------------------
-(NSString*)text
{
  return @"";
};

//------------------------------------------------------------------------------
// Set/Get the token type for this node
- (void)setTokenType:(ANTLRTokenType)_type;
{
};

//------------------------------------------------------------------------------
- (ANTLRTokenType)tokenType
{
  return 0;
};

//------------------------------------------------------------------------------
-(void)setWithToken:(ANTLRDefToken)_token
{
  LOGObjectFnStart();
  [self setTokenType:[_token tokenType]];
  [self setText:[_token text]];
  LOGObjectFnStop();
};

//------------------------------------------------------------------------------
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
   // if verbose and type name not same as text (keyword probably)
   if ( verboseStringConversion &&
		[[self text] caseInsensitiveCompare:tokenNames[[self tokenType]]]!=NSOrderedSame &&
		[[self text] caseInsensitiveCompare:[[tokenNames[[self tokenType]] stringByDeletingSuffix:@"\""] stringByDeletingPrefix:@"\""]]!=NSOrderedSame)
	 {
	   NSString* string=[NSString stringWithFormat:@"[%@,<%@>]",
								  [self text],
								  tokenNames[[self tokenType]]];
	   //return string.toString();
	   return string;
	 }
   else
	 return [self text];
}

//------------------------------------------------------------------------------
//	Print out a child-sibling tree in LISP notation
-(NSString*)toStringList
{
  return [self toStringListWithSiblingSeparator:@" "
			   openSeparator:@" ("
			   closeSeparator:@" )"];
};

//------------------------------------------------------------------------------
-(NSString*)toStringListWithSiblingSeparator:(NSString*)_siblingSep
							   openSeparator:(NSString*)_openSep
							  closeSeparator:(NSString*)_closeSep
  
{
  ANTLRDefAST t = self;
  NSString* ts=AUTORELEASE([NSString new]);
  LOGObjectFnStart();
  if ([t firstChild])
	ts=[ts stringByAppendingString:_openSep];

  ts=[ts stringByAppendingFormat:@"%@%@",
		 _siblingSep,
		 [self toString]];

  if ([t firstChild])
	  ts=[ts stringByAppendingString:
			   [[t firstChild] 
				 toStringListWithSiblingSeparator:_siblingSep
				 openSeparator:_openSep
				 closeSeparator:_closeSep]];

  if ([t firstChild])
	ts=[ts stringByAppendingString:_closeSep];

  if ([t nextSibling])
	  ts=[ts stringByAppendingString:
			   [[t nextSibling]
				 toStringListWithSiblingSeparator:_siblingSep
							   openSeparator:_openSep
							  closeSeparator:_closeSep]];
  LOGObjectFnStop();
  return ts;
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
  LOGObjectFnStop();
  return ts;
};

@end
