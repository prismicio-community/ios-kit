//
//  PIRef.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 28/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRef : NSObject

+ (PIRef *) refWithJson:(NSDictionary *)jsonObject;

- (NSString *) ref;
- (NSString *) label;
- (BOOL) isMasterRef;

@end
