/* MismatchedTokenException.h
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

#ifndef _ANTLRMismatchedTokenException_h_
	#define _ANTLRMismatchedTokenException_h_

#include <ANTLRAST.h>

@class ANTLRBitSet;

typedef enum {
  ANTLRMismatchTokenType_TOKEN = 1,
  ANTLRMismatchTokenType_NOT_TOKEN,
  ANTLRMismatchTokenType_RANGE,
  ANTLRMismatchTokenType_NOT_RANGE,
  ANTLRMismatchTokenType_SET,
  ANTLRMismatchTokenType_NOT_SET
} ANTLRMismatchTokenType;

@interface ANTLRMismatchedTokenException : ANTLRParserException
{
  NSString**				tokenNames; // Token names array for formatting
  ANTLRDefToken				token;        // The token that was encountered
  ANTLRDefAST				ast;		// The offending AST node if tree walking
  NSString*					tokenText; // taken from node or token object
  ANTLRMismatchTokenType	mismatchType;

  ANTLRTokenType   			expecting;    // For TOKEN/NOT_TOKEN and RANGE/NOT_RANGE
  ANTLRTokenType			upper;        // For RANGE/NOT_RANGE(expecting is lower bound of range)
  ANTLRBitSet*				set;         // For SET/NOT_SET
}

+(void)raiseWithTokenNames:(NSString**)_tokenNames
			 expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag;

+(void)raiseWithTokenNames:(NSString**)_tokenNames
		 expectedTokenType:(ANTLRTokenType)_tokenType
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag;

+(void)raiseWithTokenNames:(NSString**)_tokenNames
	   expectedTokenBitSet:(ANTLRBitSet*)_set
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString **)_tokenNames
		   expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString **)_tokenNames
	   expectedTokenType:(ANTLRTokenType)_tokenType
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString**)_tokenNames
	 expectedTokenBitSet:(ANTLRBitSet*)_set
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag;

+(void)raiseWithTokenNames:(NSString**)_tokenNames
		 expectedTokenType:(ANTLRTokenType)_tokenType
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag;

+(void)raiseWithTokenNames:(NSString**)_tokenNames
	   expectedTokenBitSet:(ANTLRBitSet*)_set
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag;

+(void)raiseWithTokenNames:(NSString **)_tokenNames
			 expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString **)_tokenNames
	   expectedTokenType:(ANTLRTokenType)_tokenType
				   token:(ANTLRDefToken)_token
				matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString**)_tokenNames
	 expectedTokenBitSet:(ANTLRBitSet*)_set
				   token:(ANTLRDefToken)_token
				matchNot:(BOOL)_flag;

- (id)initWithTokenNames:(NSString **)_tokenNames
		   expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
				   token:(ANTLRDefToken)_token
				matchNot:(BOOL)_flag;

-(NSString*)description;
@end


#endif //_ANTLRMismatchedTokenException_h_
