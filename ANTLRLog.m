/* ANTLRLog.m
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
#include "ANTLRLog.h"

//MG
NSString* ANTLRTIDInfo()
{
  NSString* tinfo=@"";
#if GNUSTEP_BASE_LIBRARY
  if ([NSThread isMultiThreaded])
	{
	  tinfo=[NSString stringWithFormat:@"TID=%p ",
					 ((void*)objc_thread_id())];
	}
#endif
  return tinfo;
};

//====================================================================
@implementation ANTLRLog

//--------------------------------------------------------------------
+(NSFileHandle*)fileHandle
{
  return [NSFileHandle fileHandleWithStandardOutput];
};

//--------------------------------------------------------------------
+(void)flush
{
//  NSFileHandle* fh=[self fileHandle];
};

//--------------------------------------------------------------------
+(void)writeString:(NSString*)_string
{
  NSFileHandle* fh=[self fileHandle];
  //MG
  if ([NSThread isMultiThreaded])
	{
	  [fh writeData:[ANTLRTIDInfo() dataUsingEncoding:NSASCIIStringEncoding
								 allowLossyConversion:YES]];
	};
  [fh writeData:[_string dataUsingEncoding:NSASCIIStringEncoding
						 allowLossyConversion:YES]];
};

//--------------------------------------------------------------------
+(void)writeFormat:(NSString*)_format,...
{
  NSString* str=nil;
  va_list ap;
  va_start(ap, _format);
  str = [NSString stringWithFormat:_format
				  arguments:ap];
  [self writeString:str];
  va_end(ap);
};

//--------------------------------------------------------------------
+(void)writeNewline
{
  NSFileHandle* fh=[self fileHandle];
  [fh writeData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding
												   allowLossyConversion:YES]];
};

@end;

//====================================================================
@implementation ANTLRLogOut

//--------------------------------------------------------------------
+(NSFileHandle*)fileHandle
{
  return [NSFileHandle fileHandleWithStandardOutput];
};
@end;

//====================================================================
@implementation ANTLRLogErr

//--------------------------------------------------------------------
+(NSFileHandle*)fileHandle
{
  return [NSFileHandle fileHandleWithStandardError];

};
@end;
