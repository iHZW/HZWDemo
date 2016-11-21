//
//  ThirdCell.m
//  TableViewNew
//
//  Created by HZW on 15/11/24.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "ThirdCell.h"

@implementation ThirdCell

- (void)awakeFromNib {
    // Initialization code
}

//重写父类的方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 80, 20)];
        [self.contentView addSubview:_nameLabel];
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 40, 20)];
        [self.contentView addSubview:_ageLabel];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(290, 0, 80, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.contentView addSubview:_textField];
        
        _leftBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(20, 10, 20, 20);
        [self.contentView addSubview:_leftBtn];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor grayColor];

//        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_contentLabel];
//
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSelect"]) {
//            _leftBtn.backgroundColor = [UIColor blueColor];
//        }
    }
    
    return self;
}



//显示数据
- (void)configModel:(BookModel *)model
{
    _nameLabel.text = model.name;
    _ageLabel.text = model.age;
    _textField.text = model.name;
    _contentLabel.text = model.content;
    _contentLabel.numberOfLines = 0;

    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat contentSize = [model.content boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    _contentLabel.frame = CGRectMake(100, 25, 100, contentSize);
    _contentLabel.adjustsFontSizeToFitWidth = YES;
//    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 220, 25, 50, 30)];
    view.backgroundColor = [UIColor grayColor];
    view.clipsToBounds = YES;
    [self.contentView addSubview:view];
    _marLabel = [[UILabel alloc]initWithFrame:CGRectMake( 320, 0, 100, 30)];
    _marLabel.text = @"人生若只如初见,何事秋风悲画扇.等闲变却故人心,却道故人心易变.骊山语罢清宵半,雷雨零铃终不怨.何如薄幸锦衣郎,比翼连枝当日愿.";
    [_marLabel sizeToFit];
    [view addSubview:_marLabel];
    
    [UIView setAnimationRepeatCount:2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:Nil];
    [UIView setAnimationRepeatAutoreverses:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:20 animations:^{
        CGRect frame = _marLabel.frame;
        frame.origin.x = -frame.size.width;
        _marLabel.frame = frame;
    }];
    [UIView commitAnimations];
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.byValue = @120;
    anim.duration = 1;
    anim.fillMode = kCAFillModeForwards;
    anim.repeatCount = MAXFLOAT;
    
    anim.removedOnCompletion = NO;
    [_marLabel.layer addAnimation:anim forKey:nil];
    
}

+ (CGFloat)configModel:(BookModel *)model
{
    CGFloat height = 25;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat contentSize = [model.content boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    height += contentSize;
    return height+10;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
//    if (self.editing)//仅仅在编辑状态的时候需要自己处理选中效果
//    {
//        if (selected){
//            //选中时的效果
//            _leftBtn.hidden = NO;
//        }
//        else {
//            //非选中时的效果
//            _leftBtn.hidden = YES;
//        }
//    }
}

- (void)setSelected
{
    _leftBtn.backgroundColor = [UIColor yellowColor];
}
@end
