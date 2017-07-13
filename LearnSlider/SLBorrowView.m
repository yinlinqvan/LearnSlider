//
//  SLBorrowView.m
//  LearnSlider
//
//  Created by 印林泉 on 2017/6/23.
//  Copyright © 2017年 yinlinqvan. All rights reserved.
//

#import "SLBorrowView.h"
#import "SLSegmentedControl.h"

static const CGFloat lineH = 2.0;//线高
static const CGFloat nodeH = 8.0;//结点高
static const CGFloat thumbH = 16.0;//滑块

@implementation SLBorrowView

+ (instancetype)loadFromXib {
    // 封装Xib的加载过程
    return [[NSBundle mainBundle] loadNibNamed:@"SLBorrowView" owner:nil options:nil].firstObject;
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}
//    - (void)setMoneySliderTitleArray:(NSArray *)moneySliderTitleArray {
//    UIColor *titleColor = [UIColor blackColor];
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: titleColor};
//    NSAttributedString *title = [[NSAttributedString alloc] initWithString:_moneySliderTitleArray[i] attributes:attributes];
//    CGSize titleSize = [title.string sizeWithAttributes:attributes];
//    CGFloat titleOffset = 30;
//    CGFloat titleX = (nodeX + nodeRadius) - titleSize.width/2;
//    CGFloat titleY = nodeY + titleOffset;
//    CGRect titleFrame = {titleX, titleY, titleSize};
//    [title.string drawInRect:titleFrame withAttributes:attributes];
//}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    CGRect rect = frame;
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//    self.frame = rect;
//}

- (IBAction)valueButttonAction:(UIButton *)sender {
    _buttonArray = @[_value1Button, _value2Button, _value3Button];
    _valueLabelArray = @[_value1Label, _value2Label, _value3Label];
    //选中的响应事件
    NSInteger i = [_buttonArray indexOfObject:sender];//一样
    if (i == 0) {
        _value1Label.textColor = [UIColor redColor];
        _value2Label.textColor = [UIColor redColor];
        _value2Label.textColor = [UIColor redColor];
    }
    for (NSInteger i = 0; i< _buttonArray.count; i++) {
        UIButton *button = _buttonArray[i];
        if ([button isEqual:sender]) {
            if (button.selected == NO ) {
                button.selected = YES;
            }
            UILabel *label = (UILabel *)_valueLabelArray[i];
            label.textColor = [UIColor redColor];
            _valueLabel.text = label.text;
        }
        else {
            if (button.selected == YES ) {
                button.selected = NO;
            }
            UILabel *label = (UILabel *)_valueLabelArray[i];
            label.textColor = [UIColor blackColor];
        }
    }
}

//xib初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //[self setup];
    }
    return self;
}

//加载完xib
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    
    UIImage *normal1Image = [self drawFirstButtonNormalImage];
    UIImage *normal2Image = [self drawNextButtonNormalImage];
    UIImage *normal3Image = [self drawLastButtonNormalImage];

    UIImage *selected1Image = [self drawFirstButtonSelectedImage];
    UIImage *selected2Image = [self drawNextButtonSelectedImage];
    UIImage *selected3Image = [self drawLastButtonSelectedImage];
    
    [_value1Button setImage:normal1Image forState:UIControlStateNormal];
    [_value2Button setImage:normal2Image forState:UIControlStateNormal];
    [_value3Button setImage:normal3Image forState:UIControlStateNormal];

    [_value1Button setImage:normal1Image forState:UIControlStateHighlighted];
    [_value2Button setImage:normal2Image forState:UIControlStateHighlighted];
    [_value3Button setImage:normal3Image forState:UIControlStateHighlighted];

    [_value1Button setImage:selected1Image forState:UIControlStateSelected];
    [_value2Button setImage:selected2Image forState:UIControlStateSelected];
    [_value3Button setImage:selected3Image forState:UIControlStateSelected];

//    [_segmentedControl setImage:normal1Image forSegmentAtIndex:0];
//    [_segmentedControl setImage:normal2Image forSegmentAtIndex:1];
//    [_segmentedControl setImage:normal3Image forSegmentAtIndex:2];
}

