/* ANTLRInputBuffer.m
   Copyright (C) 1998, 1999  MDlink online service center, Helge Hess and Manuel Guesdon
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

#define ANTLRStorageSize   sizeof(ANTLRBitSetStorage)
#define ANTLRBitsPerEntry  (ANTLRStorageSize * 8)
#define ANTLRByteSize      (universe / 8)

#define ANTLRTestBit(_x)   (((storage[ _x / ANTLRBitsPerEntry ] & \
                         (1 << (_x % ANTLRBitsPerEntry))) == 0) ? NO : YES)

//====================================================================
@interface ANTLRConcreteBitSetEnumerator : NSEnumerator
{
@public
  unsigned int    universe;
  unsigned int    count;
  ANTLRBitSetStorage *storage;

  unsigned int position;
  unsigned int found;
};

-(id)nextObject;

@end

//====================================================================
@implementation ANTLRBitSet

//--------------------------------------------------------------------
+(id)bitSet
{
  return AUTORELEASE([self new]);
}

//--------------------------------------------------------------------
+(id)bitSetWithCapacity:(unsigned)_capacity
{
  return AUTORELEASE([[self alloc] initWithCapacity:_capacity]);
};

//--------------------------------------------------------------------
+(id)bitSetWithBitSet:(ANTLRBitSet*)_set
{
  return AUTORELEASE([[self alloc] initWithBitSet:_set]);
}

//--------------------------------------------------------------------
+(id)bitSetWithULongBits:(unsigned long*)_bits
				  length:(unsigned)_length
{
  id bitSet=[self bitSetWithCapacity:_length*sizeof(long)];
  int i;
  for(i=0;i<_length;i++)
	{
	  int j=0;
	  for(j=0;j<sizeof(long)*8;j++)
		{
		  if ((unsigned long)(_bits[i]) & (1UL << j))
			  [bitSet addMember:(i*sizeof(long)*8+j)];
		};
	  };
  return bitSet;
};

//--------------------------------------------------------------------
-(id)initWithCapacity:(unsigned)_capacity
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  self->universe = (_capacity / ANTLRBitsPerEntry + 1) * ANTLRBitsPerEntry;
	  storage  = ANTLR_ALLOC_ATOMIC(ANTLRByteSize);
	  memset(storage, 0, ANTLRByteSize);
	  count = 0;
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithBitSet:(ANTLRBitSet*)_set
{
  LOGObjectFnStart();
  if ((self = [self initWithCapacity:ANTLRBitsPerEntry]))
	{
	  NSEnumerator *enumerator = [_set objectEnumerator];
	  id obj = nil;
	  
	  while ((obj = [enumerator nextObject]))
		[self addMember:[obj unsignedIntValue]];
	  
	  enumerator = nil;
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
- (id)init
{
  return [self initWithCapacity:ANTLRBitsPerEntry];
};

//--------------------------------------------------------------------
-(id)initWithNullTerminatedArray:(unsigned int*)_array
{
  LOGObjectFnStart();
  if ((self = [self initWithCapacity:ANTLRBitsPerEntry]))
	{
	  while (*_array)
		{
		  [self addMember:*_array];
		  _array++;
		};
	};
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_FREE(storage);
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
// storage
-(void)_expandToInclude:(unsigned int)_element
{
  unsigned int nu = (_element / ANTLRBitsPerEntry + 1) * ANTLRBitsPerEntry;
  LOGObjectFnStart();
  if (nu > self->universe)
	{
	  void *old = storage;
	  storage = (ANTLRBitSetStorage *)ANTLR_ALLOC_ATOMIC(nu / 8);
	  memset(storage, 0, nu / 8);
	  if (old)
		{
		  memcpy(storage, old, ANTLRByteSize);
		  ANTLR_FREE(old);
		};
	  self->universe = nu;
	};
  LOGObjectFnStop();
};

// accessors

//--------------------------------------------------------------------
-(unsigned int)capacity
{
  return self->universe;
};

//--------------------------------------------------------------------
-(unsigned int)count
{
  return count;
};

// membership

//--------------------------------------------------------------------
-(BOOL)isMember:(unsigned int)_element
{
  BOOL isMember=NO;
  LOGObjectFnStart();
  isMember=(_element >= self->universe) ? NO : ANTLRTestBit(_element);
  LOGObjectFnStop();
  return isMember;
};

//--------------------------------------------------------------------
-(void)addMember:(unsigned int)_element
{
  register unsigned int subIdxPattern = 1 << (_element % ANTLRBitsPerEntry);
//  LOGObjectFnStart();
  if (_element >= self->universe)
    [self _expandToInclude:_element];

  if ((storage[ _element / ANTLRBitsPerEntry ] & subIdxPattern) == 0)
	{
	  storage[ _element / ANTLRBitsPerEntry ] |= subIdxPattern;
	  count++;
	};
//  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)addMembersInRange:(NSRange)_range
{
  register unsigned int from = _range.location;
  register unsigned int to   = from + _range.length - 1;
  LOGObjectFnStart();
  
  if (to >= self->universe)
    [self _expandToInclude:to];

  for (; from <= to; from++)
	{
	  register unsigned int subIdxPattern = 1 << (from % ANTLRBitsPerEntry);
	  
	  if ((storage[ from / ANTLRBitsPerEntry ] & subIdxPattern) == 0)
		{
		  storage[ from / ANTLRBitsPerEntry ] |= subIdxPattern;
		  count++;
		};
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)addMembersFromBitSet:(ANTLRBitSet*)_set
{
  int i;
  LOGObjectFnStart();
  if ([_set capacity] > self->universe)
    [self _expandToInclude:[_set capacity]];

  for (i = 0; i < [_set capacity]; i++)
	{
	  if ([_set isMember:i])
		{
		  register unsigned int subIdxPattern = 1 << (i % ANTLRBitsPerEntry);
		  
		  if ((storage[ i / ANTLRBitsPerEntry ] & subIdxPattern) == 0)
			{
			  storage[ i / ANTLRBitsPerEntry ] |= subIdxPattern;
			  count++;
			};
		};
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)removeMember:(unsigned int)_element
{
  register unsigned int subIdxPattern = 1 << (_element % ANTLRBitsPerEntry);
  LOGObjectFnStart();
  
  if (_element < self->universe)
	{
	  if ((storage[ _element / ANTLRBitsPerEntry ] & subIdxPattern) != 0)
		{
		  storage[ _element / ANTLRBitsPerEntry ] -= subIdxPattern;
		  count--;
		};
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)removeMembersInRange:(NSRange)_range
{
  register unsigned int from = _range.location;
  register unsigned int to   = from + _range.length - 1;
  if (from < self->universe)
	{
	  if (to >= self->universe)
		to = self->universe - 1;
  
	  for (; from <= to; from++)
		{
		  register unsigned int subIdxPattern = 1 << (from % ANTLRBitsPerEntry);
		  
		  if ((storage[ from / ANTLRBitsPerEntry ] & subIdxPattern) != 0)
			{
			  storage[ from / ANTLRBitsPerEntry ] -= subIdxPattern;
			  count--;
			};
		};
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)removeAllMembers
{
  LOGObjectFnStart();
  memset(storage, 0, ANTLRByteSize);
  count = 0;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(unsigned int)firstMember
{
  register unsigned int element;
  unsigned int firstMember=NSNotFound;
  LOGObjectFnStart();

  for (element = 0;firstMember==NSNotFound && element < self->universe; element++)
	{
	  if (ANTLRTestBit(element))
		firstMember=element;
	};
  LOGObjectFnStop();
  return firstMember;
};

//--------------------------------------------------------------------
-(unsigned int)lastMember
{
  register unsigned int element;
  unsigned int lastMember=NSNotFound;
  LOGObjectFnStart();
  for (element = (self->universe - 1);lastMember==NSNotFound && element >= 0; element--)
	{
	  if (ANTLRTestBit(element))
		lastMember=element;
	};
  LOGObjectFnStop();
  return lastMember;
};

// equality

//--------------------------------------------------------------------
-(BOOL)isEqual:(id)_object
{
  BOOL equal=YES;
  LOGObjectFnStart();
  if (self == _object)
	equal=YES;
  else if ([self class] != [_object class])
	equal=NO;
  else
	equal=[self isEqualToSet:_object];
  LOGObjectFnStop();
  return equal;
};

//--------------------------------------------------------------------
-(BOOL)isEqualToSet:(ANTLRBitSet *)_set
{
  BOOL equal=YES;
  LOGObjectFnStart();
  if (self == _set)
	equal=YES;
  else if (count != [_set count])
	equal=NO;
  else
	{
	  register unsigned int element;
	  for (element = 0;equal && element < self->universe; element++)
		{
		  if (ANTLRTestBit(element))
			{
			  if (![_set isMember:element])
				  equal=NO;
			};
		};
	};
  LOGObjectFnStop();
  return equal;
};

// enumerator

//--------------------------------------------------------------------
-(NSEnumerator *)objectEnumerator
{
  if (self->count == 0) 
    return nil;
  else
	{
	  ANTLRConcreteBitSetEnumerator *en = [[ANTLRConcreteBitSetEnumerator alloc] init];
	  en->universe = self->universe;
	  en->count    = self->count;
	  en->storage  = self->storage;
	  return AUTORELEASE(en);
	};
};

// NSCopying

//--------------------------------------------------------------------
-(id)copy
{
  return [self copyWithZone:[self zone]];
};

//--------------------------------------------------------------------
-(id)copyWithZone:(NSZone *)_zone
{
  return [[ANTLRBitSet alloc] initWithBitSet:self];
};


//--------------------------------------------------------------------
// NSCoding
-(void)encodeWithCoder:(NSCoder *)_coder
{
  unsigned int element;
  register unsigned int found;
  LOGObjectFnStart();
  [_coder encodeValueOfObjCType:@encode(unsigned int) at:&count];
  for (element = 0, found = 0; (element < self->universe) && (found < count); element++)
	{
	  if (ANTLRTestBit(element))
		{
		  [_coder encodeValueOfObjCType:@encode(unsigned int) at:&element];
		  found++;
		};
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(id)initWithCoder:(NSCoder*)_coder
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  unsigned int nc;
	  register unsigned int cnt;
	  
	  self->universe = ANTLRBitsPerEntry;
	  storage  = ANTLR_ALLOC_ATOMIC(ANTLRByteSize);
	  memset(storage, 0, ANTLRByteSize);
	  
	  [_coder decodeValueOfObjCType:@encode(unsigned int) at:&nc];
	
	  for (cnt = 0; cnt < nc; cnt++)
		{
		  unsigned int member;
		  [_coder decodeValueOfObjCType:@encode(unsigned int) at:&member];
		  [self addMember:member];
		};
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
// description

-(NSString *)description
{
  return [NSString stringWithFormat:
                     @"<ANTLRBitSet[0x%08X]: capacity=%u count=%u content=%@>",
				   (unsigned)self,
				   self->universe,
				   self->count,
				   [[self toArray] description]];
};

//--------------------------------------------------------------------
-(NSArray *)toArray
{
  NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:count + 1];
  register unsigned int element, found;
  LOGObjectFnStart();
  for (element = 0, found = 0;
       (element < self->universe) && (found < self->count); element++)
	{
	  if (ANTLRTestBit(element))
		{
		  [result addObject:[NSNumber numberWithUnsignedInt:element]];
		  found++;
		};
	};
  LOGObjectFnStop();
  return AUTORELEASE([AUTORELEASE(result) copy]);
};

@end

//====================================================================
@implementation ANTLRConcreteBitSetEnumerator

//--------------------------------------------------------------------
-(id)nextObject
{
  if (self->found == self->count)
    return nil;
  else if (self->position >= self->universe)
    return nil;
  else
	{
	  while (!ANTLRTestBit(self->position))
		self->position++;
	  
	  self->found++;
	  self->position++;
	  
	  return [NSNumber numberWithUnsignedInt:(self->position - 1)];
	};
};

@end

//--------------------------------------------------------------------
NSString *stringValueForBitset(unsigned int _set, char _setC, char _unsetC, short _wide)
{
  char           buf[_wide + 1];
  register short pos;
  for (pos = 0; pos < _wide; pos++)
	{
	  register unsigned int v = (1 << pos);
	  buf[(int)pos] = ((v & _set) == v) ? _setC : _unsetC;
	};
  
  buf[_wide] = '\0';
  return [NSString stringWithCString:buf];
};

//--------------------------------------------------------------------
void __link_ANTLRExtensions_ANTLRBitSet()
{
  __link_ANTLRExtensions_ANTLRBitSet();
};
