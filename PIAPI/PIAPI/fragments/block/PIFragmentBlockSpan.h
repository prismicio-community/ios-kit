//
//  PIFragmentBlockSpan.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PIFragmentBlock.h"
#import "PIFragmentLink.h"

@protocol PIFragmentBlockText;

@protocol PIFragmentBlockSpan <NSObject>

- (NSString *)type;
- (NSRange)range;

@end

@interface PIFragmentBlockSpanEm : NSObject <PIFragmentBlockSpan>

+ (PIFragmentBlockSpanEm *)spanWithJson:(id)jsonObject;

@end

@interface PIFragmentBlockSpanStrong : NSObject <PIFragmentBlockSpan>

+ (PIFragmentBlockSpanStrong *)spanWithJson:(id)jsonObject;

@end

@interface PIFragmentBlockSpanLink : NSObject <PIFragmentBlockSpan>

+ (PIFragmentBlockSpanLink *)spanWithJson:(id)jsonObject;

@end

@interface PIFragmentBlockSpan : NSObject

+ (id <PIFragmentBlockSpan>)spanWithJson:(id)jsonObject;

+ (NSAttributedString *)formatText:(id <PIFragmentBlockText>)block fontDescriptor:(UIFontDescriptor *)fontDescriptor;

@end