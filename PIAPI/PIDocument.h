//
//  PIDocument.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIWithFragments.h"

@interface PIDocument : PIWithFragments

+ (PIDocument *)DocumentWithJson:(id)jsonObject;

@property (nonatomic, readonly) NSURL *href;
@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSArray *slugs;
@property (nonatomic, readonly) NSArray *tags;
@property (nonatomic, readonly) NSString *type;

- (PIFragmentGroup *)getGroup:(NSString*)field;

@end
