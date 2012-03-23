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

#import "CoroutineX.h"
#import "Stack.h"



@interface CoroutineState ()
-(CoroutineX*)current;
@end

@implementation CoroutineState {
  Stack *coroStack_;
}

-(id)init{
  self = [super init];
  if (self) {
    coroStack_ = [[Stack alloc] init];
  }
  return self;
}

-(void)push:(CoroutineX*)coroutine {
  [coroStack_ push:coroutine];
  [coroutine setState:self];
  assert(0 <= [coroStack_ count] && [coroStack_ count] <= 9999);
}

- (NSInteger) stackSize {
  return [coroStack_ count];
}

-(CoroutineX*)current {
  return [coroStack_ peek];
}

-(id)next {
  CoroutineX *coroutine;
  if ((coroutine = [self current])) {
    id retObj;
    if ((retObj = [coroutine next])) {
      return retObj;
    } else {
      if (coroutine.isComplete)
        [coroStack_ pop];
      return [self next];
    }
  }
  return nil;
}

@end


@interface CoroutineX ()
-(id)perform;
@end

@implementation CoroutineX {
}

@synthesize value=value_;
@synthesize state=state_;

-(id)init{
  self = [super init];
  if (self) {
    value_ = 0;
  }
  return self;
}

- (BOOL)isComplete { return value_ == -1; }

-(id)next {
  return [self perform];
}

-(id)perform {
  assert(NO);//must override
}

@end

