//
//  ViewController.m
//  LearnSlider
//
//  Created by 印林泉 on 2017/5/26.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import "ViewController.h"
#import "SLBorrowView.h"
#import "SLSegmentedControl.h"
#import "SLSlider.h"

@interface ViewController ()
//---¥300------¥500------¥1000---
@property (strong, nonatomic) NSArray *moneySliderTitleArray;
@property (strong, nonatomic) NSArray *moneySliderNodeFrameArray;
@property (strong, nonatomic) UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet SLBorrowView *slBorrowView;
@property (weak, nonatomic) IBOutlet SLSegmentedControl *slSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *sliderContentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SLBorrowView *view = [SLBorrowView loadFromXib];
    [self.view addSubview:view];
    
    //slider
    SLSlider *slider = [SLSlider loadFromXib];
    [_sliderContentView addSubview:slider];
}


#pragma mark
#pragma mark --- tool ---

- (UIColor *)getColorWithValue:(CGFloat)value {
    NSInteger red = (NSInteger)(255*value);
    NSInteger green = 192;
    NSInteger blue = 86;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (UIColor *)getRandomColor {
    return [UIColor colorWithHue:(arc4random()%256/256.0) saturation:(arc4random()%128/256.0)+0.5 brightness:(arc4random()%128/256.0)+0.5 alpha:0.5];
}

//自定义滑块的大小    通过此方法可以更改滑块的任意大小和形状
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
