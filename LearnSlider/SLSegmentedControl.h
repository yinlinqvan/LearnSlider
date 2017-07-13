//
//  SLSegmentedControl.h
//  LearnSlider
//
//  Created by 印林泉 on 2017/7/6.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSegmentedControl : UIControl
//UISegmentedControl *

- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)loadFromXib;

@property(nonatomic,readonly) NSUInteger numberOfSegments;
@property(nonatomic) NSInteger selectedSegmentIndex;
@property(nonatomic) BOOL apportionsSegmentWidthsByContent;

@end
