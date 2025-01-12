/* ANTLRASTPair.m
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
#include "ANTLRAST.h"
#include "ANTLRASTPair.h"

@implementation ANTLRASTPair

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(root);
  DESTROY(child);
  [super dealloc];
};
#endif
//--------------------------------------------------------------------
// Make sure that child is the last sibling
-(void)advanceChildToEnd
{
  LOGObjectFnStart();
  if (child)
	  while ([child nextSibling])
		  [self setChild:[child nextSibling]];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(ANTLRDefAST)root
{
  return root;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)child
{
  return child;
};

//--------------------------------------------------------------------
-(void)setRoot:(ANTLRDefAST)_root
{
  LOGObjectFnStart();
  ASSIGN(root,_root);
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)setChild:(ANTLRDefAST)_child
{
  LOGObjectFnStart();
  ASSIGN(child,_child);
  LOGObjectFnStop();
};

-(NSString*)description
{
  return [NSString stringWithFormat:@"[%@,%@]",
                root ? [root text] : @"nil",
                child ? [child text] : @"nil"];
};

//--------------------------------------------------------------------
-(id)copyWithZone:(NSZone*)_zone
{
  ANTLRASTPair* clone = [[isa allocWithZone:_zone] init];
  [clone setRoot:[root copyWithZone:_zone]];
  [clone setChild:[child copyWithZone:_zone]];
  return clone;
};

@end


