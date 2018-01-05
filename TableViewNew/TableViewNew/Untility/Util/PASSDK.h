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

/**< 适配长度 */
#define PASFactor(x) [PASCommonUtil getFinalScreenValue:x]

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
#define kNavToolBarHeight        44        // 系统导航栏高度
#define kToolBarHeight            49        // 底部工具栏


#pragma mark -- 版本号相关
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)//相等
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)//小于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)//大于等于
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)//大于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)//小于等于


//IPhone5适配项
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
//IPhone4适配项
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
//IPhone6适配项
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
// IPhone6P适配项
#define IS_IPHONE_6P (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )736) < DBL_EPSILON )
// IPhoneX适配项
#define IS_IPHONE_X (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )812) < DBL_EPSILON )


// IPhoneX 竖屏安全区域顶部空白
#define kPORTRAIT_SAFE_AREA_TOP_SPACE 44
// IPhoneX 竖屏安全区域底部空白
#define kPORTRAIT_SAFE_AREA_BOTTOM_SPACE 34
// IPhoneX 横屏安全区域左部空白
#define kLANDSCAPE_SAFE_AREA_LEFT_SPACE 44
// IPhoneX 横屏安全区域右部空白
#define kLANDSCAPE_SAFE_AREA_RIGHT_SPACE 44
// IPhoneX 横屏安全区域底部空白
#define kLANDSCAPE_SAFE_AREA_BOTTOM_SPACE 21



#ifndef dimof
#define dimof(a)    (sizeof(a) / sizeof(a[0]))
#endif

#define _LS(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"LaunchScreen"]


/**< 测试是 */
#ifndef TEST_VERSION

#define FINISH_TEST

#endif

/**< 
 Xcode 创建不同的 TARGET  挺好用
 http://blog.csdn.net/yongyinmg/article/details/23695999
 */

/**<
 #ifdef 和 #ifndef 的区别
 http://blog.csdn.net/st646889325/article/details/53501370
 */


#ifdef DEFAULT_FIRST_OBJECT

#define FIRST_OBJECT_TRUE

#endif




#endif /* PASSDK_h */
