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

    NSURL *_url;
    NSString *_accessToken;
    
    NSMutableDictionary *_refs;
    PIRef *_masterRef;
    NSMutableDictionary *_bookmarks;
    NSMutableDictionary *_types;
    NSMutableArray *_tags;
    NSMutableDictionary *_forms;
    
    NSString *_oauthInitiate;
    NSString *_oauthToken;

}
@end

@implementation PIAPI

+ (PIAPI *)apiWithURL:(NSURL *)url error:(NSError **)error
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
        PIAPI *api = [PIAPI apiWithJsonString:data error:&localError];
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

+ (PIAPI *)apiWithURL:(NSURL *)url andAccessToken:(NSString *)accessToken error:(NSError **)error
{
    
    NSError *localError = nil;
    NSString *query = [[NSString alloc] initWithFormat:@"%@=%@", @"access_token", accessToken];
    NSURL *urlWithQuery = [url URLByAppendingQueryString: query];
    PIAPI *api = [PIAPI apiWithURL:urlWithQuery error:&localError];
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

+ (PIAPI *)apiWithJsonString:(id)jsonString error:(NSError **)error
{
    NSError * localError = nil;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonString
                                                     options:NSJSONReadingMutableContainers
                                                       error:&localError];
    if (localError == nil) {
        PIAPI *api = [PIAPI apiWithJson: jsonObjects];
        return api;
    }
    else {
        *error = localError;
        return nil;
    }
}

+ (PIAPI *)apiWithJson:(id)jsonObjects
{
    PIAPI *api = [[PIAPI alloc] init];
    
    api->_refs = [[NSMutableDictionary alloc] init];
    NSArray *refsJson = jsonObjects[@"refs"];
    for (id refJson in refsJson) {
        PIRef *ref = [PIRef refWithJson:refJson];
        if ([ref isMasterRef]) {
            api->_masterRef = ref;
        }
        api->_refs[[ref label]] = ref;
    }
    
    api->_bookmarks = [[NSMutableDictionary alloc] init];
    NSDictionary *bookmarks = jsonObjects[@"bookmarks"];
    for (NSString *bookmarkName in bookmarks) {
        NSString *bookmark = bookmarks[bookmarkName];
        api->_bookmarks[bookmarkName] = bookmark;
    }
    
    api->_types = [[NSMutableDictionary alloc] init];
    NSDictionary *types = jsonObjects[@"types"];
    for (NSString *typeName in types) {
        NSString *type = types[typeName];
        api->_types[typeName] = type;
    }
    
    api->_tags = [[NSMutableArray alloc] init];
    NSArray *tags = jsonObjects[@"tags"];
    for (NSString *tag in tags) {
        [api->_tags addObject:tag];
    }
    
    api->_forms = [[NSMutableDictionary alloc] init];
    NSDictionary *forms = jsonObjects[@"forms"];
    for (NSString *formName in forms) {
        NSDictionary *formJson = forms[formName];
        PIForm *form = [PIForm formWithJson:formJson name:formName];
        api->_forms[formName] = form;
    }
    
    api->_oauthInitiate = jsonObjects[@"oauth_initiate"];
    api->_oauthToken = jsonObjects[@"oauth_token"];
    
    return api;
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
    return [_masterRef ref];
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
    return [PISearchForm searchFormWithApi:self form:form];
}

@end
