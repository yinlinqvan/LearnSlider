//
//  SLSlider.m
//  LearnSlider
//
//  Created by 印林泉 on 2017/7/7.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import "SLSlider.h"

#define SLNormalColor [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define SLSelectedColor [UIColor colorWithRed:230.0/255.0 green:0.0/255.0 blue:18.0/255.0 alpha:1.0]
#define SLRingFillColor [UIColor whiteColor]
#define SLLineH 2.0
#define SLCircleRadius 8.0
#define SLRingRadius (SLLineH*1.5+SLCircleRadius)

static CGFloat oldValue = 0.5;//初始值
//static const CGFloat lineH = 2.0;//线高
//static const CGFloat nodeH = 16.0;//结点高
//static const CGFloat thumbH = 24.0;//滑块

@interface SLSlider()
//UISegmentedControl *
@property(nonatomic,readonly) NSArray *items;
@property(nonatomic, assign) NSUInteger numberOfSegments;

@property(nonatomic,readonly) NSArray *buttonItems;
@property (strong, nonatomic) NSArray *nodeFrameArray;
@end

@implementation SLSlider

+ (instancetype)loadFromXib {
    // 封装Xib的加载过程
    return [[NSBundle mainBundle] loadNibNamed:@"SLSlider" owner:nil options:nil].firstObject;
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

//加载完xib
- (void)awakeFromNib {
    [super awakeFromNib];
    self.items = @[@"300元", @"500元", @"1000元", @"3000元"];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    _numberOfSegments = items.count;
    //绘制线
    UIImage *lineImage = [self lineImageWithContextW:self.bounds.size.width contextH:self.bounds.size.height];
    //[lineImage drawInRect:lineFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [imageView setImage:lineImage];
    [imageView setUserInteractionEnabled:NO];
    [self addSubview:imageView];
    //滑块
    CGFloat contextW = self.bounds.size.width/_numberOfSegments;
    CGFloat contextH = self.bounds.size.height;
    
    UIImage *thumbImage = [self thumbImageWithContextW:contextW contextH:contextH];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];

}

#pragma mark
#pragma mark --- slider gesture action ---

- (void)tapAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    UITouch *touch = [[UITouch alloc] init];
    [touch setAccessibilityActivationPoint:point];
    [self endTrackingWithTouch:touch withEvent:nil];
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint touchPoint;
    if (touch.view) {
        //NSLog(@"===%@", touch.view);//_moneySlider
        touchPoint = [touch locationInView:[touch view]];//返回触摸点在视图中的当前坐标
    }
    else {
        //NSLog(@"===(%.0lf, %.0lf)", touch.accessibilityActivationPoint.x, touch.accessibilityActivationPoint.y);//_moneySlider
        touchPoint = touch.accessibilityActivationPoint;
    }
    //结点位置
    CGFloat touchRate = 3.0;//触摸范围
    for (NSInteger i = 0; i < _nodeFrameArray.count; i++) {
        NSValue *nodeFrameValue = _nodeFrameArray[i];
        CGRect nodeFrame = nodeFrameValue.CGRectValue;
        CGFloat nodeCenterX = nodeFrame.origin.x + nodeFrame.size.width/2.0;;
        CGFloat nodeCenterY = nodeFrame.origin.y + nodeFrame.size.height/2.0;;
        
        CGFloat w = nodeFrame.size.width * touchRate < self.bounds.size.width/_numberOfSegments? nodeFrame.size.width * touchRate: self.bounds.size.width/_numberOfSegments;//宽不能超过整个滑块的宽度，否则会有重叠
        CGFloat h = nodeFrame.size.height * touchRate > 44.0? nodeFrame.size.height * touchRate: 44.0;//高至少44
        CGFloat x = nodeCenterX - w/2.0;
        CGFloat y = nodeCenterY - h/2.0;
        
        CGRect newNodeFrame = (CGRect){x, y, w, h};
        
        if (CGRectContainsPoint(newNodeFrame, touchPoint)) {
            //NSLog(@"x: %.0lf(%.0lf)", x, touchPoint.x);
            //NSLog(@"(%.0lf, %.0lf, %.0lf, %.0lf), (%.0lf, %.0lf)", x, y, w, h, touchPoint.x, touchPoint.y);
            self.value = 1.0/(_numberOfSegments-1) * i;
            NSLog(@"%.2lf", self.value);
//            if (value > oldValue) {
//                NSLog(@">>>>>");
//                //NSLog(@">>>>>(%.2lf, %.2lf(%.2lf))", oldValue, newValue, value);
//            }
//            else {
//                NSLog(@"<<<<<");
//                //NSLog(@"<<<<<(%.2lf, %.2lf(%.2lf))", oldValue, newValue, value);
//            }
            return;
        }
        else {
            
        }
    }
    //return YES;
}

#pragma mark
#pragma mark --- slider action--
- (IBAction)sliderAction:(UISlider *)sender {
}

