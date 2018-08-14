//
//  TestBasicsViewController.h
//  TableViewNew
//
//  Created by HZW on 2018/8/7.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , CYLUserGender) {
    
    CYLUserGenderUnkonw,
    
    CYLUserGenderMale,
    
    CYLUserGenderFemale,
    
    CYLUserGenderNeuter
};




@interface TestBasicsViewController : UIViewController

@end



@interface CYLUser : NSObject<NSCopying>

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSUInteger age;
@property (nonatomic, readonly, assign) CYLUserGender gender;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(CYLUserGender)gender;
+ (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(CYLUserGender)gender;

@end
