//
//  PIRef.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 28/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRef : NSObject

+ (PIRef *) RefWithJson:(id)jsonObject;

@property (nonatomic, readonly) NSString *ref;
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly, getter=isMasterRef) BOOL masterRef;

@end
