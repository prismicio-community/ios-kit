//
//  PISearchResult.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 05/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PISearchResult.h"


/*
 
 {
 "next_page": "https://lesbonneschoses-uj8crgij1aniotz.prismic.io/api/documents/search?ref=UpXqTwEAAG8A9k-0&page=2&pageSize=20",
 "page": 1,
 "prev_page": null,
 "results": [],
 "results_per_page": 20,
 "results_size": 20,
 "total_pages": 3,
 "total_results_size": 45
 }
 */

@interface PISearchResult ()
{
    NSArray *_results;
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
    [jsonObject objectForKey:@"results"];

    searchResult->_page = [jsonObject objectForKey:@"page"];
    searchResult->_resultsPerPage = [jsonObject objectForKey:@"results_per_page"];
    searchResult->_resultsSize = [jsonObject objectForKey:@"results_size"];
    searchResult->_totalPages = [jsonObject objectForKey:@"total_pages"];
    searchResult->_totalResultsSize = [jsonObject objectForKey:@"total_results_size"];
    
    id prevPage = [jsonObject objectForKey:@"prev_page"];
    if (prevPage != [NSNull null]) {
        searchResult->_prevPage = [NSURL URLWithString:prevPage];
    }
    id nextPage = [jsonObject objectForKey:@"next_page"];
    if (nextPage != [NSNull null]) {
        searchResult->_nextPage = [NSURL URLWithString:nextPage];
    }
    
    return searchResult;
}

@end
