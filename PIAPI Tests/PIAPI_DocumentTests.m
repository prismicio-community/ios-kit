//
//  PIAPI_DocumentTests.m
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PIAPI.h"

@interface PIAPI_DocumentTests : XCTestCase

@end

@implementation PIAPI_DocumentTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) image {
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:@"https://test-public.prismic.io/api"];
    PIAPI *api = [PIAPI ApiWithURL:url error:&error];

    NSString *master = api.masterRef.ref;
    PISearchForm *form = [api searchFormForName:@"everything"];
    [form setRef:master];
    [form addQuery:@"[[:d = at(document.id, \"Uyr9sgEAAGVHNoFZ\")]]"];
    PISearchResult *response = [form submit:&error];
    
    PIDocument *doc = response.results[0];
    PIFragmentImageView *image = [doc getImageView:@"article.illustration" view:@"icon"];
    NSString *expected = @"https://prismic-io.s3.amazonaws.com/test-public/9f5f4e8a5d95c7259108e9cfdde953b5e60dcbb6.jpg";
    XCTAssertTrue([image.url.absoluteString isEqual:expected]);
}

@end
