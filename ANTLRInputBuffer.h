/* InputBuffer.h
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

#ifndef _ANTLRInputBuffer_h_
	#define _ANTLRInputBuffer_h_

#include <ANTLRTextStreamProtocols.h>

//	A Stream of characters fed to the lexer from a InputStream that can
//		be rewound via mark()/rewind() methods.
//
//		A dynamic array is used to buffer up all the input characters.  Normally,
//		"k" characters are stored in the buffer.  More characters may be stored during
//		guess mode (testing syntactic predicate), or when LT(i>k) is referenced.
//		Consumption of characters is deferred.  In other words, reading the next
//		character is not done by conume(), but deferred until needed by LA or LT.
//
//		@see ANTLRCharQueue

// SAS: Added this class to genericise the input buffers for scanners
//      This allows a scanner to use a binary (FileInputStream) or
//      text (FileReader) stream of data; the generated scanner
//      subclass will define the input stream
//      There are two subclasses to this: CharBuffer and ByteBuffer

@interface ANTLRInputBuffer : NSObject
{
  int nMarkers;        // Number of active markers
  int markerOffset;    // Additional offset used when markers are active
  int numToConsume;    // Number of calls to consume() since last LA() or LT() call

  ANTLRCharQueue* queue; // circular queue

  IMP _queueAppend;
  IMP _queueRemoveFirst;
  IMP _queueCharAtIndex;
}
-(id)init;
+(void)setTraceFlag_LA:(BOOL)_trace;

-(void)commit;
-(void)fill:(int)_amount; //throws IOException;

// -------------------- lookahead ------------------

// Mark another character for deferred consumption
-(void)consume;
-(void)syncConsume;

// lookahead, returns -1 on EOF
-(unichar)LA:(int)_i; // throws: IOException
-(NSString*)getLAChars;

// -------------------- marking --------------------

// Return an integer marker that can be used to rewind the buffer to
// its current state.
-(int)mark;

// Rewind the character buffer to a marker.
-(void)rewind:(int)_mark;
-(NSString*)markedChars;
-(BOOL)isMarked;

@end

#endif //_ANTLRInputBuffer_h_
