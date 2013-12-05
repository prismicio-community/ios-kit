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
    field->_type = [jsonObject objectForKey:@"type"];
    field->_default = [jsonObject objectForKey:@"default"];
    NSNumber *multiple = [jsonObject objectForKey:@"multiple"];
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

- (NSString *)default
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
    form->_method = [jsonObject objectForKey:@"method"];
    form->_rel = [jsonObject objectForKey:@"rel"];
    form->_enctype = [jsonObject objectForKey:@"enctype"];
    form->_action = [jsonObject objectForKey:@"action"];
    NSDictionary *fieldsJson = [jsonObject objectForKey:@"fields"];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    form->_fields = fields;
    for (NSString *fieldName in fieldsJson) {
        NSDictionary *fieldJson = [fieldsJson objectForKey:fieldName];
        PIField *field = [PIField fieldWithJson:fieldJson name:fieldName];
        [fields setValue:field forKey:fieldName];
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
