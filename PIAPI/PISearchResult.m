//
//  PISearchResult.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 05/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PISearchResult.h"

#import "PIDocument.h"

@class PIDocument;

@implementation PISearchResult

@synthesize results = _results;
@synthesize page = _page;
@synthesize resultsPerPage = _resultsPerPage;
@synthesize resultsSize = _resultsSize;
@synthesize totalPages = _totalPages;
@synthesize totalResultsSize = _totalResultsSize;
@synthesize prevPage = _prevPage;
@synthesize nextPage = _nextPage;

+ (PISearchResult *)SearchResultWithJson:(id)jsonObject
{
    return [[PISearchResult alloc] initWithJson:jsonObject];
}

- (PISearchResult *)initWithJson:(id)jsonObject
{
    self = [self init];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSArray *resultFields = jsonObject[@"results"];
    for (id resultField in resultFields) {
        PIDocument *document = [PIDocument DocumentWithJson:resultField];
        [results addObject:document];
    }
    _results = results;

    _page = [jsonObject[@"page"] intValue];
    _resultsPerPage = [jsonObject[@"results_per_page"] intValue];
    _resultsSize = [jsonObject[@"results_size"] intValue];
    _totalPages = [jsonObject[@"total_pages"] intValue];
    _totalResultsSize = [jsonObject[@"total_results_size"] intValue];
    
    id prevPage = jsonObject[@"prev_page"];
    _prevPage = prevPage != [NSNull null] ? [NSURL URLWithString:prevPage] : nil;
    id nextPage = jsonObject[@"next_page"];
    _nextPage = nextPage != [NSNull null] ? [NSURL URLWithString:nextPage] : nil;
    
    return self;
}

@end
