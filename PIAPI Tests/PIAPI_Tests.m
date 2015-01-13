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
    NSURL *lbc_url = [NSURL URLWithString:@"https://private-test.prismic.io/api"];
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

- (void)testGroupFragments {
    NSError *error = nil;
    NSString *master = self->_micro_api.masterRef.ref;
    PISearchForm *form = [self->_micro_api searchFormForName:@"everything"];
    [form setRef:master];
    [form addQuery:@"[[:d = at(document.type, \"docchapter\")]]"];
    [form setOrderings:@"[my.docchapter.priority]"];
    PISearchResult *response = [form submit:&error];

    PIDocument *docchapter = response.results[0];
    PIFragmentGroup *docchapterGroup = [docchapter getGroup:@"docchapter.docs"];
    XCTAssertEqual(docchapterGroup.groupDocs.count, 2);

    // Properly browsing the group until inside a subfragment"
    PIWithFragments *groupDoc = docchapterGroup.groupDocs[0];
    PIFragmentLinkDocument *link = (PIFragmentLinkDocument *)[groupDoc getLink:@"linktodoc"];
    XCTAssertTrue([link.id isEqualToString:@"UrDofwEAALAdpbNH"]);
}

- (void)testLinkedDocuments {
    NSError *error = nil;
    NSString *master = self->_micro_api.masterRef.ref;
    PISearchForm *form = [self->_micro_api searchFormForName:@"everything"];
    [form setRef:master];
    [form addQuery:@"[[:d = any(document.type, [\"doc\", \"docchapter\"])]]"];
    PISearchResult *response = [form submit:&error];
    PIDocument *first = response.results[0];
    XCTAssertEqual([[first linkedDocuments] count], 1);
}

- (void)testPagination {
    NSError *error = nil;
    NSString *master = self->_lbc_api.masterRef.ref;

    // Page number is right if page 1 requested
    PISearchForm *form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertEqual([form submit:&error].page, 1);

    // Results per page is right if page 1 requested
    form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertEqual([form submit:&error].resultsPerPage, 20);
    
    // Total results size is right if page 1 requested
    form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertEqual([form submit:&error].totalResultsSize, 40);

    // Total pages is right if page 1 requested
    form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertEqual([form submit:&error].totalPages, 2);

    // Next page is right if page 1 requested
    form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertTrue([[form submit:&error].nextPage.absoluteString isEqual:@"https://lesbonneschoses.cdn.prismic.io/api/documents/search?ref=UlfoxUnM08QWYXdl&page=2&pageSize=20"]);
    
    // Previous page is right if page 1 requested
    form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    XCTAssertNil([form submit:&error].prevPage);
}

- (void)testFormFunction {
    NSError *error = nil;
    NSString *master = self->_lbc_api.masterRef.ref;

    // The page and pageSize functions work well with an integer
    PISearchForm *form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    [form setPage:2];
    [form setPageSize:15];
    PISearchResult *docsInt = [form submit:&error];
    XCTAssertEqual(docsInt.page, 2);
    XCTAssertEqual(docsInt.resultsPerPage, 15);
    XCTAssertEqual([docsInt.results count], 15);

    // Orderings
    form = [self->_lbc_api searchFormForName:@"products"];
    [form setRef:master];
    [form setOrderings:@"[my.product.price]"];
    PISearchResult *orderedProducts = [form submit:&error];
    PIDocument *first = orderedProducts.results[0];
    XCTAssertTrue([first.id isEqual:@"UlfoxUnM0wkXYXbK"]);
}

- (void)testFetchLinks {
    NSError *error = nil;
    NSString *master = self->_lbc_api.masterRef.ref;
    PISearchForm *form = [self->_lbc_api searchFormForName:@"everything"];
    [form setRef:master];
    [form setFetchLinks:@"blog-post.author"];
    [form addQuery:@"[[:d = at(document.id, \"UlfoxUnM0wkXYXbt\")]]"];
    PISearchResult *response = [form submit:&error];
    PIFragmentLinkDocument *link = (PIFragmentLinkDocument*)[response.results[0] getLink:@"blog-post.relatedpost[0]"];
    NSLog(@"Link fragments: %li", [link.data count]);
    NSLog(@"Author name = %@", [link getText:@"blog-post.author"]);
    XCTAssertTrue([[link getText:@"blog-post.author"] isEqual:@"John M. Martelle, Fine Pastry Magazine"]);
}


@end
