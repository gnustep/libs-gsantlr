/* TokenBuffer.h
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

#ifndef _ANTLRTokenBuffer_h_
	#define _ANTLRTokenBuffer_h_

//	A Stream of Token objects fed to the parser from a Tokenizer that can
//		be rewound via mark()/rewind() methods.
//
//		A dynamic array is used to buffer up all the input tokens.  Normally,
//		"k" tokens are stored in the buffer.  More tokens may be stored during
//		guess mode (testing syntactic predicate), or when LT(i>k) is referenced.
//		Consumption of tokens is deferred.  In other words, reading the next
//		token is not done by conume(), but deferred until needed by LA or LT.

//		@see antlr.Token
//		@see antlr.Tokenizer
//		@see antlr.TokenQueue

@class ANTLRTokenQueue;

@interface ANTLRTokenBuffer : NSObject
{
  ANTLRDefTokenizer input; // Token source
  
  int nMarkers;         // Number of active markers
  int markerOffset;     // Additional offset used when markers are active
  int numToConsume;     // Num of consume() calls since last LA() or LT() call
  
  ANTLRTokenQueue *queue; // Circular queue
}

+(void)setTraceFlag_LA:(BOOL)_trace;
+(id)tokenBufferWithTokenizer:(ANTLRDefTokenizer)_input;
-(id)initWithTokenizer:(ANTLRDefTokenizer)_input;

// ---------------- consuming  ----------------

- (void)consume;           // Mark another token for deferred consumption
- (void)syncConsume;       // Sync up deferred consumption

// Ensure that the token buffer is sufficiently full
- (void)fill:(int)_amount; // throws IOException

// ---------------- lookahead ----------------

// Get a lookahead token value
- (int)LA:(int)_i;                   // throws IOException

// Get a lookahead token
- (ANTLRDefToken)LT:(int)_i; // throws IOException

// ---------------- marking ----------------

- (int)mark;
- (void)rewind:(int)_mark;

@end

#endif //_ANTLRTokenBuffer_h_
