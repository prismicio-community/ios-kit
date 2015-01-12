//
//  PISearchForm.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 05/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PISearchForm.h"

@implementation NSURL (Additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}

@end

@protocol PIFormData

- (void)setValue:(id)value;

- (NSString *)queryString;
@end

@interface PIFormDatum : NSObject <PIFormData>
{
    id _name;
    id _value;
}
@end

@implementation PIFormDatum

+ (PIFormDatum *)FormDatumWithName:(NSString *)name
{
    PIFormDatum *datum = [[PIFormDatum alloc] init];
    datum->_name = name;
    return datum;
}

- (void)setValue:(id)value
{
    self->_value = value;
}

- (NSString *)queryString
{
    return [NSString stringWithFormat:@"%@=%@", _name, _value];
}

@end

@interface PIFormData : NSObject <PIFormData>
{
    NSMutableArray *_values;
    id _name;
}
@end

@implementation PIFormData

+ (PIFormData *)FormDataWithName:(NSString *)name
{
    PIFormData *data = [[PIFormData alloc] init];
    data->_name = name;
    data->_values = [[NSMutableArray alloc] init];
    return data;
}

- (void)setValue:(id)value
{
    [_values addObject:value];
}

- (NSString *)queryString
{
    NSMutableArray *query = [[NSMutableArray alloc] init];
    for (id value in _values) {
        [query addObject:[NSString stringWithFormat:@"%@=%@", _name, value]];
    }
    return [query componentsJoinedByString:@"&"];
}

@end

@interface PISearchForm ()
{
    PIAPI *_api;
    PIForm *_form;
    NSMutableDictionary *_data;
}
@end

@implementation PISearchForm

+ (PISearchForm *)SearchFormWithApi:(PIAPI *)api form:(PIForm *)form
{
    PISearchForm *searchForm = [[PISearchForm alloc] init];
    searchForm->_api = api;
    searchForm->_form = form;
    searchForm->_data = [[NSMutableDictionary alloc] init];
    NSDictionary *fields = searchForm->_form.fields;
    for (NSString *fieldName in fields) {
        PIField *field = fields[fieldName];
        if (field.defaultValue) {
            [searchForm setValue:field.defaultValue forKey:fieldName];
        }
    }
    return searchForm;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    id <PIFormData> data = _data[key];
    if (!data) {
        if ([self isMultiple:key]) {
            data = [PIFormData FormDataWithName:key];
        }
        else {
            data = [PIFormDatum FormDatumWithName:key];
        }
        _data[key] = data;
    }
    [data setValue:value];
}

- (void)addQuery:(NSString *)query
{
    [self setValue:query forKey:@"query"];
}

- (void)setRefName:(NSString *)name
{
    [self setRef:[_api refForName:name]];
}

- (void)setRefObject:(PIRef *)ref
{
    [self setRef:ref.ref];
}

- (void)setRef:(NSString *)ref
{
    [self setValue:ref forKey:@"ref"];
}

- (PISearchResult *)submit:(NSError **)error
{
    NSString *ref = [self ref];
    if (ref == nil) {
        NSString *description = NSLocalizedString(@"Missing ref", @"");
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : description};
        *error = [[NSError alloc] initWithDomain:@"prismic.io"
                                            code:2
                                        userInfo:errorDictionary];
        return nil;
    }
    NSString *formMethod = _form.method;
    NSString *formEnctype = _form.enctype;
    if ([formMethod isEqualToString:@"GET"] && [formEnctype isEqualToString:@"application/x-www-form-urlencoded"]) {
        NSString *accessToken = _api.accessToken;
        NSURL *url = [NSURL URLWithString:_form.action];
        if (accessToken) {
            [self setValue:accessToken forKey:@"access_token"];
        }
        NSString *query = [self queryString];
        NSURL *urlWithQuery = [url URLByAppendingQueryString: query];
        NSLog(@"%@", urlWithQuery);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlWithQuery];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSURLResponse *response = nil;
        NSError *localError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&localError];
        if (localError == nil) {
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&localError];
            if (localError == nil) {
                PISearchResult *result = [PISearchResult SearchResultWithJson:jsonObjects];
                return result;
            }
            else {
                *error = localError;
                return nil;
            }
        }
        else {
            *error = localError;
            return nil;
        }
    }
    else {
        NSString *description = NSLocalizedString(@"Form's method or enctype not handled", @"");
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : description,
                                          @"formName" : _form.name,
                                          @"formMethod" : formMethod,
                                          @"formEnctype" : formEnctype};
        *error = [[NSError alloc] initWithDomain:@"prismic.io"
                                            code:0
                                        userInfo:errorDictionary];
        return nil;
    }
}

- (PISearchResult *)submitWithRefObject:(PIRef *)ref error:(NSError **)error
{
    [self setRefObject:ref];
    return [self submit:error];
}

- (PISearchResult *)submitWithRefName:(NSString *)ref error:(NSError **)error
{
    [self setRefName:ref];
    return [self submit:error];
}

// HELPERS

- (BOOL)isMultiple:(NSString *)fieldName
{
    PIField *field = [_form fieldForName:fieldName];
    if (field) {
        return field.isMultiple;
    }
    else {
        return false;
    }
}

- (NSString *)queryString
{
    NSMutableArray *query = [[NSMutableArray alloc] init];
    for (id <PIFormData> name in _data) {
        id <PIFormData> datum = _data[name];
        [query addObject:[datum queryString]];
    }
    return [query componentsJoinedByString:@"&"];
}

- (NSString *)ref
{
    return _data[@"ref"];
}

@end
