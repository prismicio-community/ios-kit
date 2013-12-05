//
//  PIForm.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 02/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIField : NSObject

+ (PIField *)fieldWithJson:(NSDictionary *)jsonObject name:(NSString *)name;

- (NSString *)type;
- (NSString *)fieldDefault;

@end

@interface PIForm : NSObject

+ (PIForm *)formWithJson:(NSDictionary *)jsonObject name:(NSString *)name;

- (NSString *)name;
- (NSString *)method;
- (NSString *)rel;
- (NSString *)enctype;
- (NSString *)action;
- (NSDictionary *)fields;

- (PIField *)fieldForName:(NSString *)name;



@end
