//
//  PIAPI_Tests.m
//  PIAPI Tests
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PIAPI.h"

@interface PIAPI_Tests : XCTestCase

@property PIAPI *lbc_api;
@property PIAPI *micro_api;

@end

@implementation PIAPI_Tests


- (void)setUp {
    [super setUp];
    NSError *error = nil;
    NSURL *lbc_url = [NSURL URLWithString:@"https://lesbonneschoses.cdn.prismic.io/api"];
    self->_lbc_api = [PIAPI ApiWithURL:lbc_url error:&error];
    NSURL *micro_url = [NSURL URLWithString:@"https://micro.prismic.io/api"];
    self->_micro_api = [PIAPI ApiWithURL:micro_url error:&error];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrivate {
    /**
     * Make sure a call to a private repository without a token returns the expected error
     */
    NSError *error = nil;
    NSURL *lbc_url = [NSURL URLWithString:@"https://private-test..prismic.io/api"];
    self->_lbc_api = [PIAPI ApiWithURL:lbc_url error:&error];
    XCTAssertNotNil(error);
}

- (void)testApiInitialized {
    /**
     * Tests whether the api object was initialized, and it ready to be used,
     * and checks whether its master id is available and correct.
     */
    NSString *master = self->_lbc_api.masterRef.ref;
    XCTAssertTrue([master isEqualToString:@"UlfoxUnM08QWYXdl"]);
}

- (void)testQueryWorks {
    NSError *error = nil;
    NSString *master = self->_lbc_api.masterRef.ref;
    PISearchForm *form = [self->_lbc_api searchFormForName:@"products"];
    [form setRef:master];
    PISearchResult *response = [form submit:&error];
    XCTAssertNil(error);
    XCTAssertEqual(response.results.count, 16);
}

@end
