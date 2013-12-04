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

@interface PIAPI : NSObject

+ (PIAPI *) apiWithURL: (NSURL *)url error: (NSError **)error;
+ (PIAPI *) apiWithURL: (NSURL *)url andAccessToken: (NSString *)accessToken error: (NSError **)error;

- (NSURL *) url;
- (NSString *) accessToken;
- (NSDictionary *) refs;
- (NSDictionary *) bookmarks;
- (NSDictionary *) types;
- (NSArray *) tags;
- (NSDictionary *) forms;
- (NSString *) oauthInitiate;
- (NSString *) oauthToken;

- (PIRef *) refObjectForName:(NSString *)name;
- (NSString *) refForName:(NSString *)name;
- (NSString *) master;

- (NSString *) bookmarkForName:(NSString *)name;

- (NSString *) typeForName:(NSString *)name;

- (PIForm *) formForName:(NSString *)name;

@end