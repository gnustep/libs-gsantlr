# $Id$

ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
  ifeq ($(GNUSTEP_MAKEFILES),)
    $(warning )
    $(warning Unable to obtain GNUSTEP_MAKEFILES setting from gnustep-config!)
    $(warning Perhaps gnustep-make is not properly installed,)
    $(warning so gnustep-config is not in your PATH.)
    $(warning )
    $(warning Your PATH is currently $(PATH))
    $(warning )
  endif
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libGSANTLR

PROTOCOLS = \
	ANTLRCharFormatter \
	ANTLRTokenizer \
	ANTLRAST \
	ANTLRASTFactory \
	ANTLRTextStreamProtocols \

CATEGORIES = \

EXCEPTIONS = \
	ANTLRException \
	ANTLRMismatchedTokenException \
	ANTLRNoViableAltException \

CLASSES = \
	ANTLRBitSet \
	ANTLRCharQueue \
	ANTLRInputBuffer \
	ANTLRCharBuffer \
	ANTLRCharScanner \
	ANTLRToken \
	ANTLRCommonToken \
	ANTLRAST \
	ANTLRASTNULLType \
	ANTLRASTFactory \
	ANTLRASTPair \
	ANTLRCommonAST \
	ANTLRASTEnumerator \
	\
	ANTLRTokenQueue \
	ANTLRTokenBuffer \
	ANTLRParser \
	ANTLRLLkParser \
	ANTLRTreeParser \
	\
	ANTLRHashString \
	ANTLRTextStreams \
	ANTLRLog \
	$(EXCEPTIONS) \

PROTOCOLS_h  = $(addsuffix .h, $(PROTOCOLS))
CLASSES_h    = $(addsuffix .h, $(CLASSES))
CLASSES_m    = $(addsuffix .m, $(CLASSES))
CATEGORIES_h = $(addsuffix .h, $(CATEGORIES))
CATEGORIES_m = $(addsuffix .m, $(CATEGORIES))

$(LIBRARY_NAME)_HEADER_FILES = \
	$(PROTOCOLS_h) \
	$(CLASSES_h) \
	$(CATEGORIES_h) \
	ANTLRCommon.h \

$(LIBRARY_NAME)_OBJC_FILES = \
	$(CLASSES_m) \
	$(CATEGORIES_m) \

# set compile flags and go

ADDITIONAL_CPPFLAGS += -Wall -I../Foundation -I..

ifneq ($(FOUNDATION_LIB),gnu)
LIBRARIES_DEPEND_UPON += -lgnustep-baseadd
endif

libGSANTLR_HEADER_FILES_DIR = .
libGSANTLR_HEADER_FILES_INSTALL_DIR = /$(GNUSTEP_FND_DIR)/gsantlr

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/library.make

-include GNUmakefile.postamble
