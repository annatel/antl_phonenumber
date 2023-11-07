#
# Makefile for building the NIF
#
# Makefile targets:
#
# all    build and install the NIF
# clean  clean build products and intermediates
#
# Variables to override:
#
#
# CXXFLAGS      compiler flags for compiling all C++ files
# LDFLAGS       linker flags for linking all binaries
#

CXXFLAGS += -O3
LDLIBS=-lphonenumber
CXXFLAGS += -I$(ERTS_INCLUDE_DIR)

KERNEL_NAME := $(shell uname -s)
ifeq ($(KERNEL_NAME), Linux)
	CXXFLAGS += -fPIC -fvisibility=hidden
	LDFLAGS += -fPIC -shared
endif
ifeq ($(KERNEL_NAME), Darwin)
	CXXFLAGS += -fPIC -std=c++17 -I /opt/homebrew/include
	LDFLAGS += -dynamiclib -undefined dynamic_lookup -L /opt/homebrew/lib
endif

OBJSDIR=priv
SRCDIR=cpp_src
SRCFILES=$(shell find . -name "*.cpp")
OBJS=$(subst $(SRCDIR),$(OBJSDIR),$(patsubst %.cpp, %.o,$(SRCFILES)))
LIB_NAME=$(OBJSDIR)/antl_phonenumber_nif.so

.PHONY: clean distclean

all: $(LIB_NAME)

$(LIB_NAME): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $(LIB_NAME)

$(OBJSDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) $(LIB_NAME)
