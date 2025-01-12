/* ANTLRTreeParser.h
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
#include "ANTLRTreeParser.h"



@implementation ANTLRTreeParser

//--------------------------------------------------------------------
-(id)init
{
  LOGObjectFnStart();
  self=[super init];
  [self setASTFactory:AUTORELEASE([ANTLRASTFactory new])];
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(_retTree);
  DESTROY(returnAST);
  DESTROY(astFactory);
  [super dealloc];
};
#endif

//--------------------------------------------------------------------
-(void)setTokenNames:(NSString**)tokenNames_
{
  LOGObjectFnStart();
  tokenNames=tokenNames_;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
//	Get the AST return value squirreled away in the parser
-(ANTLRDefAST)ast;
{
  return returnAST;
};

//--------------------------------------------------------------------
-(void)matchAST:(ANTLRDefAST)t
	  tokenType:(ANTLRTokenType)_ttype;
{
  LOGObjectFnStart();
  if (!t || t==ANTLRASTNULL || [t tokenType]!=_ttype)
	{
	  [ANTLRMismatchedTokenException raise];
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
//	Make sure current lookahead symbol matches the given set
//		Throw an exception upon mismatch, which is catch by either the
//		error handler or by the syntactic predicate.
-(void)matchAST:(ANTLRDefAST)t
	   tokenSet:(ANTLRBitSet *)_set
{
  LOGObjectFnStart();
  if (!t || t==ANTLRASTNULL || ![_set isMember:[t tokenType]] )
	{
	  [ANTLRMismatchedTokenException raise];
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchNotAST:(ANTLRDefAST)t
		 tokenType:(ANTLRTokenType)_ttype
{
  LOGObjectFnStart();
  if ( !t || t==ANTLRASTNULL || [t tokenType]==_ttype )
	{
	  [ANTLRMismatchedTokenException raise];
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)panic
{
  [ANTLRLogErr writeString:@"TreeWalker: panic\n"];
  [NSException raise:@"TreeWalker"
			   format:@"panic"];
};

//--------------------------------------------------------------------
//	Parser error-reporting function can be overridden in subclass
- (void)reportErrorWithException:(NSException*)_exception
{
  [ANTLRLogErr writeString:@"Error: "];
  [ANTLRLogErr writeFormat:@"Exception %@ (Reason:%@)",
			   [_exception description],
			   [_exception reason]];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
//	Parser error-reporting function can be overridden in subclass
- (void)reportError:(NSString *)_text
{
  [ANTLRLogErr writeString:@"Error: "];
  [ANTLRLogErr writeString:_text];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
//	Parser warning-reporting function can be overridden in subclass
- (void)reportWarning:(NSString *)_text
{
  [ANTLRLogErr writeString:@"Warning: "];
  [ANTLRLogErr writeString:_text];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
//	Specify an object with support code (shared by
//		Parser and TreeParser.  Normally, the programmer
//		does not play with this, using setASTNodeType instead.
-(void)setASTFactory:(ANTLRDefASTFactory)_factory
{
  LOGObjectFnStart();
  ASSIGN(astFactory, _factory);
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
//	Specify the type of node to create during tree building
-(void)setASTNodeType:(NSString*)_type
{
  LOGObjectFnStart();
  [astFactory setASTNodeType:_type];
  LOGObjectFnStop();
};

// ----------------- tracing -----------------------------------------

//--------------------------------------------------------------------
- (void)traceIn:(NSString *)_ruleName
{
  [ANTLRLogOut writeFormat:@"TreeParser enter %@ %s\n",
			   _ruleName,
			   guessing ? " [guessing]" : ""];
};

//--------------------------------------------------------------------
- (void)traceOut:(NSString *)_ruleName
{
  [ANTLRLogOut writeFormat:@"TreeParser leave %@; %s\n",
			   _ruleName,
			   guessing ? " [guessing]" : ""];
};

@end

