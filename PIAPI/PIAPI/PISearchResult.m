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

@interface PISearchResult ()
{
    NSMutableArray *_results;
    NSNumber *_page;
    NSNumber *_resultsPerPage;
    NSNumber *_resultsSize;
    NSNumber *_totalPages;
    NSNumber *_totalResultsSize;
    NSURL *_prevPage;
    NSURL *_nextPage;
}

@end

@implementation PISearchResult

+ (PISearchResult *)SearchResultFromJson:(id)jsonObject
{
    PISearchResult *searchResult = [[PISearchResult alloc] init];
    
    searchResult->_results = [[NSMutableArray alloc] init];
    NSArray *results = jsonObject[@"results"];
    for (id result in results) {
        PIDocument *document = [PIDocument documentWithJson:result];
        [searchResult->_results addObject:document];
    }

    searchResult->_page = jsonObject[@"page"];
    searchResult->_resultsPerPage = jsonObject[@"results_per_page"];
    searchResult->_resultsSize = jsonObject[@"results_size"];
    searchResult->_totalPages = jsonObject[@"total_pages"];
    searchResult->_totalResultsSize = jsonObject[@"total_results_size"];
    
    id prevPage = jsonObject[@"prev_page"];
    if (prevPage != [NSNull null]) {
        searchResult->_prevPage = [NSURL URLWithString:prevPage];
    }
    id nextPage = jsonObject[@"next_page"];
    if (nextPage != [NSNull null]) {
        searchResult->_nextPage = [NSURL URLWithString:nextPage];
    }
    
    return searchResult;
}

- (NSMutableArray *)results
{
    return _results;
}

- (NSNumber *)page
{
    return _page;
}


- (NSNumber *)resultsPerPage
{
    return _resultsPerPage;
}


- (NSNumber *)resultsSize
{
    return _resultsSize;
}


- (NSNumber *)totalPages
{
    return _totalPages;
}


- (NSNumber *)totalResultsSize
{
    return _totalResultsSize;
}


- (NSURL *)prevPage
{
    return _prevPage;
}


- (NSURL *)nextPage
{
    return _nextPage;
}


@end
