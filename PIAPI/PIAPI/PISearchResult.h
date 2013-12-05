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

+ (PISearchResult *)SearchResultFromJson:(id)jsonObject;

@end
