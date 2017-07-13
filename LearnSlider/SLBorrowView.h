//
//  SLBorrowView.h
//  LearnSlider
//
//  Created by 印林泉 on 2017/6/23.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLBorrowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *value1UnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *value2UnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *value3UnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;

@property (weak, nonatomic) IBOutlet UIButton *value1Button;
@property (weak, nonatomic) IBOutlet UIButton *value2Button;
@property (weak, nonatomic) IBOutlet UIButton *value3Button;

@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) NSArray *valueLabelArray;

+ (instancetype)loadFromXib;

- (void)setup;

- (UIImage *)drawNextButtonNormalImage;
- (UIImage *)drawNextButtonSelectedImage;

@end
