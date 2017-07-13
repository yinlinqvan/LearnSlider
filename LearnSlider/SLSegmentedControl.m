//
//  SLSegmentedControl.m
//  LearnSlider
//
//  Created by 印林泉 on 2017/7/6.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import "SLSegmentedControl.h"

typedef NS_ENUM(NSInteger, SLSegmentedControlSegmentStyle) {
    SLSegmentStyleLeft = 0,
    SLSegmentStyleCenter,
    SLSegmentStyleRight,
    
    SLSegmentStyleLeftHighlighted,
    SLSegmentStyleCenterHighlighted,
    SLSegmentStyleRightHighlighted,
};

#define SLNormalColor [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define SLSelectedColor [UIColor colorWithRed:230.0/255.0 green:0.0/255.0 blue:18.0/255.0 alpha:1.0]
#define SLRingFillColor [UIColor whiteColor]
#define SLLineH 2.0
#define SLCircleRadius 8.0
#define SLRingRadius (SLLineH*1.5+SLCircleRadius)

@interface SLSegmentedControl()
//UISegmentedControl *
@property(nonatomic,readonly) NSArray *items;
@property(nonatomic, assign) NSUInteger numberOfSegments;

@property(nonatomic,readonly) NSArray *buttonItems;

@end

@implementation SLSegmentedControl

+ (instancetype)loadFromXib {
    // 封装Xib的加载过程
    return [[NSBundle mainBundle] loadNibNamed:@"SLSegmentedControl" owner:nil options:nil].firstObject;
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

//加载完xib
- (void)awakeFromNib {
    [super awakeFromNib];
    self.items = @[@"300元", @"500元", @"1000元", @"3000元"];
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

- (NSUInteger)numberOfSegments {
    return _items.count;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    _numberOfSegments = items.count;
    
    CGFloat contextW = self.bounds.size.width/_numberOfSegments;
    CGFloat contextH = self.bounds.size.height;
    if (_numberOfSegments == 1) {
        UIImage *centerImage = [self image:SLSegmentStyleCenter contextW:contextW contextH:contextH];
        UIImage *centerHighlightedImage = [self image:SLSegmentStyleCenterHighlighted contextW:contextW contextH:contextH];
        UIButton *item = [[UIButton alloc] initWithFrame:(CGRect){0, 0, contextW, contextH}];
        [item setImage:centerImage forState:UIControlStateNormal];
        [item setImage:centerHighlightedImage forState:UIControlStateSelected];
        [item setImage:centerHighlightedImage forState:UIControlStateHighlighted];
        _buttonItems = @[item];
        
    }
    else if (_numberOfSegments >= 2){
        NSMutableArray *buttonArr;
        {
            //左
            UIImage *leftImage = [self image:SLSegmentStyleLeft contextW:contextW contextH:contextH];
            UIImage *leftHighlightedImage = [self image:SLSegmentStyleLeftHighlighted contextW:contextW contextH:contextH];
            UIButton *item = [[UIButton alloc] initWithFrame:(CGRect){0, 0, contextW, contextH}];
            [item setImage:leftImage forState:UIControlStateNormal];
            [item setImage:leftHighlightedImage forState:UIControlStateSelected];
            [item setImage:leftImage forState:UIControlStateHighlighted];
            buttonArr = [[NSMutableArray alloc] initWithArray:@[item]];
        }
        //中
        for (NSInteger i = 1 ; i <= _numberOfSegments-2; i++) {
            UIImage *centerImage = [self image:SLSegmentStyleCenter contextW:contextW contextH:contextH];
            UIImage *centerHighlightedImage = [self image:SLSegmentStyleCenterHighlighted contextW:contextW contextH:contextH];
            UIButton *item = [[UIButton alloc] initWithFrame:(CGRect){i*contextW, 0, contextW, contextH}];
            [item setImage:centerImage forState:UIControlStateNormal];
            [item setImage:centerHighlightedImage forState:UIControlStateSelected];
            [item setImage:centerImage forState:UIControlStateHighlighted];
            [buttonArr addObject:item];
        }
        //右
        UIImage *rightImage = [self image:SLSegmentStyleRight contextW:contextW contextH:contextH];
        UIImage *rightHighlightedImage = [self image:SLSegmentStyleRightHighlighted contextW:contextW contextH:contextH];
        UIButton *item = [[UIButton alloc] initWithFrame:(CGRect){(_numberOfSegments-1)*contextW, 0, contextW, contextH}];
        [item setImage:rightImage forState:UIControlStateNormal];
        [item setImage:rightHighlightedImage forState:UIControlStateSelected];
        [item setImage:rightImage forState:UIControlStateHighlighted];
        [buttonArr addObject:item];
        //全新的按钮集
        _buttonItems = buttonArr;
    }
    for (UIButton *button in _buttonItems) {
        [button addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //默认选中
    self.selectedSegmentIndex = 1;//0 未选中
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    //不是重复点击
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        if (_selectedSegmentIndex > 0 ) {//0 未选中 从1开始
            //取消上一个选中状态
            UIButton *button = _buttonItems[_selectedSegmentIndex-1];
            [button setSelected:NO];
        }
        //选中
        UIButton *button = _buttonItems[selectedSegmentIndex-1];
        [button setSelected:YES];
        //执行
        _selectedSegmentIndex = selectedSegmentIndex;
    }
    //如果重复点击，不操作
}

//清除选项
- (void)clearSelectedButton {
    for (int i = 0; i< _buttonItems.count; i++) {
        UIButton *button = _buttonItems[i];
        if (button.selected == YES ) {
            button.selected = NO;
        }
    }
}

- (void)valueChanged:(UIButton *)sender {
    NSInteger segmentIndex = [_buttonItems indexOfObject:sender];
    [self setSelectedSegmentIndex:segmentIndex+1];
}


- (UIImage *)image:(SLSegmentedControlSegmentStyle)segmentStyle contextW:(CGFloat)contextW contextH:(CGFloat)contextH {
    UIColor *lineColor;
    CGFloat lineH;
    CGFloat lineW;
    CGPoint lineStartPoint;
    CGPoint lineStopPoint;
    BOOL hasRing;
    CGPoint ringCenter;
    CGFloat ringRadius;
    CGFloat ringW;
    UIColor *ringColor;
    UIColor *ringFillColor;
    CGFloat circleRadius;
    CGPoint circleCenter;
    UIColor *circleColor;
    
    lineH = SLLineH;
    circleRadius = SLCircleRadius;
    circleCenter = (CGPoint){ contextW/2.0, contextH/2.0};//同心圆
    //环只有在选中时有
    ringCenter = (CGPoint){ contextW/2.0, contextH/2.0};
    ringRadius = SLRingRadius;
    ringW = SLLineH;
    ringColor = SLSelectedColor;
    ringFillColor = SLRingFillColor;
    
    //线
    if (segmentStyle == SLSegmentStyleLeft || segmentStyle == SLSegmentStyleLeftHighlighted) {
        lineW = contextW/2.0;
        lineStartPoint = (CGPoint){ contextW/2.0, contextH/2.0};
        lineStopPoint= (CGPoint){ contextW, contextH/2.0};
    }
    else if (segmentStyle == SLSegmentStyleRight || segmentStyle == SLSegmentStyleRightHighlighted) {
        lineW = contextW/2.0;
        lineStartPoint = (CGPoint){0, contextH/2.0};
        lineStopPoint= (CGPoint){ contextW/2.0, contextH/2.0};
    }
    else /*if (segmentStyle == SLSegmentStyleCenter || segmentStyle == SLSegmentStyleCenterHighlighted)*/ {
        lineW = contextW;
        lineStartPoint = (CGPoint){0, contextH/2.0};
        lineStopPoint= (CGPoint){ contextW, contextH/2.0};
    }
    
    //颜色
    if (segmentStyle == SLSegmentStyleLeft || segmentStyle == SLSegmentStyleRight || segmentStyle == SLSegmentStyleCenter) {
        //线
        lineColor = SLNormalColor;
        //圆
        circleColor = SLNormalColor;
        //环
        hasRing = NO;
    }
    else /*if (segmentStyle == SLSegmentStyleLeftHighlighted || segmentStyle == SLSegmentStyleRightHighlighted || segmentStyle == SLSegmentStyleCenterHighlighted)*/ {
        //线
        lineColor = SLSelectedColor;
        //圆
        circleColor = SLSelectedColor;
        //环
        hasRing = YES;
    }
    return [self imageWithContextW:contextW contextH:contextH lineColor:lineColor lineH:lineH lineW:lineW lineStartPoint:lineStartPoint lineStopPoint:lineStopPoint hasRing:hasRing ringCenter:ringCenter ringRadius:ringRadius ringW:ringW ringColor:ringColor ringFillColor:ringFillColor circleRadius:circleRadius circleCenter:circleCenter circleColor:circleColor];
}

//Red: components[0]);
//Green: components[1]);
//Blue: components[2]);
- (CGFloat)colorR:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[0];
}

- (CGFloat)colorG:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[1];
}

- (CGFloat)colorB:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[2];
}