/*
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    
    UIImage *normal1Image = [self drawFirstButtonNormalImage];
    UIImage *normal2Image = [self drawNextButtonNormalImage];
    UIImage *normal3Image = [self drawLastButtonNormalImage];

//    [_segmentedControl setImage:normal1Image forSegmentAtIndex:0];
//    [_segmentedControl setImage:normal2Image forSegmentAtIndex:1];
//    [_segmentedControl setImage:normal3Image forSegmentAtIndex:2];
    
    UIImage *selected1Image = [self drawFirstButtonSelectedImage];
    UIImage *selected2Image = [self drawNextButtonSelectedImage];
    UIImage *selected3Image = [self drawLastButtonSelectedImage];

    switch (sender.selectedSegmentIndex) {
        case 0:
            //[_segmentedControl setImage:selected1Image forSegmentAtIndex:0];
        case 1:
            //[_segmentedControl setImage:selected2Image forSegmentAtIndex:0];
        case 2:
            //[_segmentedControl setImage:selected3Image forSegmentAtIndex:0];
            break;
            
        default:
            break;
    }
}
*/

- (UIImage *)drawFirstButtonNormalImage {
    //画布大小
    CGSize size = _value1Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 216/255.0, 216/255.0, 216/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, size.width/2.0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);
    
    //绘制主滑块
    
    //小圆
    CGSize smallCircleSize =  (CGSize){nodeH, nodeH};
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGFloat smallCircleX = smallCircleCenterX- smallCircleSize.width/2.0;
    CGFloat smallCircleY = smallCircleCenterY - smallCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){smallCircleX, smallCircleY, smallCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0] set];
    CGContextFillPath(context);
    
    //获取新滑块
    UIImage *newThumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}

- (UIImage *)drawFirstButtonSelectedImage {
    //画布
    //画布大小
    CGSize size = _value1Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, size.width/2.0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);
    
    //绘制主滑块
    //大圆
    CGSize bigCircleSize = (CGSize){thumbH, thumbH};
    CGFloat bigCircleCenterX = size.width/2.0;//和小圆是同心圆
    CGFloat bigCircleCenterY = size.height/2.0;
    CGFloat bigCircleX = bigCircleCenterX- bigCircleSize.width/2.0;
    CGFloat bigCircleY = bigCircleCenterY - bigCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){bigCircleX, bigCircleY, bigCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor redColor] set];
    CGContextFillPath(context);
    //小圆，白边框
    CGSize smallCircleSize = (CGSize){thumbH - lineH*3, thumbH - lineH*3};//与结点圆大小一样
    CGFloat smallCircleRadius = smallCircleSize.width/2.0;
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1);//红边
    CGContextSetLineWidth(context, lineH);//线宽
    [[UIColor whiteColor] set];//白底
    CGContextFillPath(context);
    CGContextAddArc(context, smallCircleCenterX, smallCircleCenterY, smallCircleRadius, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke);
    //获取新滑块
    UIImage *newThumbImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}

- (UIImage *)drawNextButtonNormalImage {
    //画布大小
    CGSize size = _value2Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 216/255.0, 216/255.0, 216/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);

    //绘制主滑块
    
    //小圆，白边框
    CGSize smallCircleSize =  (CGSize){nodeH, nodeH};
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGFloat smallCircleX = smallCircleCenterX- smallCircleSize.width/2.0;
    CGFloat smallCircleY = smallCircleCenterY - smallCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){smallCircleX, smallCircleY, smallCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0] set];
    CGContextFillPath(context);

    //获取新滑块
    UIImage *newThumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}

- (UIImage *)drawNextButtonSelectedImage {
    //画布
    //画布大小
    CGSize size = _value2Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);
    
    //绘制主滑块
    //大圆
    CGSize bigCircleSize = (CGSize){thumbH, thumbH};
    CGFloat bigCircleCenterX = size.width/2.0;//和小圆是同心圆
    CGFloat bigCircleCenterY = size.height/2.0;
    CGFloat bigCircleX = bigCircleCenterX- bigCircleSize.width/2.0;
    CGFloat bigCircleY = bigCircleCenterY - bigCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){bigCircleX, bigCircleY, bigCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor redColor] set];
    CGContextFillPath(context);
    //小圆，白边框
    CGSize smallCircleSize = (CGSize){thumbH - lineH*3, thumbH - lineH*3};//与结点圆大小一样
    CGFloat smallCircleRadius = smallCircleSize.width/2.0;
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1);//红边
    CGContextSetLineWidth(context, lineH);//线宽
    [[UIColor whiteColor] set];//白底
    CGContextFillPath(context);
    CGContextAddArc(context, smallCircleCenterX, smallCircleCenterY, smallCircleRadius, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke);
    //获取新滑块
    UIImage *newThumbImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newThumbImage;
}

