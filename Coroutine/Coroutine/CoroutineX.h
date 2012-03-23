/*
 * Copyright 2012 Yamana Toshiyuki All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR(S) OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $FreeBSD$
 */

#import <Foundation/Foundation.h>


@class CoroutineState;

@interface CoroutineX : NSObject
-(id)next;
@property (weak) CoroutineState *state;
@property (readwrite) NSInteger value;
@property (readonly) BOOL isComplete;
@end


@interface CoroutineState : NSObject
-(void)push:(CoroutineX*)coroutine;
-(id)next;
@property (readonly) NSInteger stackSize;
@end


#define COR_BEGIN \
  CoroutineX *coro = self; \
  switch (coro.value) { \
    case -1: { \
    goto terminate_coroutine; \
    } \
    case 0: ;

#define COR_FORK(new_coro) \
    for ([coro setValue:__LINE__];;) \
      if (NO)  { \
        case __LINE__: ; \
        break; \
      } else { \
      [self.state push:(new_coro)]; \
      goto bail_out_of_coroutine; \
    }

#define COR_YIELD(ret) \
    do { \
      [coro setValue:__LINE__]; \
      return (ret); \
      case __LINE__: \
      break; \
    } while (0);

#define COR_END \
    terminate_coroutine: \
      [coro setValue:-1]; \
    bail_out_of_coroutine: \
      break; \
  } \
return nil;
