//
//  PISearchForm.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 05/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIAPI.h"
#import "PIForm.h"
#import "PIRef.h"
#import "PISearchResult.h"

@class PIAPI;
@class PIForm;
@class PIRef;
@class PISearchResult;

@interface PISearchForm : NSObject

+ (PISearchForm *)SearchFormWithApi:(PIAPI *)api form:(PIForm *)form;

- (void)setValue:(id)value forKey:(NSString *)key;

- (void)addQuery:(NSString *)query;

- (void)setRefName:(NSString *)ref;
- (void)setRefObject:(PIRef *)ref;
- (void)setRef:(NSString *)ref;
- (void)setOrderings:(NSString *)orderings;

- (PISearchResult *)submit:(NSError **)error;

- (PISearchResult *)submitWithRefObject:(PIRef *)ref error:(NSError **)error;

- (PISearchResult *)submitWithRefName:(NSString *)ref error:(NSError **)error;

@end