- (IBAction)sliderTouchUpInside:(UISlider *)sender {
    //停止滑动
    CGFloat value = sender.value;
    //类似pageEnable的效果
    //确定方向
    CGFloat newValue;
    CGFloat thumbRaidusPercent = 1.0/12.0;
    if (value > oldValue) {
        //1.0/6.0, 3.0/6.0, 5.0/6.0
        //向右滑动
        CGFloat value1 = 4.0/6.0- thumbRaidusPercent;//0.69
        CGFloat value2 = 2.0/6.0- thumbRaidusPercent;//0.31
        
        
        if (value >= value1) {
            //¥1000
            newValue = 5.0/6.0;
        }
        else if(value >= value2) {
            //¥500
            newValue = 3.0/6.0;
        }
        else /*if(value >= value3)*/{
            //¥300
            newValue = 1.0/6.0;
        }
    }
    else {
        //向左滑动
        CGFloat value1 = 2.0/6.0+thumbRaidusPercent;//0.31
        CGFloat value2 = 4.0/6.0+thumbRaidusPercent;//0.69
        if (value <= value1) {
            //¥300
            newValue = 1.0/6.0;
        }
        else if (value > value1 && value<= value2) {
            //¥500
            newValue = 3.0/6.0;
        }
        else/* if (value >= value2) */{
            //¥1000
            newValue = 5.0/6.0;
        }
    }
    
    [self setValue:newValue animated:YES];
    oldValue = newValue;
    
    if (value > oldValue) {
        NSLog(@">>>>>");
        //NSLog(@">>>>>(%.2lf, %.2lf(%.2lf))", oldValue, newValue, value);
    }
    else {
        NSLog(@"<<<<<");
        //NSLog(@"<<<<<(%.2lf, %.2lf(%.2lf))", oldValue, newValue, value);
    }
    
    //    [UIView animateWithDuration:10.0 animations:^{
    //        _moneySlider.value = newValue;
    //    } completion:^(BOOL finished) {
    //        NSLog(@"===%zd", newValue);
    //    }];
}

- (UIImage *)thumbImageWithContextW:(CGFloat)contextW contextH:(CGFloat)contextH {
    UIColor *lineColor;
    CGFloat lineH;
    CGFloat lineW;
    CGPoint lineStartPoint;
    CGPoint lineStopPoint;
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
    
    lineW = contextW;
    lineStartPoint = (CGPoint){0, contextH/2.0};
    lineStopPoint= (CGPoint){ contextW, contextH/2.0};
    lineColor = SLSelectedColor;
    //圆
    circleColor = SLSelectedColor;

    //画布大小
    CGSize size = (CGSize){contextW, contextH};//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);//透明
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

    //大圆
    [ringColor set];
    CGContextSetLineWidth(context, ringW);//线宽
    CGContextAddArc(context, ringCenter.x, ringCenter.y, ringRadius, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke);
    //白底
    CGContextSetFillColorWithColor(context, ringFillColor.CGColor);
    CGContextAddArc(context, ringCenter.x, ringCenter.y, ringRadius-ringW/2.0, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathFill);

    //小圆
    CGRect circleFrame = (CGRect){circleCenter.x-circleRadius, circleCenter.y - circleRadius, circleRadius*2, circleRadius*2};//thumbFrame
    CGContextAddEllipseInRect(context, circleFrame);
    [circleColor set];
    CGContextFillPath(context);
    
    //获取新滑块
    UIImage *thumbImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImage;
}

- (UIImage *)lineImageWithContextW:(CGFloat)contextW contextH:(CGFloat)contextH {
    CGFloat lineH = SLLineH;
    UIColor *lineColor = SLNormalColor;
    CGPoint lineStartPoint = (CGPoint){contextW/(_numberOfSegments*2), contextH/2.0};
    CGPoint lineStopPoint= (CGPoint){ contextW - contextW/(_numberOfSegments*2), contextH/2.0};
    //画布大小
    CGSize size = (CGSize){contextW, contextH};//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);//透明
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
    //画灰色结点
    CGPoint circleCenter;
    UIColor *circleColor;
    CGFloat circleRadius;
    circleRadius = SLCircleRadius;
    circleCenter = (CGPoint){(contextW/_numberOfSegments)/2.0, contextH/2.0};//第一个
    circleColor = SLNormalColor;
    CGFloat circleX = circleCenter.x-circleRadius;
    CGFloat circleY = circleCenter.y - circleRadius;
    
    NSMutableArray *nodeFrameArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < _numberOfSegments; i++) {
        //小圆
        CGRect circleFrame = (CGRect){ circleX, circleY, circleRadius*2, circleRadius*2};//thumbFrame
        [nodeFrameArr addObject:[NSValue valueWithCGRect:circleFrame]];//节点的位置
        CGContextAddEllipseInRect(context, circleFrame);
        [circleColor set];
        CGContextFillPath(context);
        circleX += contextW/_numberOfSegments;//下一个
    }
    _nodeFrameArray = nodeFrameArr;

    //获取新滑块
    UIImage *lineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lineImage;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
