//
//  libnetsurfTests.m
//  libnetsurfTests
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "libnetsurfTests.h"

#import "DNCSSStylesheet.h"

@implementation libnetsurfTests

- (void)setUp
{
    [super setUp];
    
	DNCSSStylesheet *stylesheet = [[[DNCSSStylesheet alloc] init] autorelease];
	
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in libnetsurfTests");
}

@end
