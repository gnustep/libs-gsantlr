/*
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

#ifndef _ANTLRTreeParser_h_
	#define _ANTLRTreeParser_h_

@interface ANTLRTreeParser : NSObject
{
  ANTLRDefAST _retTree;
        
  // guessing nesting level; guessing==0 implies not guessing
  int guessing; // = 0;
  
  // Nesting level of registered handlers
  int exceptionLevel; // = 0;
  
  // Table of token type to token names
  NSString** tokenNames;

  // AST return value for a rule is squirreled away here
  ANTLRDefAST returnAST;

  // AST support code; parser and treeparser delegate to this object
  ANTLRDefASTFactory astFactory;
};

-(id)init;
-(void)dealloc;

// Get the AST return value squirreled away in the parser
-(ANTLRDefAST)ast;


-(void)setTokenNames:(NSString**)tokenNames_;

-(void)matchAST:(ANTLRDefAST)t
	  tokenType:(ANTLRTokenType)_ttype;

//	Make sure current lookahead symbol matches the given set
//		Throw an exception upon mismatch, which is catch by either the
//		error handler or by the syntactic predicate.
-(void)matchAST:(ANTLRDefAST)t
	   tokenSet:(ANTLRBitSet*)_set; // throws ANTLRMismatchedTokenException

-(void)matchNotAST:(ANTLRDefAST)t
		 tokenType:(ANTLRTokenType)_ttype;

-(void)panic;

//	Parser error-reporting function can be overridden in subclass
-(void)reportErrorWithException:(NSException*)_exception;

//	Parser error-reporting function can be overridden in subclass
-(void)reportError:(NSString *)_text;

//	Parser warning-reporting function can be overridden in subclass
-(void)reportWarning:(NSString *)_text;

//	Specify an object with support code (shared by
//		Parser and TreeParser.  Normally, the programmer
//		does not play with this, using setASTNodeType instead.
-(void)setASTFactory:(ANTLRDefASTFactory)_factory;

// Specify the type of node to create during tree building
-(void)setASTNodeType:(NSString*)_nodeType;


// ---------- tracing -------------

-(void)traceIn:(NSString*)_ruleName;
-(void)traceOut:(NSString*)_ruleName;
@end

#endif //_ANTLRTreeParser_h_
