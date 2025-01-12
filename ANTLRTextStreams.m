/* ANTLRTextStreams.m
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
#include "ANTLRTextStreams.h"

//====================================================================
@implementation NSFileHandle (ANTLRTextInputStream)

//--------------------------------------------------------------------
-(unichar)readCharacter
{
  unichar c=(unichar)EOF;
  NSData* data=nil;
  LOGObjectFnStart();
  data=[self readDataOfLength:1];
  if (data && [data length]==1)
	  c=(unichar)*(char*)[data bytes];
  else
	  c=ANTLR_EOF_CHAR;
  LOGObjectFnStop();
  return c;
};

@end

//====================================================================
@implementation ANTLRTextInputStreamString

//--------------------------------------------------------------------
+(id)newWithString:(NSString*)_string
{
  return [[[self class] alloc]initWithString:_string];
};

//--------------------------------------------------------------------
-(id)initWithString:(NSString*)_string
{
  LOGObjectFnStart();
  self=[super init];
  [self setString:_string];
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  DESTROY(string);
  [super dealloc];
};
#endif
//--------------------------------------------------------------------
-(void)setString:(NSString*)_string
{
  LOGObjectFnStart();
  ASSIGN(string,_string);
  pos=0;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(NSString*)string //MG
{
  return string;
};

//--------------------------------------------------------------------
-(int)pos //MG
{
  return pos;
};

//--------------------------------------------------------------------
-(NSString*)description //MG
{
  return [NSString stringWithFormat:@"<%s %p - string:[%@] pos:[%d]>",
				   object_get_class_name(self),
				   (void*)self,
				   string,
				   pos];

}

//--------------------------------------------------------------------
-(unichar)readCharacter
{
  unichar c=(unichar)EOF;
  LOGObjectFnStart();
  if (pos<[string length])
	{
	  c=[string characterAtIndex:pos];
	  pos++;
	}
  else
	  c=ANTLR_EOF_CHAR;

  LOGObjectFnStop();
  return c;
};

@end
