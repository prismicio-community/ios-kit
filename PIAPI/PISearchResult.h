//
//  PISearchResult.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 05/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PISearchResult.h"

@interface PISearchResult : NSObject

+ (PISearchResult *)SearchResultWithJson:(id)jsonObject;

@property (nonatomic, readonly) NSArray *results;
@property (readonly) NSUInteger page;
@property (readonly) NSUInteger resultsPerPage;
@property (readonly) NSUInteger resultsSize;
@property (readonly) NSUInteger totalPages;
@property (nonatomic, readonly) NSUInteger totalResultsSize;
@property (nonatomic, readonly) NSURL *prevPage;
@property (nonatomic, readonly) NSURL *nextPage;

@end
