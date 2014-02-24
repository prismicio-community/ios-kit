//
//  PIAPI.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIDocument.h"
#import "PIRef.h"
#import "PIForm.h"
#import "PISearchForm.h"
#import "PISearchResult.h"

@class PIDocument;
@class PIRef;
@class PIForm;
@class PISearchForm;
@class PISearchResult;

@interface PIAPI : NSObject

+ (PIAPI *)ApiWithURL:(NSURL *)url error:(NSError **)error;
+ (PIAPI *)ApiWithURL:(NSURL *)url andAccessToken:(NSString *)accessToken error:(NSError **)error;

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSDictionary *refs;
@property (nonatomic, readonly) PIRef *masterRef;
@property (nonatomic, readonly) NSDictionary *bookmarks;
@property (nonatomic, readonly) NSDictionary *types;
@property (nonatomic, readonly) NSArray *tags;

- (NSDictionary *)forms;
- (NSString *)oauthInitiate;
- (NSString *)oauthToken;

- (PIRef *)refObjectForName:(NSString *)name;
- (NSString *)refForName:(NSString *)name;
- (PIRef *)masterRefObject;
- (NSString *)masterRefName;

- (NSString *)bookmarkForName:(NSString *)name;

- (NSString *)typeForName:(NSString *)name;

- (PIForm *)formForName:(NSString *)name;

- (PISearchForm *)searchFormForName:(NSString *)name;

@end