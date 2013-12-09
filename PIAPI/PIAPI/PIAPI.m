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
    NSArray *refsJson = [jsonObjects objectForKey:@"refs"];
    for (id refJson in refsJson) {
        PIRef *ref = [PIRef refWithJson:refJson];
        if ([ref isMasterRef]) {
            api->_masterRef = ref;
        }
        [api->_refs setValue:ref forKey:[ref label]];
    }
    
    api->_bookmarks = [[NSMutableDictionary alloc] init];
    NSDictionary *bookmarks = [jsonObjects objectForKey:@"bookmarks"];
    for (NSString *bookmarkName in bookmarks) {
        NSString *bookmark = [bookmarks objectForKey:bookmarkName];
        [api->_bookmarks setValue:bookmark forKey:bookmarkName];
    }
    
    api->_types = [[NSMutableDictionary alloc] init];
    NSDictionary *types = [jsonObjects objectForKey:@"types"];
    for (NSString *typeName in types) {
        NSString *type = [types objectForKey:typeName];
        [api->_types setValue:type forKey:typeName];
    }
    
    api->_tags = [[NSMutableArray alloc] init];
    NSArray *tags = [jsonObjects objectForKey:@"tags"];
    for (NSString *tag in tags) {
        [api->_tags addObject:tag];
    }
    
    api->_forms = [[NSMutableDictionary alloc] init];
    NSDictionary *forms = [jsonObjects objectForKey:@"forms"];
    for (NSString *formName in forms) {
        NSDictionary *formJson = [forms objectForKey:formName];
        PIForm *form = [PIForm formWithJson:formJson name:formName];
        [api->_forms setValue:form forKey:formName];
    }
    
    api->_oauthInitiate = [jsonObjects objectForKey:@"oauth_initiate"];
    api->_oauthToken = [jsonObjects objectForKey:@"oauth_token"];
    
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
    return [_refs valueForKey:name];
}

- (NSString *)refForName:(NSString *)name
{
    return [[_refs valueForKey:name] ref];
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
    return [_bookmarks objectForKey:name];
}

- (NSString *)typeForName:(NSString *)name
{
    return [_types objectForKey:name];
}

- (PIForm *)formForName:(NSString *)name
{
    return [_forms objectForKey:name];
}

- (PISearchForm *)searchFormForName:(NSString *)name
{
    PIForm *form = [self formForName:name];
    return [PISearchForm searchFormWithApi:self form:form];
}

@end
