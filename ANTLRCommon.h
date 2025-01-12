/* Common.h
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

#ifndef _ANTLRCommon_h_
	#define _ANTLRCommon_h_

#if LIB_FOUNDATION_BOEHM_GC
	#include <gc.h>
	#define ANTLR_GC 1
#else
	#include <stdlib.h>
	#define ANTLR_GC 0
#endif

#ifndef GNUSTEP
#include <GNUstepBase/GNUstep.h>
#include <GNUstepBase/GSObjCRuntime.h>
#include <GNUstepBase/GSCategories.h>
#endif

//defines for memory management

#define ANTLR_DESTROY(obj)			DESTROY(obj)
//#define ANTLR_ALLOC_ATOMIC(size)	NGMallocAtomic(size)
#define ANTLR_ALLOC_ATOMIC(size)	objc_atomic_malloc(size)
//#define ANTLR_ALLOC(size)			NGMalloc(size)
#define ANTLR_ALLOC(size)			objc_malloc(size)
//#define ANTLR_FREE(ptr)			{ if (ptr) { NGFree(ptr); }; }
#define ANTLR_FREE(ptr)				{ if (ptr) { objc_free((ptr)); (ptr)=NULL;}; }

typedef int ANTLRTokenType;

#include <Foundation/Foundation.h>
#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>

#include <ANTLRLog.h>
#include <ANTLRCharFormatter.h>
#include <ANTLRTokenizer.h>
#include <ANTLRHashString.h>
#include <ANTLRException.h>
#include <ANTLRMismatchedTokenException.h>
#include <ANTLRNoViableAltException.h>

#include <ANTLRCharQueue.h>
#include <ANTLRToken.h>
#include <ANTLRCommonToken.h>

#include <ANTLRCharBuffer.h>
#include <ANTLRCharScanner.h>

#include <ANTLRTokenBuffer.h>
#include <ANTLRParser.h>
#include <ANTLRLLkParser.h>

#if 0
	#define CONST
	#include <gsweb/utils.h>
#else
	#ifndef _GSWebUtils_h__
		#define LOGObjectFnStart();
	   	#define LOGObjectFnStop();
	#endif
#endif

#define LINK_ANTLRRuntime \
  static void __link_ANTLRRuntime() { \
    [ANTLRHashString alloc]; \
    [ANTLRException alloc]; \
    [ANTLRMismatchedTokenException alloc]; \
    [ANTLRNoViableAltException alloc]; \
    [ANTLRCharQueue alloc]; \
    [ANTLRToken alloc]; \
    [ANTLRCommonToken alloc]; \
    [ANTLRTokenQueue alloc]; \
    [ANTLRCharBuffer alloc]; \
    [ANTLRCharScanner alloc]; \
    [ANTLRTokenBuffer alloc]; \
    [ANTLRParser alloc]; \
    [ANTLRLLkParser alloc]; \
    __link_ANTLRRuntime(); \
  }

#endif // _ANTLRCommon_h_
