//
//  DDPopup.h
//  DDPopup
//
//  Created by deepindo on 2019/10/31.
//

#import <UIKit/UIKit.h>

extern CGFloat const KDDPopupDefaultWaitDuration;

@interface DDPopup : UILabel

// 颜色
@property (nonatomic, strong)UIColor *popupColor UI_APPEARANCE_SELECTOR;

// 动画时间
@property (nonatomic, assign)CGFloat forwardAnimationDuration;
@property (nonatomic, assign)CGFloat backwardAnimationDuration;

// 文本框相关
@property (nonatomic, assign)UIEdgeInsets textInsets;
@property (nonatomic, assign)CGFloat maxWidth;

#pragma mark - Initialization
+ (DDPopup *)popupWithText:(NSString *)text;
- (id)initWithText:(NSString *)text;

#pragma mark - Showing Popup
// MARK: 自定义类方法
+ (void) popupCustomText:(NSString *)text;
+ (void) popupCustomText:(NSString *)text customWidth:(CGFloat)width;

- (void)showInView:(UIView *)parentView
     centerAtPoint:(CGPoint)pos
          duration:(CGFloat)waitDuration
        completion:(void (^)(void))block;

@end

