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

#import "Stack.h"

@implementation Stack {
  NSMutableArray *contents_;
}

- (id)init {
  if (self = [super init]) {
    self->contents_ = [[NSMutableArray alloc] init];
  }
  return self;
}


- (void)push:(id)object {
  [self->contents_ addObject:object];
}

- (BOOL)pop {
  NSUInteger count = [self->contents_ count];
  if (count > 0) {
    [self->contents_ removeLastObject];
    return YES;
  }
  return NO;
}

- (id)peek {
  NSUInteger count = [self->contents_ count];
  if (count > 0) {
    id returnObject = [self->contents_ objectAtIndex:count - 1];
    return returnObject;
  } else {
    return nil;
  }
}

- (NSUInteger)count {
  return [self->contents_ count];
}

@end
