//
//  NSAttributedString+CustomAttributed.m
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "NSAttributedString+CustomAttributed.h"

@implementation NSAttributedString (CustomAttributed)

@end


@implementation NSAttributedString (CommodityConstructors)

+ (id)attributedStringWithString:(NSString*)string
{
    return string ? [[self alloc] initWithString:string] : nil;
}

+ (id)attributedStringWithAttributedString:(NSAttributedString*)attrStr
{
    return attrStr ? [[self alloc] initWithAttributedString:attrStr] : nil;
}

- (CGSize)sizeConstrainedToSize:(CGSize)maxSize
{
    return [self sizeConstrainedToSize:maxSize fitRange:NULL];
}

- (CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CFRange fitCFRange = CFRangeMake(0,0);
    CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
    if (framesetter) CFRelease(framesetter);
    if (fitRange) *fitRange = NSMakeRange(fitCFRange.location, fitCFRange.length);
    return CGSizeMake(floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
}

@end


@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

- (void)setFont:(UIFont*)font
{
    [self setFontName:font.fontName size:font.pointSize];
}

- (void)setFont:(UIFont*)font range:(NSRange)range
{
    [self setFontName:font.fontName size:font.pointSize range:range];
}

- (void)setFontName:(NSString*)fontName size:(CGFloat)size
{
    [self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}

- (void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range
{
    // kCTFontAttributeName
    CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, size, NULL);
    if (!aFont) return;
    [self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
    //    [self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
    CFRelease(aFont);
}

- (void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range
{
    // kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
    CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
    NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
    NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          fontFamily,kCTFontFamilyNameAttribute,
                          trait,kCTFontTraitsAttribute,nil];
    
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attr);
    if (!desc) {
        if (desc)CFRelease(desc);
        return;
    }
    CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
    
    CFRelease(desc);
    if (!aFont) {
        //        if (aFont)CFRelease(aFont);
        return;
    }
    
    [self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
    if (aFont)CFRelease(aFont);
}

- (void)setTextColor:(UIColor*)color
{
    [self setTextColor:color range:NSMakeRange(0,[self length])];
}

- (void)setTextColor:(UIColor*)color range:(NSRange)range
{
    // kCTForegroundColorAttributeName
    if (range.location > self.string.length - 1 || range.location + range.length > self.string.length) {
        return;
    }
    [self removeAttribute:(__bridge NSString*)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(__bridge NSString*)kCTForegroundColorAttributeName value:(__bridge id)color.CGColor range:range];
}

- (void)setTextIsUnderlined:(BOOL)underlined
{
    [self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}

- (void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range
{
    int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
    [self setTextUnderlineStyle:style range:range];
}

- (void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range
{
    [self removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

- (void)setTextBold:(BOOL)isBold range:(NSRange)range
{
    NSUInteger startPoint = range.location;
    NSRange effectiveRange;
    do {
        // Get font at startPoint
        CTFontRef currentFont = (__bridge CTFontRef)[self attribute:(NSString*)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
        // The range for which this font is effective
        NSRange fontRange = NSIntersectionRange(range, effectiveRange);
        // Create bold/unbold font variant for this font and apply
        CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (isBold?kCTFontBoldTrait:0), kCTFontBoldTrait);
        if (newFont) {
            [self removeAttribute:(NSString*)kCTFontAttributeName range:fontRange]; // Work around for Apple leak
            [self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)newFont range:fontRange];
            CFRelease(newFont);
        } else {
            NSLog(@"[OHAttributedLabel] Warning: can't find a bold font variant for font %@. Try another font family (like Helvetica) instead.",(__bridge_transfer NSString*)CTFontCopyFullName(currentFont));
        }
        ////[self removeAttribute:(NSString*)kCTFontWeightTrait range:fontRange]; // Work around for Apple leak
        ////[self addAttribute:(NSString*)kCTFontWeightTrait value:(id)[NSNumber numberWithInt:1.0f] range:fontRange];
        
        // If the fontRange was not covering the whole range, continue with next run
        startPoint = NSMaxRange(effectiveRange);
    } while(startPoint<NSMaxRange(range));
}

- (void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode
{
    [self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}

- (void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range
{
    // kCTParagraphStyleAttributeName > kCTParagraphStyleSpecifierAlignment
    CGFloat spacing = 4.0;  //指定行间距
    CTParagraphStyleSetting paraStyles[3] = {
        {.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        {.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment, .valueSize = sizeof(CGFloat), .value = (const void*)&spacing},};
    CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 3);
    [self removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)aStyle range:range];
    CFRelease(aStyle);
}

- (void)setlineSpace
{/*
  CTParagraphStyleSetting LineSpacing;
  CGFloat spacing = 4.0;  //指定间距
  LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
  LineSpacing.value = &spacing;
  LineSpacing.valueSize = sizeof(CGFloat);
  
  CTParagraphStyleSetting settings[] = {LineSpacing};
  CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);   //第二个参数为settings的长度
  [self addAttribute:(NSString *)kCTParagraphStyleAttributeName
  value:(id)paragraphStyle
  range:NSMakeRange(0, self.length)];
  */
}

@end
