/* Parser.h
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

#ifndef _ANTLRParser_h_
	#define _ANTLRParser_h_

//	A generic ANTLR parser (LL(k) for k>=1) containing a bunch of
//		utility routines useful at any lookahead depth.  We distinguish between
//		the LL(1) and LL(k) parsers because of efficiency.  This may not be
//		necessary in the near future.
//
//		Each parser object contains the state of the parse including a lookahead
//		cache (the form of which is determined by the subclass), whether or
//		not the parser is in guess mode, where tokens come from, etc...
//
//		During _guess_ mode, the current lookahead token(s) and token type(s)
//		cache must be saved because the token stream may not have been informed
//		to save the token (via -mark) before the TRY block.
//		Guessing is started by:
//		  saving the lookahead cache.
//		  marking the current position in the TokenBuffer.
//		  increasing the guessing level.
//
//		After guessing, the parser state is restored by:
//		  restoring the lookahead cache.
//		  rewinding the TokenBuffer.
//		  decreasing the guessing level.


#include <ANTLRAST.h>
#include <ANTLRASTFactory.h>
#include <ANTLRToken.h>

@class ANTLRBitSet;
@class ANTLRTokenBuffer;
@class ANTLRParserException;

@interface ANTLRParser : NSObject // abstract
{
  ANTLRTokenBuffer*	input;         // Where to get token objects
  BOOL				guessing;       // Are we guessing ?
  int				exceptionLevel; // Nesting level of registered handlers
  NSString**		tokenNames;   // Table of token type to token names

  ANTLRDefAST        returnAST;
  ANTLRDefASTFactory astFactory;

  BOOL				ignoreInvalidDebugCalls;

  IMP _inputLA;
  IMP _inputLT;
}

-(id)initWithTokenBuffer:(ANTLRTokenBuffer*)_buffer;

-(void)setTokenNames:(NSString**)tokenNames_;
-(NSString**)tokenNames;
-(void)setTokenObjectClass:(NSString*)_tokenClass;

// ----------------- lookahead -----------------

-(ANTLRTokenType)LA:(int)_i;                    // abstract, throws IOException
-(ANTLRDefToken)LT:(int)_i;  // abstract, throws IOException

// ----------------- TokenBuffer ----------------

-(void)setTokenBuffer:(ANTLRTokenBuffer *)_buffer;
-(int)mark;
-(void)rewind:(int)_position;

// ----------------- consuming -----------------

// abstract, Get another token object from the token stream
-(void)consume; // abstract, throws IOException

// Consume tokens until one matches the given token
-(void)consumeUntilTokenType:(ANTLRTokenType)_token; // throws IOException
// Consume tokens until one matches the given token set 
-(void)consumeUntilTokenBitSet:(ANTLRBitSet*)_set; // throws IOException

// ----------------- matching -----------------

// Make sure current lookahead symbol matches token type <tt>t</tt>.
// Throw an exception upon mismatch, which is catch by either the
// error handler or by the syntactic predicate.
-(void)matchTokenType:(ANTLRTokenType)_token;    // throws ANTLRMismatchedTokenException, IOException
-(void)matchNotTokenType:(ANTLRTokenType)_token; // throws ANTLRMismatchedTokenException, IOException

// Make sure current lookahead symbol matches the given set
// Throw an exception upon mismatch, which is catch by either the
// error handler or by the syntactic predicate.
-(void)matchTokenBitSet:(ANTLRBitSet *)_set; // throws ANTLRMismatchedTokenException, IOException

// ----------------- AST -----------------

-(void)setASTNodeClass:(NSString*)_nodeClass;
-(void)setASTNodeType:(NSString*)_nodeClass;
-(void)setASTFactory:(ANTLRDefASTFactory)_factory;
-(ANTLRDefASTFactory)ASTFactory;
-(ANTLRDefAST)AST;

// ----------------- tool -----------------

-(void)panic;
-(void)reportErrorWithException:(NSException*)_exception;
-(void)reportError:(NSString*)_text;
-(void)reportWarning:(NSString*)_text;

// ----------------- tracing -----------------

-(void)traceIn:(NSString*)_ruleName;
-(void)traceOut:(NSString*)_ruleName;

// ---------------- Debug ------------------
-(void)defaultDebuggingSetupTokenizer:(ANTLRDefTokenizer)lexer
						  tokenBuffer:(ANTLRTokenBuffer*)tokBuf;
-(void)setIgnoreInvalidDebugCalls:(BOOL)_value;
-(BOOL)isDebugMode;
-(void)setDebugMode:(BOOL)debugMode;
/*
-(void)addMessageListener:(ANTLRMessageListener*)l;
-(void)addParserListener:(ANTLRParserListener*)l;
-(void)addParserMatchListener:(ANTLRParserMatchListener*)l;
-(void)addParserTokenListener:(ANTLRParserTokenListener*)l;
-(void)addSemanticPredicateListener:(ANTLRSemanticPredicateListener*)l;
-(void)addSyntacticPredicateListener:(ANTLRSyntacticPredicateListener*)l;
-(void)addTraceListener:(ANTLRTraceListener*)l;
-(void)removeMessageListener:(ANTLRMessageListener*)l;
-(void)removeParserListener:(ANTLRParserListener*)l;
-(void)removeParserMatchListener:(ANTLRParserMatchListener*)l;
-(void)removeParserTokenListener:(ANTLRParserTokenListener*)l;
-(void)removeSemanticPredicateListener:(ANTLRSemanticPredicateListener*)l;	
-(void)removeSyntacticPredicateListener:(ANTLRSyntacticPredicateListener*)l;
-(void)removeTraceListener:(ANTLRTraceListener*)l;
*/
@end


#endif //_ANTLRParser_h_

