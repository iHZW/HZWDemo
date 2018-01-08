//
//  BookCell.m
//  TableViewNew
//
//  Created by HZW on 15/9/7.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "BookCell.h"
#import "SJAvatarBrowser.h"

@implementation BookCell

- (void)awakeFromNib {
    // Initialization code
}

//重写父类的方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 40)];
        [self.contentView addSubview:_nameLabel];
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 40)];
        [self.contentView addSubview:_ageLabel];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(WMAIN - 60 , 10, 40, 40);
        [_rightBtn setImage:[UIImage imageNamed:@"1.1"] forState:UIControlStateNormal];
//        [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightBtn];
        
        
        
//        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 0, 60, 60)];
//        _imageView.image = [UIImage imageNamed:@"1.11"];
//        
//        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage1)];
//        _imageView.userInteractionEnabled = YES;
//        _imageView.backgroundColor = [UIColor orangeColor];
//        [self.imageView addGestureRecognizer:tap];
//        [self.contentView addSubview:_imageView];
       
        
//        _leftBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//        _leftBtn.frame = CGRectMake(0, 10, 30, 30);
//        _leftBtn.backgroundColor = [UIColor blueColor];
//        [_leftBtn addTarget:self action:@selector(magnifyImage1) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_leftBtn];
    }
    
    return self;
}

- (void) clickRightBtn:(UIButton *)btn
{
    NSLog(@"jinjinjin");
    
}


//- (void)magnifyImage1
//{
//    NSLog(@"局部放大");
//    [SJAvatarBrowser showImage:_imageView];//调用方法
//}

//重写父类的方法;
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0].CGColor); CGContextStrokeRect(context, CGRectMake(15, -1, rect.size.width - 15, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:226/255 green:226/255 blue:226/255 alpha:1.0].CGColor); CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 15, 1));
}



//显示数据
- (void)configModel:(BookModel *)model
{
    _nameLabel.text = model.name;
    _ageLabel.text = model.age;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.editing)//仅仅在编辑状态的时候需要自己处理选中效果
    {
        if (selected){
            //选中时的效果
            
        }
        else {
            //非选中时的效果
        }
    }
}


//
//
// -(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    if (editing)//编辑状态
//    {
//        if (self.editingStyle == (UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete)){ //编辑多选状态
//            if (![self viewWithTag:TagVale])  //编辑多选状态下添加一个自定义的图片来替代原来系统默认的圆圈，注意这个图片在选中与非选中的时候注意切换图片以模拟系统的那种效果
//            {
//                UIImage* img = [UIImage imageNamed:@"dot.png"];
//                UIImageView* editDotView = [[UIImageView alloc] initWithImage:img];
//                editDotView.tag = TagVale;
//                editDotView.frame = CGRectMake(10,15,20,20);
//                [self addSubView:editDotView];
//                [editDotView release],editDotView = nil;
//            }
//        }
//    }
//    else {
//        //非编辑模式下检查是否有dot图片，有的话删除
//        UIView* editDotView = [self viewWithTag:TagValue];
//        if (editDotView)
//        {
//            [editDotView removeFromSuperview];
//        }
//    }
//}


@end
