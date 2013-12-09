//
//  PIForm.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 02/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIForm.h"

@interface PIField ()
{
    NSString *_name;
    NSString *_type;
    NSString *_default;
    BOOL _multiple;
}
@end

@implementation PIField

+ (PIField *)fieldWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    PIField *field = [[PIField alloc] init];
    field->_name = name;
    field->_type = jsonObject[@"type"];
    field->_default = jsonObject[@"default"];
    NSNumber *multiple = jsonObject[@"multiple"];
    field->_multiple = multiple && multiple.boolValue;;
    return field;
}

- (NSString *)name
{
    return _name;
}

- (NSString *)type
{
    return _type;
}

- (NSString *)fieldDefault
{
    return _default;
}

- (BOOL)isMultiple
{
    return _multiple;
}

@end

@interface PIForm ()
{
    NSString *_name;
    NSString *_method;
    NSString *_rel;
    NSString *_enctype;
    NSString *_action;
    NSDictionary *_fields;
}
@end

@implementation PIForm

+ (PIForm *)formWithJson:(NSDictionary *)jsonObject name:(NSString *)name
{
    PIForm *form = [[PIForm alloc] init];
    form->_name = name;
    form->_method = jsonObject[@"method"];
    form->_rel = jsonObject[@"rel"];
    form->_enctype = jsonObject[@"enctype"];
    form->_action = jsonObject[@"action"];
    NSDictionary *fieldsJson = jsonObject[@"fields"];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    form->_fields = fields;
    for (NSString *fieldName in fieldsJson) {
        NSDictionary *fieldJson = fieldsJson[fieldName];
        PIField *field = [PIField fieldWithJson:fieldJson name:fieldName];
        fields[fieldName] = field;
    }
    return form;
}

- (NSString *)name
{
    return _name;
}

- (NSString *)method
{
    return _method;
}

- (NSString *)rel
{
    return _rel;
}

- (NSString *)enctype
{
    return _enctype;
}

- (NSString *)action
{
    return _action;
}

- (NSDictionary *)fields
{
    return _fields;
}

- (PIField *)fieldForName:(NSString *)name
{
    return [_fields valueForKey:name];
}

@end
