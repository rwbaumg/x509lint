CC = gcc
LD = $(CC)
RM = rm

CFLAGS = -g -Wall -O2 -std=c99
LIBS = -lcrypto

UNAME_O := $(shell uname -o)
ifeq ($(UNAME_O),Cygwin)
    LIBS += -liconv
endif

OBJECTS = x509lint.o checks.o messages.o asn1_time.o
OBJECTS_ROOT = x509lint-root.o checks.o messages.o asn1_time.o
OBJECTS_INT = x509lint-int.o checks.o messages.o asn1_time.o
OBJECTS_SUB = x509lint-sub.o checks.o messages.o asn1_time.o

all: ${x509lint-root} x509lint-root ${x509lint-int} x509lint-int ${x509lint-sub} x509lint-sub

x509lint: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS) $(LIBS)

x509lint-root: $(OBJECTS_ROOT)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS_ROOT) $(LIBS)

x509lint-int: $(OBJECTS_INT)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS_INT) $(LIBS)

x509lint-sub: $(OBJECTS_SUB)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS_SUB) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	$(RM) -f x509lint x509lint-sub x509lint-root x509lint-int *.o

checks.o: checks.c checks.h
x509lint.o: x509lint.c checks.h messages.h
x509lint-root.o: x509lint-root.c checks.h messages.h
x509lint-int.o: x509lint-int.c checks.h messages.h
x509lint-sub.o: x509lint-sub.c checks.h messages.h
messages.o: messages.c checks.h
