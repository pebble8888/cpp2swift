//
//  cpp2swifttest.m
//  cpp2swifttest
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "cpp2swift-Swift.h"

@interface cpp2swifttest : XCTestCase

@end

@implementation cpp2swifttest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssert(YES, @"Pass");
    
    Parser* parser = [[Parser alloc] init];
    NSString* str = [parser parse:@"static OSStatusOpen (const CAComponent& inComp, CAAudioUnit &outUnit);"];
    NSLog(@"str[%@]");
}

@end
