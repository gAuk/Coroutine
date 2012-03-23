//
//  main.m
//

#import <Foundation/Foundation.h>
#import "TestCoroutine.h"


int main(int argc, const char * argv[])
{

  @autoreleasepool {

    CoroutineState *corState1 = [[CoroutineState alloc] init];
    TestCoroutine *coro1 = [[TestCoroutine alloc] initWithConcurrencyLevel:3 name:@"p0"];
    [corState1 push:coro1];

    CoroutineState *corState2 = [[CoroutineState alloc] init];
    TestCoroutine *coro2 = [[TestCoroutine alloc] initWithConcurrencyLevel:2 name:@"p1"];
    [corState2 push:coro2];

    id retVal1, retVal2;
    do {
      retVal1 = [corState1 next];
      retVal2 = [corState2 next];
      NSLog(@"1:%@, 2:%@", retVal1, retVal2);
      NSLog(@"1's stack-size=%ld, 2's stack-size=%ld", [corState1 stackSize], [corState2 stackSize]);
    } while (retVal1 || retVal2);

  }
    return 0;
}

