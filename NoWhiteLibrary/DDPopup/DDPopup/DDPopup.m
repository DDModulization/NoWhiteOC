//
//  DDPopup.m
//  DDPopup
//
//  Created by deepindo on 2019/10/31.
//

#import "DDPopup.h"
#import <QuartzCore/QuartzCore.h>

//提示动画框持续时间
CGFloat const KDDPopupDefaultWaitDuration = 1.0f;

static NSString *const KDDAnimationKeyPopup = @"kDDAnimationKeyPopup";

@interface DDPopup()

@property (nonatomic, copy)void(^animationCompletion)(void);

@end

@implementation DDPopup

//
@synthesize popupColor;
@synthesize forwardAnimationDuration;
@synthesize backwardAnimationDuration;
@synthesize textInsets;
@synthesize maxWidth;


#pragma mark - CustomerMethods
+ (DDPopup *)sharedDDPopup {
    static dispatch_once_t onceToken;
    static DDPopup *singleton;
    dispatch_once(&onceToken, ^{
        singleton = [[DDPopup alloc]init];
    });
    return singleton;
}

+ (void)popupCustomText:(NSString *)text {
    DDPopup *popup = [DDPopup sharedDDPopup];
    [popup setText:text];
    [popup sizeToFit];
    popup.alpha = 1.0;
    
    id SharedApp = [[UIApplication sharedApplication] delegate];
    if ([SharedApp respondsToSelector:@selector(window)]) {
        UIWindow *window = [SharedApp window];
        [popup showInView:window
            centerAtPoint:window.center
                 duration:KDDPopupDefaultWaitDuration
               completion:nil];
    }
}

+ (void) popupCustomText:(NSString *)text customWidth:(CGFloat)width {
    DDPopup *popup = [DDPopup sharedDDPopup];
    [popup setText:text];
    
    if (width != 0) {
        popup.maxWidth = width;
    }
    [popup sizeToFit];
    popup.alpha = 1.0;
    
    id SharedApp = [[UIApplication sharedApplication] delegate];
    if ([SharedApp respondsToSelector:@selector(window)]) {
        UIWindow *window = [SharedApp window];
        [popup showInView:window
            centerAtPoint:window.center
                 duration:KDDPopupDefaultWaitDuration
               completion:nil];
    }
}

#pragma mark - Initialization
+ (DDPopup *)popupWithText:(NSString *)text {
    return [[DDPopup alloc]initWithText:text];
}

- (id)initWithText:(NSString *)text {
    self = [self initWithFrame:CGRectZero];
    if(self) {
        self.text = text;
        [self sizeToFit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        //提示框背景色--hardCode
//        popupColor = [UIColor colorWithRed:237/255.0 green:100/255.0 blue:97/255.0 alpha:0.7];
        popupColor = [UIColor redColor];

        forwardAnimationDuration = 0.4f;
        backwardAnimationDuration = 0.4f;
        textInsets = UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f);
        maxWidth = 300.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        
        //提示框上面的字体颜色
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14.0f];
    }
    return self;
}

#pragma mark - Showing popup
- (void)showInView:(UIView *)parentView centerAtPoint:(CGPoint)point duration:(CGFloat)waitDuration completion:(void(^)(void))block {
    
    self.center = point;
    self.animationCompletion = block;
    
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = self.forwardAnimationDuration;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    CABasicAnimation *reverseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    reverseAnimation.duration = self.backwardAnimationDuration;
    reverseAnimation.beginTime = forwardAnimation.duration + waitDuration;
    reverseAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    reverseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    reverseAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:forwardAnimation, reverseAnimation, nil];
    animationGroup.delegate = self;
    animationGroup.duration = forwardAnimation.duration + reverseAnimation.duration + waitDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [parentView addSubview:self];
    [UIView animateWithDuration:animationGroup.duration
                          delay:0.0
                        options:0
                     animations:^{
                         [self.layer addAnimation:animationGroup
                                           forKey:KDDAnimationKeyPopup];
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Core animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self removeFromSuperview];
        
        if (self.animationCompletion)
            self.animationCompletion();
    }
}

#pragma mark - override UILabel
- (void)sizeToFit {
    [super sizeToFit];
    
    CGRect newFrame = self.frame;
    CGFloat w = self.frame.size.width + self.textInsets.left + self.textInsets.right;
    CGFloat h = self.frame.size.height + self.textInsets.top + self.textInsets.bottom;
    newFrame.size = CGSizeMake(w, h);
    self.frame = newFrame;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGFloat w = self.maxWidth - self.textInsets.left - self.textInsets.right;
    bounds.size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)];
    return bounds;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
    // 获取并保存上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 5.0f, 5.0f) cornerRadius:5.0f];
    
    // 填充色
    CGContextSetFillColorWithColor(context, self.popupColor.CGColor);
    CGContextFillPath(context);
    
    // 阴影渐变色
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 3.0f, [UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
    
    // 添加路径并绘制
    CGContextAddPath(context, roundRect.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextRestoreGState(context);
    [super drawRect:rect];
}


@end
