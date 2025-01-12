/* ANTLRParser.m
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

@implementation ANTLRParser

//--------------------------------------------------------------------
-(id)initWithTokenBuffer:(ANTLRTokenBuffer *)_buffer
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  [self setTokenBuffer:_buffer];
	  [self setASTFactory:AUTORELEASE([ANTLRASTFactory new])];
	};
  LOGObjectFnStop();
  return self;
}
  
//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(input);
  DESTROY(astFactory);
  DESTROY(returnAST);
  tokenNames = NULL;
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
// lookahead
-(int)LA:(int)_i
{ // abstract
  [self subclassResponsibility:_cmd];
  return -1;
}

//--------------------------------------------------------------------
-(ANTLRDefToken)LT:(int)_i
{ // abstract
  [self subclassResponsibility:_cmd];
  return nil;
}

//--------------------------------------------------------------------
-(void)setTokenNames:(NSString**)tokenNames_
{
  LOGObjectFnStart();
  tokenNames=tokenNames_;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(NSString**)tokenNames
{
  return tokenNames;
};

//--------------------------------------------------------------------
-(void)setTokenObjectClass:(NSString*)_tokenClass
{
};

//--------------------------------------------------------------------
// TokenBuffer
- (void)setTokenBuffer:(ANTLRTokenBuffer *)_buffer
{
  LOGObjectFnStart();
  ASSIGN(input, _buffer);
  
  if (_buffer != nil)
	{
	  _inputLA = [_buffer methodForSelector:@selector(LA:)];
	  _inputLT = [_buffer methodForSelector:@selector(LT:)];
  }
  else
	{
	  _inputLA = NULL;
	  _inputLT = NULL;
	}
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(int)mark
{
  return [input mark];
}

//--------------------------------------------------------------------
-(void)rewind:(int)_position
{
  LOGObjectFnStart();
  [input rewind:_position];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
// consuming
- (void)consume
{ // abstract
  // Get another token object from the token stream
  [self subclassResponsibility:_cmd];
}

//--------------------------------------------------------------------
-(void)consumeUntilTokenType:(ANTLRTokenType)_token
{
  LOGObjectFnStart();
  // Consume tokens until one matches the given token
  
  while (([self LA:1] != ANTLRToken_EOF_TYPE) && ([self LA:1] != _token))
    [self consume];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)consumeUntilTokenBitSet:(ANTLRBitSet*)_set
{
  LOGObjectFnStart();
  // Consume tokens until one matches the given token set 
  while (([self LA:1] != ANTLRToken_EOF_TYPE) && (![_set isMember:[self LA:1]]))
    [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
// matching
-(void)matchTokenType:(ANTLRTokenType)_token // throws ANTLRMismatchedTokenException
{
  LOGObjectFnStart();
  // Make sure current lookahead symbol matches token type _token
  // Throw an exception upon mismatch, which is catch by either the
  // error handler or by the syntactic predicate.
  if ([self LA:1] != _token)
	  [ANTLRMismatchedTokenException raiseWithTokenNames:tokenNames
									 expectedTokenType:_token
									 token:[self LT:1]
									 matchNot:NO];
  else
	  // mark token as consumed -- fetch next token deferred until LA/LT
	  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchNotTokenType:(ANTLRTokenType)_token
{ // throws ANTLRMismatchedTokenException
  LOGObjectFnStart();
  if ([self LA:1] == _token)
	  [ANTLRMismatchedTokenException raiseWithTokenNames:tokenNames
									 expectedTokenType:_token
									 token:[self LT:1]
									 matchNot:YES];
  else
	  // mark token as consumed -- fetch next token deferred until LA/LT
	  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchTokenBitSet:(ANTLRBitSet*)_set
{ // throws ANTLRMismatchedTokenException
  // Make sure current lookahead symbol matches the given set
  // Throw an exception upon mismatch, which is catch by either the
  // error handler or by the syntactic predicate.
  LOGObjectFnStart();

  if (![_set isMember:[self LA:1]])
	  [ANTLRMismatchedTokenException raiseWithTokenNames:tokenNames
									 expectedTokenBitSet:_set
									 token:[self LT:1]
									 matchNot:NO];
  else
	  // mark token as consumed -- fetch next token deferred until LA/LT
	  [self consume];
  LOGObjectFnStop();
};

// ******************** AST *************************

//--------------------------------------------------------------------
-(void)setASTNodeType:(NSString *)_nodeType
{
  LOGObjectFnStart();
  [astFactory setASTNodeType:_nodeType];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)setASTNodeClass:(NSString *)_nodeClass
{
  LOGObjectFnStart();
  [self setASTNodeType:_nodeClass];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)setASTFactory:(ANTLRDefASTFactory)_factory
{
  LOGObjectFnStart();
  ASSIGN(astFactory, _factory);
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(ANTLRDefASTFactory)ASTFactory
{
  return astFactory;
}

//--------------------------------------------------------------------
-(ANTLRDefAST)AST
{
  return returnAST;
}

// ******************** tool ************************

//--------------------------------------------------------------------
-(void)panic
{
  LOGObjectFnStart();
  [ANTLRLogErr writeString:@"Parser: panic\n"];
  [NSException raise:@"Parser"
			   format:@"panic"];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)reportErrorWithException:(NSException*)_exception
{
  [ANTLRLogErr writeString:@"Error: "];
  [ANTLRLogErr writeFormat:@"%@ (Reason:%@)",
				[_exception description],
				[_exception reason]];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
-(void)reportError:(NSString*)_text
{
  [ANTLRLogErr writeString:@"Error: "];
  [ANTLRLogErr writeString:_text];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
-(void)reportWarning:(NSString *)_text
{
  [ANTLRLogErr writeString:@"Warning: "];
  [ANTLRLogErr writeString:_text];
  [ANTLRLogErr writeNewline];
}

//--------------------------------------------------------------------
// tracing
-(void)traceIn:(NSString *)_ruleName
{
  [ANTLRLogOut writeFormat:@"Parser enter %@; LA(1)== %@%s\n",
			   _ruleName, [[self LT:1] text],
			   guessing ? " [guessing]" : ""];
}

//--------------------------------------------------------------------
-(void)traceOut:(NSString *)_ruleName
{
  [ANTLRLogOut writeFormat:@"Parser leave %@; LA(1)== %@%s\n",
			   _ruleName, [[self LT:1] text],
			   guessing ? " [guessing]" : ""];
}

// ---------------- Debug ------------------

//--------------------------------------------------------------------
-(void)defaultDebuggingSetupTokenizer:(ANTLRDefTokenizer)lexer
						  tokenBuffer:(ANTLRTokenBuffer*)tokBuf
{
  // by default, do nothing -- we're not debugging
};

//--------------------------------------------------------------------
-(void)setIgnoreInvalidDebugCalls:(BOOL)_value
{
  ignoreInvalidDebugCalls = _value;
};

//--------------------------------------------------------------------
-(BOOL)isDebugMode
{
  return NO;
};

//--------------------------------------------------------------------
-(void)setDebugMode:(BOOL)debugMode
{
  if (!ignoreInvalidDebugCalls)
	[NSException  raise:@"Parser"
				  format:@"setDebugMode() only valid if parser built for debugging"];
};

@end
