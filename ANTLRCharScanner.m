/* ANTLRCharScanner.m
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

#if GNUSTEP_BASE_LIBRARY
#  include <GNUstepBase/Unicode.h>
#endif

#define SELF_LA1 _ANTLRCharScanner_LA(self, 1)

BOOL ANTLRCharScanner_traceFlag_LA=NO;

@implementation ANTLRCharScanner

//--------------------------------------------------------------------
+(void)setTraceFlag_LA:(BOOL)_trace
{
  ANTLRCharScanner_traceFlag_LA=_trace;
};

//--------------------------------------------------------------------
static inline
unichar _ANTLRCharScanner_LA(ANTLRCharScanner *self,int _i)
{
  unichar c= self->caseSensitive
    ? [self->input LA:_i]
    : [self toLower:[self->input LA:_i]];
  if (ANTLRCharScanner_traceFlag_LA)
	{
	  NSLog(@"%@ CharScanner LA:%d=%u (%c)",ANTLRTIDInfo(),
			_i,(unsigned)c,(char)c);
	};
  return c;
};

//--------------------------------------------------------------------
-(void)setReturnToken:(ANTLRDefToken)_token
{
  LOGObjectFnStart();
  ASSIGN(_returnToken,_token);
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
+(id)charScannerWithCharBuffer:(ANTLRCharBuffer*)_buffer
{
  return AUTORELEASE([self new]);
}

//--------------------------------------------------------------------
-(id)initWithCharBuffer:(ANTLRCharBuffer*)_buffer
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  input = RETAIN(_buffer);
	  _appendChar = [self methodForSelector:@selector(appendCharacter:)];
	  line                  = 1;
	  saveConsumedInput     = YES;
	  guessing              = 0;
	  caseSensitive         = YES;
	  caseSensitiveLiterals = YES;
	  _returnToken          = nil;
	  text       = [[NSMutableString alloc] init];
	  hashString = [[ANTLRHashString alloc] initWithLexer:self];
	  [self setTokenObjectClass:@"ANTLRCommonToken"];
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithTextStream:(id<NSObject,ANTLRTextInputStream>)_in
{
  return [self initWithCharBuffer:[ANTLRCharBuffer charBufferWithTextStream:_in]];
};

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  ANTLR_DESTROY(text);
  ANTLR_DESTROY(literals);
  ANTLR_DESTROY(_returnToken);
  ANTLR_DESTROY(hashString);
  ANTLR_DESTROY(input);
  [super dealloc];
}
#endif

// ANTLRTokenizer

//--------------------------------------------------------------------
-(ANTLRDefToken)nextToken
{ // abstract
  [self subclassResponsibility:_cmd];
  return nil;
}

// accessors

//--------------------------------------------------------------------
-(void)appendCharacter:(unichar)_c
{
  LOGObjectFnStart();
  if (saveConsumedInput)
	{
	  // UNICODE: NSString *str = [NSString stringWithCharacters:&_c length:1];
	  unsigned char c = _c;
	  NSString *str = [NSString stringWithCString:&c length:1];
	  [text appendString:str];
	  str = nil;
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)appendString:(NSString *)_string
{
  LOGObjectFnStart();
  if (saveConsumedInput)
    [text appendString:_string];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)commit
{
  LOGObjectFnStart();
  [input commit];
  LOGObjectFnStop();
};

// accessors
//--------------------------------------------------------------------
-(ANTLRCharBuffer*)inputBuffer
{
  return input;
};

//--------------------------------------------------------------------
-(BOOL)isCommitToPath
{
  return commitToPath;
};

//--------------------------------------------------------------------
-(void)setCommitToPath:(BOOL)commit
{
  LOGObjectFnStart();
  commitToPath = commit;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)setCaseSensitive:(BOOL)_flag
{
  LOGObjectFnStart();
  caseSensitive = _flag;
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(BOOL)isCaseSensitive
{
  return caseSensitive;
}

//--------------------------------------------------------------------
-(BOOL)hasCaseSensitiveLiterals 
{
  return caseSensitiveLiterals;
}

//--------------------------------------------------------------------
-(void)setLine:(int)_line
{
  LOGObjectFnStart();
  line = _line;
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(int)line
{
  return line;
};

//--------------------------------------------------------------------
-(void)newline
{
  line++;
};

//--------------------------------------------------------------------
-(void)setText:(NSString*)_string
{
  LOGObjectFnStart();
  [self resetText];
  [text appendString:_string];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(NSString*)text
{ // return a copy of the current text buffer
  return AUTORELEASE([text copy]);
}

//--------------------------------------------------------------------
-(void)resetText
{
  LOGObjectFnStart();
  [text setString:@""];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
// character tokens
-(unichar)LA:(int)_i
{ // throws IOException
  unichar c;
  LOGObjectFnStart();
  c=_ANTLRCharScanner_LA(self, _i);
  LOGObjectFnStop();
  return c;
}

//--------------------------------------------------------------------
-(ANTLRDefToken)makeToken:(int)_tokenType
{
  ANTLRDefToken token = AUTORELEASE([[tokenObjectClass alloc] init]);
  LOGObjectFnStart();
  if (token)
	{
	  [token setTokenType:_tokenType];
	  // [token setText:[self text]]; done in generated lexer now
	  [token setLine:line];
	}
  else
	{
	  [self panic:@"can't instantiate a Token"];
	  token=[ANTLRToken badToken];
	};
  LOGObjectFnStop();
  return token;
};

//--------------------------------------------------------------------
-(ANTLRDefToken)tokenObject
{
  return _returnToken;
}

//--------------------------------------------------------------------
-(void)setTokenObjectClass:(NSString *)_className
{
  LOGObjectFnStart();
  tokenObjectClass = NSClassFromString(_className);
  LOGObjectFnStop();
};

// ******************** matching *********************

//--------------------------------------------------------------------
-(void)matchCharacter:(unichar)_c
{ // throws ScannerException, IOException
  LOGObjectFnStart();
  if (SELF_LA1 != _c)
	{
	  [ANTLRScannerException raiseWithReason:[NSString stringWithFormat:@"mismatched char: '%c<%i>'",
													   SELF_LA1, SELF_LA1]
							 line:line];
	};
  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchNotCharacter:(unichar)_c
{ // throws ScannerException, IOException
  LOGObjectFnStart();
  if (SELF_LA1 == _c)
	{
	  [ANTLRScannerException raiseWithReason:[NSString stringWithFormat:@"mismatched char: '%c<%i>'",
													   SELF_LA1, SELF_LA1]
							 line:line];
	};
  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchRange:(unichar)_c1
				 :(unichar)_c2
{ // throws ScannerException, IOException
  register unichar _la1 = SELF_LA1;
  LOGObjectFnStart();
  if ((_la1 < _c1) || (_la1 > _c2))
	{
	  [ANTLRScannerException raiseWithReason:[NSString stringWithFormat:@"char out of range: '%c<%i>'",
													   _la1, _la1]
							 line:line];
	};
  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchCharSet:(ANTLRBitSet*)_set
{ // throws ScannerException, IOException
  LOGObjectFnStart();
  if (![_set isMember:SELF_LA1])
	{
	  [ANTLRScannerException raiseWithReason:[NSString stringWithFormat:@"mismatched char: '%c<%i>'",
													   SELF_LA1, SELF_LA1] 
							 line:line];
	};
  [self consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)matchString:(NSString *)_str
{ // throws ScannerException, IOException
  register unsigned len = [_str length], cnt;
  LOGObjectFnStart();
  // unicode incompatible
  for (cnt = 0; cnt < len; cnt++)
	{
	  unichar c = [_str characterAtIndex:cnt];
	  if (c != SELF_LA1)
		{
		  [ANTLRScannerException raiseWithReason:[NSString stringWithFormat:@"mismatched char: '%c<%i>'",
														   SELF_LA1, SELF_LA1]
								 line:line];
		};
	  [self consume];
	};
  LOGObjectFnStop();
};

// ******************** marking **********************

//--------------------------------------------------------------------
-(int)mark
{
  return [input mark];
};

//--------------------------------------------------------------------
-(void)rewind:(int)_mark
{
  LOGObjectFnStart();
  [input rewind:_mark];
  LOGObjectFnStop();
}

// ******************** consuming ********************

//--------------------------------------------------------------------
-(void)consume
{ // throws IOException
  LOGObjectFnStart();
  if (guessing == 0)
	{
	  if (caseSensitive)
		[self appendCharacter:SELF_LA1];
	  else
		{
		  NSString *fmt = @"%@ CharScanner catchException:%@ (%@)";
		  // use [input LA:], not [self LA:], to get original case
		  // [CharScanner LA:] would toLower it.		  
		  NS_DURING
			{
			  [self appendCharacter:SELF_LA1];
			}
		  NS_HANDLER
			{
			  NSLog(fmt,
					ANTLRTIDInfo(),
					localException,
					[localException reason]);
			  if (1)//TODO[localException isKindOfClass:[NGIOException class]])
				[self panic:[NSString stringWithCString:"IOException .."]];
			  else
				[localException raise];
			}
		  NS_ENDHANDLER;
		};
	};
  [input consume];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)consumeUntilCharacter:(unichar)_c
{ // throws: NGIOException
  LOGObjectFnStart();
  while ((SELF_LA1 != ANTLR_EOF_CHAR) && (SELF_LA1 != _c))
    [self consume];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)consumeUntilCharSet:(ANTLRBitSet*)_set
{ // throws IOException
  LOGObjectFnStart();
  while ((SELF_LA1 != ANTLR_EOF_CHAR) && (![_set isMember:SELF_LA1]))
    [self consume];
  LOGObjectFnStop();
}

// ******************** error reporting **************

//--------------------------------------------------------------------
-(void)panic
{
  LOGObjectFnStart();
  [ANTLRLogOut flush];
  [ANTLRLogErr writeString:@"ANTLRCharScanner: panic\n"];
  [ANTLRLogErr flush];
  [NSException raise:@"ANTLRCharScanner"
			   format:@": panic"];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)panic:(NSString*)_text
{
  LOGObjectFnStart();
  [ANTLRLogOut flush];
  [ANTLRLogErr writeFormat:@"ANTLRCharScanner; panic: %@\n",_text];
  [ANTLRLogErr flush];
  [NSException raise:@"ANTLRCharScanner"
			   format:@": panic: %@", _text];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)reportErrorWithException:(id)_exception
{
  LOGObjectFnStart();
  [ANTLRLogOut flush];
  // Report exception errors caught in nextToken()
  [ANTLRLogErr writeFormat:@"Scanner exception: %@ (reason:%@)\n",
			   [_exception description],
               [_exception reason]];
  [ANTLRLogErr flush];
  [_exception raise];
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)reportError:(NSString*)_text
{
  LOGObjectFnStart();
  [ANTLRLogOut flush];
  [ANTLRLogErr writeFormat:@"Error: %@\n",_text];
  [ANTLRLogErr flush];
  [NSException raise:@"ANTLRCharScanner"
			   format:@": error: %@", _text];
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)reportWarning:(NSString *)_text
{
  LOGObjectFnStart();
  [ANTLRLogOut flush];
  [ANTLRLogErr writeFormat:@"Warning: %s\n", [_text cString]];
  [ANTLRLogErr flush];
  LOGObjectFnStop();
}

// misc

//--------------------------------------------------------------------
- (int)testLiteralsTable:(ANTLRTokenType)_ttype
{
  // Test the token text against the literals table
  // Override this method to perform a different literals test
  NSNumber *literalsIndex = nil;
  LOGObjectFnStart();
  [hashString setString:text];
  literalsIndex = [literals objectForKey:hashString];
  if (literalsIndex)
    _ttype = [literalsIndex intValue];
  return _ttype;
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(unichar)toLower:(unichar)_char
{
  return tolower(_char);
};

// tracing

//--------------------------------------------------------------------
-(void)traceIn:(NSString *)_ruleName
{ // throws IOException
  unichar la1 = SELF_LA1;
  [ANTLRLogOut writeFormat:@"CharScanner enter lexer %@; la1=='%c'<%i>\n",
				_ruleName, la1, la1];
};

//--------------------------------------------------------------------
-(void)traceOut:(NSString *)_ruleName
{ // throws IOException
  unichar la1 = SELF_LA1;  
  [ANTLRLogOut writeFormat:@"CharScanner leave lexer %@; la1=='%c'<%i>\n",
				_ruleName, la1, la1];
};

//--------------------------------------------------------------------
+(NSString*)charName:(int)ch
{
  if (ch == EOF)
	return @"EOF";
  else
	{
	  unichar _ch=(unichar)ch;
	  return [NSString stringWithCharacters:&_ch
					   length:1];
	};
};

@end