- (UIImage *)drawLastButtonNormalImage {
    //画布大小
    CGSize size = _value2Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 216/255.0, 216/255.0, 216/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width/2.0, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);
    //绘制主滑块
    //小圆
    CGSize smallCircleSize =  (CGSize){nodeH, nodeH};
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGFloat smallCircleX = smallCircleCenterX- smallCircleSize.width/2.0;
    CGFloat smallCircleY = smallCircleCenterY - smallCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){smallCircleX, smallCircleY, smallCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0] set];
    CGContextFillPath(context);
    //获取新滑块
    UIImage *newThumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}

- (UIImage *)drawLastButtonSelectedImage {
    //画布
    //画布大小
    CGSize size = _value2Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineH);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1.0); //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, (size.height- lineSize.height)/2.0);//起点坐标
    CGContextAddLineToPoint(context, size.width/2.0, (size.height- lineSize.height)/2.0);//终点坐标
    CGContextStrokePath(context);
    //绘制主滑块
    //大圆
    CGSize bigCircleSize = (CGSize){thumbH, thumbH};
    CGFloat bigCircleCenterX = size.width/2.0;//和小圆是同心圆
    CGFloat bigCircleCenterY = size.height/2.0;
    CGFloat bigCircleX = bigCircleCenterX- bigCircleSize.width/2.0;
    CGFloat bigCircleY = bigCircleCenterY - bigCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){bigCircleX, bigCircleY, bigCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor redColor] set];
    CGContextFillPath(context);
    //小圆，白边框
    CGSize smallCircleSize = (CGSize){thumbH - lineH*3, thumbH - lineH*3};//与结点圆大小一样
    CGFloat smallCircleRadius = smallCircleSize.width/2.0;
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1);//红边
    CGContextSetLineWidth(context, lineH);//线宽
    [[UIColor whiteColor] set];//白底
    CGContextFillPath(context);
    CGContextAddArc(context, smallCircleCenterX, smallCircleCenterY, smallCircleRadius, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke);
    //获取新滑块
    UIImage *newThumbImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbImage;
}

//xib加载完毕
- (void)drawImage {
//- (void)awakeFromNib {
    [super awakeFromNib];
    //第一个button默认、选中图片
    //第二个button默认、选中图片
    //第三个button默认、选中图片
    
    //画布大小
    CGSize size = _value2Button.bounds.size;//其实只关注宽度w
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制线
    CGSize lineSize = (CGSize){size.width, lineH};
    UIImage *line = [[UIImage imageNamed:@"slider_thumb_line"] resizableImageWithCapInsets: UIEdgeInsetsMake(5, 5, 5, 5)];
    CGRect lineFrame = (CGRect){0, (size.height- lineSize.height)/2.0, lineSize};
    [line drawInRect:lineFrame];
    
    //绘制主滑块
    //大圆
    CGSize bigCircleSize = (CGSize){thumbH, thumbH};
    CGFloat bigCircleCenterX = size.width/2.0;//和小圆是同心圆
    CGFloat bigCircleCenterY = size.height/2.0;
    CGFloat bigCircleX = bigCircleCenterX- bigCircleSize.width/2.0;
    CGFloat bigCircleY = bigCircleCenterY - bigCircleSize.height/2.0;
    CGRect bigCircleFrame = (CGRect){bigCircleX, bigCircleY, bigCircleSize};//thumbFrame
    CGContextAddEllipseInRect(context, bigCircleFrame);
    [[UIColor redColor] set];
    CGContextFillPath(context);
    //小圆，白边框
    CGSize smallCircleSize = (CGSize){thumbH - lineH*3, thumbH - lineH*3};//与结点圆大小一样
    CGFloat smallCircleRadius = smallCircleSize.width/2.0;
    CGFloat smallCircleCenterX = size.width/2.0;
    CGFloat smallCircleCenterY = size.height/2.0;
    CGContextSetRGBStrokeColor(context, 255/255.0, 0/255.0, 0/255.0, 1);//红边
    CGContextSetLineWidth(context, lineH);//线宽
    [[UIColor whiteColor] set];//白底
    CGContextFillPath(context);
    CGContextAddArc(context, smallCircleCenterX, smallCircleCenterY, smallCircleRadius, 0, 2*M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke);
    //获取新滑块
    UIImage *newThumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    [_value2Button setImage:newThumbImage forState:UIControlStateNormal];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
