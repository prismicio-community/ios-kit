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

+ (PISearchForm *)searchFormWithApi:(PIAPI *)api form:(PIForm *)form;

- (void)setValue:(id)value forKey:(NSString *)key;

- (void)addQuery:(NSString *)query;

- (void)setRefName:(NSString *)ref;
- (void)setRefObject:(PIRef *)ref;
- (void)setRef:(NSString *)ref;

- (PISearchResult *)submit:(NSError **)error;

@end
