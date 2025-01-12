/* ANTLRNoViableException.m
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


@implementation ANTLRNoViableAltException

//--------------------------------------------------------------------
+(void)raiseWithToken:(ANTLRDefToken)_token
{
  id exception=[[ANTLRNoViableAltException alloc]initWithToken:_token];
  [exception raise];
};

//--------------------------------------------------------------------
+(void)raiseWithAST:(ANTLRDefAST)_AST
{
  id exception=[[ANTLRNoViableAltException alloc]initWithAST:_AST];
  [exception raise];
};


//--------------------------------------------------------------------
-(id)init
{
  return [self initWithName:@"ANTLRNoViableAltException"
			   reason:@"no viable alternate"
			   userInfo:nil];
};

//--------------------------------------------------------------------
-(id)initWithToken:(ANTLRDefToken)_token
{
  NSString* tmp = nil;
  LOGObjectFnStart();
  tmp=[NSString stringWithFormat:@"no viable alternate for token %@",
				[_token description]];
  if ((self = [self initWithName:@"ANTLRNoViableAltException"
					reason:tmp
					userInfo:nil]))
	{
	  ASSIGN(token, _token);
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithAST:(ANTLRDefAST)_AST
{
  NSString* tmp = nil;
  LOGObjectFnStart();
  tmp=[NSString stringWithFormat:@"no viable alternate for token %@",
							[_AST description]];
  if ((self = [self initWithName:@"ANTLRNoViableAltException"
					reason:tmp
					userInfo:nil]))
	{
	  ASSIGN(AST, _AST);
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_DESTROY(token);
  ANTLR_DESTROY(AST);
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
// accessors
-(ANTLRDefToken)token
{
  return token;
};

//--------------------------------------------------------------------
-(ANTLRDefAST)AST
{
  return AST;
};

//--------------------------------------------------------------------
-(NSString*)description
{
  if (token)
	  return [NSString stringWithFormat:@"line(%i), unexpected token: %@",
					   [token line],
					   [token text]];
  else if (AST==ANTLRASTNULL) // must a tree parser error if token==null
	return @"unexpected end of subtree";
  else
	return [NSString stringWithFormat:@"unexpected AST node: %@",
					 [AST toString]];
};

@end
