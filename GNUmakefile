# $Id$

GNUSTEP_INSTALLATION_DIR = $(GNUSTEP_USER_ROOT)

include $(GNUSTEP_SYSTEM_ROOT)/Makefiles/common.make

LIBRARY_NAME = libGSANTLR

PROTOCOLS = \
	ANTLRCharFormatter \
	ANTLRTokenizer \
	ANTLRAST \
	ANTLRASTFactory \

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
	ANTLRTextStreamProtocols \
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

libGSANTLR_HEADER_FILES_DIR = .
libGSANTLR_HEADER_FILES_INSTALL_DIR = /$(GNUSTEP_FND_DIR)/gsantlr

-include GNUmakefile.preamble

include $(GNUSTEP_SYSTEM_ROOT)/Makefiles/library.make

-include GNUmakefile.postamble
