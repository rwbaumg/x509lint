CC = gcc
LD = $(CC)
RM = rm

CFLAGS = -g -Wall -O2 -std=c99
LIBS = -lcrypto -ldl -static -Wl,--whole-archive -lpthread -Wl,--no-whole-archive

UNAME_O := $(shell uname -o)
ifeq ($(UNAME_O),Cygwin)
    LIBS += -liconv
endif

X509_SRCS = $(wildcard x509*.c)
OBJ_HDRS = $(wildcard *.h)
HDR_OBJS = $(patsubst %.h,%.o,$(OBJ_HDRS))
HDR_SRCS = $(patsubst %.o,%.c,$(HDR_OBJS))

PROGS = $(patsubst %.c,%,$(X509_SRCS))
PROGS_OBJS = $(patsubst %.c,%.o,$(X509_SRCS))

all: $(HDR_OBJS) $(PROGS)

$(PROGS): $(PROGS_OBJS)
	@echo "Compiling $@ to $@.o ..."
	$(LD) $(LDFLAGS) -o $@ $@.o $(HDR_OBJS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $< -c -o $@

config:
	@echo    "static linking arguments  : -static -Wl,--whole-archive -lpthread -Wl,--no-whole-archive"
	@echo -n "libcrypto config (shared) : "; pkg-config --silence-errors --libs libcrypto || pkg-config --libs libcrypto
	@echo -n "libcrypto config (static) : "; pkg-config --silence-errors --static --libs libcrypto || pkg-config --static --libs libcrypto

list:
	@grep -Po '^[^#[:space:]|SHELL|PATH|$$][a-zA-Z].*(?=\:)' Makefile | grep -v UNAME | sort

clean:
	$(RM) -f $(PROGS) *.o
