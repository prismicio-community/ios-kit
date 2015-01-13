//
//  PIFragmentBlockSpan.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentBlockSpan.h"

@implementation PIFragmentBlockSpan

+ (id <PIFragmentBlockSpan>)SpanWithJson:(id)jsonObject
{
    id <PIFragmentBlockSpan> span = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragmentBlockSpan> (^selectedCase)() = @{
            @"em" : ^{
                return [PIFragmentBlockSpanEm SpanWithJson:jsonObject];
            },
            @"strong" : ^{
                return [PIFragmentBlockSpanStrong SpanWithJson:jsonObject];
            },
            @"hyperlink" : ^{
                return [PIFragmentBlockSpanLink SpanWithJson:jsonObject];
            },
        }[type];
        if (selectedCase != nil) {
            span = selectedCase();
        }
        else {
            NSLog(@"Unsupported span type: %@", type);
        }
    }
    return span;
}

+ (NSAttributedString *)formatText:(id <PIFragmentBlockText>)block fontDescriptor:(UIFontDescriptor *)fontDescriptor
{
    // Create styles
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFontDescriptor *italicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont *normalFont = [UIFont fontWithDescriptor:fontDescriptor size:0.0];
    UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont *italicFont = [UIFont fontWithDescriptor:italicFontDescriptor size: 0.0];
    NSDictionary *normalAttributes = @{ NSFontAttributeName : normalFont };
    NSDictionary *boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary *italicAttributes = @{ NSFontAttributeName : italicFont };
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[block text]];
    [content addAttributes:normalAttributes range:NSMakeRange(0, [content length])];
    
    NSArray *spans = [block spans];
    for (id <PIFragmentBlockSpan> span in spans) {
        void (^selectedCase)() = @{
            @"em" : ^{
                [content addAttributes:boldAttributes range:[span range]];
            },
            @"strong" : ^{
                [content addAttributes:italicAttributes range:[span range]];
            },
        }[[span type]];
        if (selectedCase != nil) {
            selectedCase();
        }
    }
    
    return content;
}

@end

@interface PIFragmentBlockSpanEm ()
{
    NSRange _range;
}
@end

@implementation PIFragmentBlockSpanEm

+ (PIFragmentBlockSpanEm *)SpanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanEm *span = [[PIFragmentBlockSpanEm alloc] init];
    NSUInteger start = [jsonObject[@"start"] unsignedIntegerValue];
    NSUInteger end = [jsonObject[@"end"] unsignedIntegerValue];
    NSUInteger length = end - start;
    span->_range = NSMakeRange(start, length);
    return span;
}

- (NSString *)type
{
    return @"em";
}

- (NSRange)range
{
    return _range;
}

@end

@interface PIFragmentBlockSpanStrong ()
{
    NSRange _range;
}
@end

@implementation PIFragmentBlockSpanStrong

+ (PIFragmentBlockSpanStrong *)SpanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanStrong *span = [[PIFragmentBlockSpanStrong alloc] init];
    NSUInteger start = [jsonObject[@"start"] unsignedIntegerValue];
    NSUInteger end = [jsonObject[@"end"] unsignedIntegerValue];
    NSUInteger length = end - start;
    span->_range = NSMakeRange(start, length);
    return span;
}

- (NSString *)type
{
    return @"strong";
}

- (NSRange)range
{
    return _range;
}

@end

@interface PIFragmentBlockSpanLink ()
{
    NSRange _range;
    PIFragmentLink *_link;
}
@end

@implementation PIFragmentBlockSpanLink

+ (PIFragmentBlockSpanLink *)SpanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanLink *span = [[PIFragmentBlockSpanLink alloc] init];
    NSUInteger start = [jsonObject[@"start"] unsignedIntegerValue];
    NSUInteger end = [jsonObject[@"end"] unsignedIntegerValue];
    NSUInteger length = end - start;
    span->_range = NSMakeRange(start, length);
    span->_link = [PIFragmentLink LinkWithJson:jsonObject[@"data"]];
    return span;
}

- (NSString *)type
{
    return @"hyperlink";
}

- (NSRange)range
{
    return _range;
}

- (PIFragmentLink *)link
{
    return _link;
}

@end
