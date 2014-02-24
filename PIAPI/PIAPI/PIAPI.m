//
//  PIAPI.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIAPI.h"

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

@interface PIAPI ()
{
    NSMutableDictionary *_forms;
    NSString *_oauthInitiate;
    NSString *_oauthToken;
}
@end

@implementation PIAPI

@synthesize url = _url;
@synthesize accessToken = _accessToken;
@synthesize refs = _refs;
@synthesize masterRef = _masterRef;
@synthesize bookmarks = _bookmarks;
@synthesize types = _types;
@synthesize tags = _tags;

+ (PIAPI *)ApiWithURL:(NSURL *)url error:(NSError **)error
{
    // Send a synchronous request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLResponse *response = nil;
    NSError *localError = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&localError];
    if (localError == nil) {
        PIAPI *api = [PIAPI ApiWithJsonString:data error:&localError];
        if (localError == nil) {
            api->_url = url;
            return api;
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

+ (PIAPI *)ApiWithURL:(NSURL *)url andAccessToken:(NSString *)accessToken error:(NSError **)error
{
    
    NSError *localError = nil;
    NSString *query = [[NSString alloc] initWithFormat:@"%@=%@", @"access_token", accessToken];
    NSURL *urlWithQuery = [url URLByAppendingQueryString: query];
    PIAPI *api = [PIAPI ApiWithURL:urlWithQuery error:&localError];
    if (localError == nil) {
        api->_accessToken = accessToken;
        api->_url = url;  // stores the URL without the accessToken part
        return api;
    }
    else {
        *error = localError;
        return nil;
    }
}

+ (PIAPI *)ApiWithJsonString:(id)jsonString error:(NSError **)error
{
    NSError * localError = nil;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonString
                                                     options:NSJSONReadingMutableContainers
                                                       error:&localError];
    if (localError == nil) {
        PIAPI *api = [PIAPI ApiWithJson: jsonObjects];
        return api;
    }
    else {
        *error = localError;
        return nil;
    }
}

+ (PIAPI *)ApiWithJson:(id)jsonObjects
{
    return [[PIAPI alloc] initWithJson:jsonObjects];
}

- (PIAPI *)initWithJson:(id)jsonObjects
{
    self = [self init];
    
    NSMutableDictionary *refs = [[NSMutableDictionary alloc] init];
    NSArray *refsJson = jsonObjects[@"refs"];
    for (id refJson in refsJson) {
        PIRef *ref = [PIRef RefWithJson:refJson];
        if (ref.isMasterRef) {
            _masterRef = ref;
        }
        refs[ref.label] = ref;
    }
    _refs = refs;

    NSMutableDictionary *bookmarks = [[NSMutableDictionary alloc] init];
    NSDictionary *bookmarkFields = jsonObjects[@"bookmarks"];
    for (NSString *bookmarkName in bookmarkFields) {
        NSString *bookmark = bookmarkFields[bookmarkName];
        bookmarks[bookmarkName] = bookmark;
    }
    _bookmarks = bookmarks;
    
    NSMutableDictionary *types = [[NSMutableDictionary alloc] init];
    NSDictionary *typeFields = jsonObjects[@"types"];
    for (NSString *typeName in typeFields) {
        NSString *type = typeFields[typeName];
        types[typeName] = type;
    }
    _types = types;
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    NSArray *tagFields = jsonObjects[@"tags"];
    for (NSString *tag in tagFields) {
        [tags addObject:tag];
    }
    _tags = tags;
    
    _forms = [[NSMutableDictionary alloc] init];
    NSDictionary *forms = jsonObjects[@"forms"];
    for (NSString *formName in forms) {
        NSDictionary *formJson = forms[formName];
        PIForm *form = [PIForm FormWithJson:formJson name:formName];
        _forms[formName] = form;
    }
    
    _oauthInitiate = jsonObjects[@"oauth_initiate"];
    _oauthToken = jsonObjects[@"oauth_token"];
    
    return self;
}

- (NSURL *)url
{
    return _url;
}

- (NSString *)accessToken
{
    return _accessToken;
}

- (PIDocument *)getDocument
{
    return [[PIDocument alloc] init];
}

- (NSDictionary *)refs
{
    return _refs;
}

- (NSDictionary *)bookmarks
{
    return _bookmarks;
}

- (NSDictionary *)types
{
    return _types;
}

- (NSArray *)tags
{
    return _tags;
}

- (NSDictionary *)forms {
    return _forms;
}

- (NSString *)oauthInitiate
{
    return _oauthInitiate;
}

- (NSString *)oauthToken
{
    return _oauthToken;
}

- (PIRef *)refObjectForName:(NSString *)name
{
    return _refs[name];
}

- (NSString *)refForName:(NSString *)name
{
    return [_refs[name] ref];
}

- (PIRef *)masterRefObject
{
    return _masterRef;
}

- (NSString *)masterRefName
{
    return _masterRef.ref;
}

- (NSString *)bookmarkForName:(NSString *)name
{
    return _bookmarks[name];
}

- (NSString *)typeForName:(NSString *)name
{
    return _types[name];
}

- (PIForm *)formForName:(NSString *)name
{
    return _forms[name];
}

- (PISearchForm *)searchFormForName:(NSString *)name
{
    PIForm *form = [self formForName:name];
    return [PISearchForm SearchFormWithApi:self form:form];
}

@end
