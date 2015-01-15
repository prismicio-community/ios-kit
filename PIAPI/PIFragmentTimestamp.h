//
//  PIFragmentTimestamp.h
//  PIAPI
//
//  Created by Erwan Loisant on 15/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIFragmentTimestamp : NSObject

@property (nonatomic, readonly) NSDate *value;

- (PIFragmentTimestamp *)initWithJson:(id)jsonObject;

@end