- (CGFloat)colorA:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[3];
}

//居中
- (UIImage *)imageWithContextW:(CGFloat)contextW
                   contextH:(CGFloat)contextH
                  lineColor: (UIColor *)lineColor
                      lineH:(CGFloat)lineH
                      lineW:(CGFloat)lineW
             lineStartPoint:(CGPoint)lineStartPoint
              lineStopPoint:(CGPoint)lineStopPoint
                    hasRing:(BOOL)hasRing
                      ringCenter:(CGPoint)ringCenter
                 ringRadius:(CGFloat)ringRadius
                      ringW:(CGFloat)ringW
                  ringColor: (UIColor *)ringColor
                  ringFillColor: (UIColor *)ringFillColor
               circleRadius:(CGFloat)circleRadius
               circleCenter:(CGPoint)circleCenter
               circleColor:(UIColor *)circleColor
{
    
    //画布大小
    CGSize size = (CGSize){contextW, contextH};//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);//透明
    //UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);//不透明
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制线
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);//线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, [self colorR:lineColor], [self colorG:lineColor], [self colorB:lineColor], [self colorA:lineColor]); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);//起点坐标
    CGContextAddLineToPoint(context, lineStopPoint.x, lineStopPoint.y);//终点坐标
    CGContextStrokePath(context);
    //绘制主滑块
    if (hasRing) {
        //大圆
        [ringColor set];
        CGContextSetLineWidth(context, ringW);//线宽
        CGContextAddArc(context, ringCenter.x, ringCenter.y, ringRadius, 0, 2*M_PI, 0);//画圆
        CGContextDrawPath(context, kCGPathStroke);
        //白底
        CGContextSetFillColorWithColor(context, ringFillColor.CGColor);
        CGContextAddArc(context, ringCenter.x, ringCenter.y, ringRadius-ringW/2.0, 0, 2*M_PI, 0);//画圆
        CGContextDrawPath(context, kCGPathFill);
    }
    //小圆
    CGRect circleFrame = (CGRect){circleCenter.x-circleRadius, circleCenter.y - circleRadius, circleRadius*2, circleRadius*2};//thumbFrame
    CGContextAddEllipseInRect(context, circleFrame);
    [circleColor set];
    CGContextFillPath(context);
    //获取新滑块
    UIImage *newThumbImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
