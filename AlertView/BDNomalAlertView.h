//
//  BDNomalAlertView.h
//  QiXiuBaoDian
//
//  Created by goviewtech on 2018/7/5.
//  Copyright © 2018年 mayouming. All rights reserved.
//

#import <UIKit/UIKit.h>

/**样式*/
@interface BDNomalAlertActionStyle : NSObject

/**标题颜色*/
@property (nonatomic,strong)UIColor *titleColor;
/**标题大小*/
@property (nonatomic,strong)UIFont *titleFont;
/**背景色*/
@property (nonatomic,strong)UIColor *bgColor;

/**取消样式*/
+ (instancetype)cancelNomalStyle;
/**确定样式*/
+ (instancetype)sureNomalStyle;

@end

@interface BDNomalAlertAction : NSObject

@property (nonatomic,strong,readonly)BDNomalAlertActionStyle *style;
@property (nonatomic,copy,readonly)NSString *title;

+ (instancetype)actionWithTitle:(NSString *)title style:(BDNomalAlertActionStyle*)style handler:(void (^)(BDNomalAlertAction *action))handler;

@end

/**仿系统的alertView*/
@interface BDNomalAlertView : UIView

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;


/**之间的距离 默认为10*/
@property (nonatomic,assign)CGFloat actionBtnMargin;
/**左右两边的间距 默认为0*/
@property (nonatomic,assign)CGFloat actionBtnLeftInset;
/**展示按钮的最大宽度，主要是为了美观*/
@property (nonatomic,assign,readonly)CGFloat actionBtnMaxWidth;
/**点击旁边触发消失，默认为no*/
@property (nonatomic,assign)BOOL touchOtherSideToDismiss;

/**内部规定最多添加5个，否则影响美观*/
- (void)addAction:(BDNomalAlertAction *)action;

- (void)showAlertView;
- (void)showAlertViewFromView:(UIView*)fromView;

- (void)hideAlertView;

@end
