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

#import "TestCoroutine.h"
#import "CoroutineX.h"


@interface TestCoroutine (/*PRIVATE*/)
- (NSString*)makeChildName;
@end

@implementation TestCoroutine {
  int _concurrency_level;
  NSString *_name;

  int _cl, _i, _j;
  NSString *_retStr;
}

- (id)initWithConcurrencyLevel:(int)lv name:(NSString*)name {
  self = [super init];
  if (self) {
    _concurrency_level = lv;
    _name = name;
  }
  return self;
}


- (NSString*)makeChildName {
  static int c =0;
  return [NSString stringWithFormat:@"%@c%d", _name, c++];
}

- (id)perform {
  /*
   You can NOT use any local variables in this method.
   */
  static int forkDepth = 2;
  COR_BEGIN;

  for (_cl = 0; _cl < _concurrency_level; ++_cl) {
    //recursive call
    COR_FORK([[TestCoroutine alloc] initWithConcurrencyLevel:forkDepth-- name:[self makeChildName]]);        
  }
  
  for (_i=0; _i < 3; ++_i) {
    _retStr = [NSString stringWithFormat:@"%@'s loop1 i=%d",self->_name, _i];
    COR_YIELD(_retStr);
  }
  
  for (_i=0; _i < 2; ++_i) {
    for (_j=0; _j < 3; ++_j) {
      _retStr = [NSString stringWithFormat:@"%@'s loop2 i=%d, j=%d",self->_name, _i, _j];
      COR_YIELD(_retStr);
    }
  }

  //sub coroutine call
  COR_FORK([[SubCoroutine alloc] init]);

  COR_END;
}

//-(void)dealloc {
//  NSLog(@"dealloc %@", self->_name);
//}

@end


@interface SubCoroutine (/*PRIVATE*/)
@end

@implementation SubCoroutine

- (id)perform {
  /*
   You can NOT use any local variables in this method.
   */
  COR_BEGIN;

  COR_YIELD([NSNumber numberWithFloat:1.2]);
  COR_YIELD([NSNumber numberWithFloat:2.3]);

  COR_END;
}

//-(void)dealloc {
//  NSLog(@"dealloc SubCoroutine");
//}

@end
