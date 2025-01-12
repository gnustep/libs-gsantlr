/* CharScanner
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

#ifndef _ANTLRCharScanner_h_
	#define _ANTLRCharScanner_h_

#include <ANTLRTokenizer.h>
#include <ANTLRToken.h>
#include <ANTLRTextStreamProtocols.h>

@class NSMutableDictionary, NSMutableString;
@class ANTLRBitSet;

@class ANTLRCharBuffer;
@class ANTLRScannerException;
@class ANTLRToken;
@class ANTLRHashString;

#define ANTLR_NO_CHAR  ((unichar)0)
#define ANTLR_EOF_CHAR ((unichar)-1)

@interface ANTLRCharScanner : NSObject <ANTLRTokenizer>
{
  int                 line;                  // current line number
  NSMutableString*    text;                 // text of current token
  BOOL                saveConsumedInput;     // does consume() save characters?
  Class               tokenObjectClass;      // what kind of tokens to create?
  int                 guessing;
  BOOL                caseSensitive;
  BOOL                caseSensitiveLiterals;
  //	Used during filter mode to indicate that path is desired.
  //		A subsequent scan error will report an error as usual if acceptPath=true;
  BOOL				  commitToPath;	

@public
  NSMutableDictionary *literals;             // set by subclass

  // used to return tokens w/o using return val.
  ANTLRDefToken _returnToken;

	// Hash string used so we don't new one every time to check literals table
  ANTLRHashString*		hashString;

  ANTLRCharBuffer*		input;
  
  // method caching
  IMP _appendChar;
}
+(id)charScannerWithCharBuffer:(ANTLRCharBuffer*)_buffer;
-(id)initWithCharBuffer:(ANTLRCharBuffer*)_buffer;
-(id)initWithTextStream:(ANTLRDefTextInputStream)_in;

-(void)dealloc;
-(void)setReturnToken:(ANTLRDefToken)_token;
+(void)setTraceFlag_LA:(BOOL)_trace;

// ANTLRTokenizer

-(ANTLRDefToken)nextToken; // abstract

// modifiers

-(void)appendCharacter:(unichar)_c;
-(void)appendString:(NSString*)_string;

-(void)commit;

// ******************** accessors ***********************

-(void)setCaseSensitive:(BOOL)_flag;
-(BOOL)isCaseSensitive;

-(BOOL)hasCaseSensitiveLiterals;

-(void)setLine:(int)_line;
-(int)line;
-(void)newline;

-(void)setText:(NSString*)_string;
-(NSString*)text; // return a copy of the current text buffer
-(void)resetText;
-(ANTLRCharBuffer*)inputBuffer;
-(BOOL)isCommitToPath;
-(void)setCommitToPath:(BOOL)commit;

// ******************** tokens ***************************

-(unichar)LA:(int)_i;
-(ANTLRDefToken)makeToken:(ANTLRTokenType)_t;
-(ANTLRDefToken)tokenObject;
-(void)setTokenObjectClass:(NSString*)_className;

// ******************** matching **************************

-(void)matchCharacter:(unichar)_c;           // throws ScannerException
-(void)matchNotCharacter:(unichar)_c;        // throws ScannerException
-(void)matchRange:(unichar)_c1:(unichar)_c2; // throws ScannerException
-(void)matchCharSet:(ANTLRBitSet*)_set;        // throws ScannerException
-(void)matchString:(NSString*)_str;         // throws ScannerException

// ******************** marking ***************************

-(int)mark;
-(void)rewind:(int)_mark;

// ******************** consuming *************************

-(void)consume;

// Consume chars until one matches the given char
-(void)consumeUntilCharacter:(unichar)_c;

// Consume chars until one matches the given char
-(void)consumeUntilCharSet:(ANTLRBitSet*)_set;

// ******************** error reporting ********************

-(void)panic;
-(void)panic:(NSString*)_text;

// Report exception errors caught in nextToken()
-(void)reportErrorWithException:(NSException*)_exception; 

-(void)reportError:(NSString*)_text;
-(void)reportWarning:(NSString*)_text;

// misc

// Test the token text against the literals table
// Override this method to perform a different literals test
-(ANTLRTokenType)testLiteralsTable:(ANTLRTokenType)_ttype;

// scanner specific lowercase char
-(unichar)toLower:(unichar)_c;

// ******************** tracing ****************************

-(void)traceIn:(NSString*)_ruleName;
-(void)traceOut:(NSString*)_ruleName;

+(NSString*)charName:(int)ch;
@end

#endif //_ANTLRCharScanner_h_
