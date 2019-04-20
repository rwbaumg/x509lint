CC = gcc
LD = $(CC)
RM = rm

LIBCRYPTO_PATH = /usr/lib/x86_64-linux-gnu/libcrypto.a

CFLAGS = -g -Wall -O2 -std=c99
LIBS = -lcrypto -lz -ldl -static-libgcc -static $(LIBCRYPTO_PATH)

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
	@echo "Compiling $@ to $< ..."
	$(LD) $(LDFLAGS) -o $@ $< $(HDR_OBJS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	$(RM) -f $(PROGS) *.o
