//
//  PIForm.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 02/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIForm.h"

@implementation PIField

@synthesize name = _name;
@synthesize type = _type;
@synthesize defaultValue = _defaultValue;
@synthesize multiple = _multiple;

+ (PIField *)FieldWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    return [[PIField alloc] initWithJson:jsonObject name:name];
}

- (PIField *)initWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    self = [self init];
    _name = name;
    _type = jsonObject[@"type"];
    _defaultValue = jsonObject[@"default"];
    NSNumber *multiple = jsonObject[@"multiple"];
    _multiple = multiple && multiple.boolValue;;
    return self;
}

@end

@implementation PIForm

@synthesize name = _name;
@synthesize method = _method;
@synthesize rel = _rel;
@synthesize enctype = _enctype;
@synthesize action = _action;
@synthesize fields = _fields;

+ (PIForm *)FormWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    return [[PIForm alloc] initWithJson:jsonObject name:name];
}

- (PIForm *)initWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    self = [self init];
    _name = name;
    _method = jsonObject[@"method"];
    _rel = jsonObject[@"rel"];
    _enctype = jsonObject[@"enctype"];
    _action = jsonObject[@"action"];
    NSDictionary *fieldsJson = jsonObject[@"fields"];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in fieldsJson) {
        NSDictionary *fieldJson = fieldsJson[fieldName];
        PIField *field = [PIField FieldWithJson:fieldJson name:fieldName];
        fields[fieldName] = field;
    }
    _fields = fields;

    return self;
}

- (PIField *)fieldForName:(NSString *)name
{
    return [_fields valueForKey:name];
}

@end
