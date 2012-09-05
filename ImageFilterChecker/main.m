//
//  main.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
  int retVal;
  @autoreleasepool {
#ifdef DEBUG
    @try {
#endif
      retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#ifdef DEBUG
    }
    @catch (NSException *exception) {
      NSLog( @"%@", [exception callStackSymbols] );
      @throw exception;
    }
#endif
  }
  return retVal;
}
