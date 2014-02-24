//
//  PIForm.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 02/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIField : NSObject

+ (PIField *)FieldWithJson:(NSDictionary *)jsonObject name:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *defaultValue;
@property (nonatomic, readonly, getter=isMultiple) BOOL multiple;

@end

@interface PIForm : NSObject

+ (PIForm *)FormWithJson:(NSDictionary *)jsonObject name:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *method;
@property (nonatomic, readonly) NSString *rel;
@property (nonatomic, readonly) NSString *enctype;
@property (nonatomic, readonly) NSString *action;
@property (nonatomic, readonly) NSDictionary *fields;

- (PIField *)fieldForName:(NSString *)name;


@end
