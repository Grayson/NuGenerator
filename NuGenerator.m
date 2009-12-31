#import <Foundation/Foundation.h>
#import <Nu/Nu.h>
#import "parser.h"
#import "NuYieldOperator.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	id parser = [Nu parser];
	
	
	[parser parseEval:[NSString stringWithContentsOfFile:@"../../generator.nu" encoding:NSUTF8StringEncoding error:nil]];

    [pool drain];
    return 0;
}

