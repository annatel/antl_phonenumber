CC=gcc
CXX=g++
RM=rm -f
ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CPPFLAGS=-O3 -I ../libphonenumber/cpp/src  -I $(ERLANG_PATH) -fPIC
LDFLAGS= -L ../libphonenumber/cpp/build
LDLIBS=-lphonenumber
# LD_LIBRARY_PATH=../libphonenumber/cpp/build:/usr/lib/x86_64-linux-gnu/libprotobuf.so.10

ObjectsDir := ./priv
SRCFILES := $(shell find . -name "*.cpp")
OBJS  := $(patsubst src/%.cpp, $(ObjectsDir)/%.o, $(SRCFILES))

all: antl_phonenumberso

$(ObjectsDir)/%.o: %.cpp
	$(CXX) $(CPPFLAGS) -c $< -o $@

clean:
	$(RM) *.o

distclean: clean
	$(RM) priv/antl_phonenumber_nif.so

antl_phonenumberso: $(OBJS)
	$(CXX) -fPIC $(OBJS) -shared $(LDFLAGS) $(LDLIBS) -o priv/antl_phonenumber_nif.so
