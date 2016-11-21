//
//  PASSDK.h
//  PASecuritiesApp
//
//  Created by Howard on 16/2/3.
//  Copyright © 2016年 PAS. All rights reserved.
//

#ifndef PASSDK_h
#define PASSDK_h

//#import "PASBaseFramework.h"
//#import "UIColor+Extensions.h"

/**
 *  强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 *  调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 *  示例：
 *  @pas_weakify_self
 *  [obj block:^{
 *  @pas_strongify_self
 *      self.property = something;
 *  }];
 */
#ifndef	pas_weakify_self
#if __has_feature(objc_arc)
#define pas_weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define pas_weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef	pas_strongify_self
#if __has_feature(objc_arc)
#define pas_strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define pas_strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif

/**
 *  强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 *  调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 *  示例：
 *  @pas_weakify(object)
 *  [obj block:^{
 *      @pas_strongify(object)
 *      strong_object = something;
 *  }];
 */
#ifndef	pas_weakify
#if __has_feature(objc_arc)
#define pas_weakify(object)	autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define pas_weakify(object)	autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef	pas_strongify
#if __has_feature(objc_arc)
#define pas_strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define pas_strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32
typedef unsigned long _uint64;
typedef long long _int64;
#else
typedef unsigned long long _uint64;
typedef long long _int64;
#endif

#define PASRGBColor(r,g,b) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

#define PASRGBAColor(r,g,b,a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]

#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromHexString(hexString) [UIColor colorFromHexString:hexString]
#define UIColorFromHexAlphaString(hexString, a) [UIColor colorFromHexString:hexString alpha:a]
#define UIColorFromHexStr(hexString) [UIColor colorFromHexString:hexString]

#define PASFont(s) [UIFont systemFontOfSize:s]
#define PASBFont(s) [UIFont boldSystemFontOfSize:s]
#define PASFontWithName(name, s) [UIFont fontWithName:name size:s]
#define PASFacFont(s) PASFont(PASFactor(s))   //适配后的字体
#define PASFacBFont(s) PASBFont(PASFactor(s)) //适配后的加粗字体

#define kMainScreenSize     ([[UIScreen mainScreen] bounds].size)
#define kMainScreenWidth    MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define kMainScreenHeight   MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)
#define kCustomKeyBoardHeight 216     // 大智慧自定义键盘高度 

#define kSysStatusBarHeight		MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)		// 系统状态栏高度

#ifndef dimof
#define dimof(a)    (sizeof(a) / sizeof(a[0]))
#endif

#define _LS(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"LaunchScreen"]

#endif /* PASSDK_h */
