//
//  BDNomalAlertView.m
//  QiXiuBaoDian
//
//  Created by goviewtech on 2018/7/5.
//  Copyright © 2018年 mayouming. All rights reserved.
//

#import "BDNomalAlertView.h"

#define ALERT_LEFT_MARGIN 12
#define TEXT_LEFT_MARGIN (12-8)
#define ACTION_TOP_MARGIN 5
#define MESSAGE_MIN_HEIGHT 50

#define BD_TOP_MARGIN 10
#define MAIN_BULE_COLOR [UIColor colorWithRed:1.0/255.0 green:146.0/255.0 blue:248.0/255.0 alpha:1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface BDUnHightedBtn : UIButton

@end

@implementation BDUnHightedBtn

-(void)setHighlighted:(BOOL)highlighted
{
    
}

@end

@implementation BDNomalAlertActionStyle

+ (instancetype)cancelNomalStyle
{
    BDNomalAlertActionStyle *sytle = [[BDNomalAlertActionStyle alloc]init];
    sytle.titleColor = [UIColor whiteColor];
    sytle.bgColor = [UIColor lightGrayColor];
    return sytle;
    
}
+ (instancetype)sureNomalStyle
{
    BDNomalAlertActionStyle *sytle = [[BDNomalAlertActionStyle alloc]init];
    sytle.titleColor = [UIColor whiteColor];
    sytle.bgColor = MAIN_BULE_COLOR;
    
    return sytle;
}

@end

@interface BDNomalAlertAction ()

@property (nonatomic,copy)void (^actionHandler)(BDNomalAlertAction*action);

@end

@implementation BDNomalAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(BDNomalAlertActionStyle*)style handler:(void (^)(BDNomalAlertAction *action))handler
{
    return [[BDNomalAlertAction alloc]initWithTitle:title style:style handler:handler];
}

-(instancetype)initWithTitle:(NSString*)title style:(BDNomalAlertActionStyle*)style handler:(void (^)(BDNomalAlertAction *action))handler
{
    self = [super init];
    if(self){
        _title = title;
        _style = style;
        _actionHandler = handler;
    }
    return self;
}

@end




@interface BDNomalAlertView ()

@property (nonatomic,weak)UIView *contentView;
@property (nonatomic,weak)UIView *actionView;
@property (nonatomic,weak)UIButton *coverBtn;

@property (nonatomic,strong)NSMutableArray *actionArray;

//0.6 整体展示view的高度，最大高度为屏幕高度的0.6
@property (nonatomic,assign)CGFloat totalContentHeightScale;



@end

@implementation BDNomalAlertView

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    return [[BDNomalAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds title:title message:message];
}


-(NSMutableArray *)actionArray
{
    if(!_actionArray){
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}


-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title message:(NSString *)message
{
    self = [super initWithFrame:frame];
    if(self){
        _actionBtnMargin = 10;
        _actionBtnLeftInset = 10;
        _actionBtnMaxWidth = 120;
        _totalContentHeightScale = 0.7;
        CGFloat maxTotalHeight = SCREEN_HEIGHT*_totalContentHeightScale;
        
        NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc]initWithString:message];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;                                                          // 设置行之间的间距
        [attMessage addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attMessage.length)];
        [attMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attMessage.length)];
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        coverBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.coverBtn = coverBtn;
        coverBtn.userInteractionEnabled = NO;
        coverBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:coverBtn];
        [coverBtn addTarget:self action:@selector(dismissAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat contentWidth = 250;
        if(SCREEN_WIDTH == 375){
            contentWidth = 280;
        }else if (SCREEN_WIDTH > 375){
            contentWidth = 320;
        }
        
        CGFloat contentActionHeight = 55+ACTION_TOP_MARGIN;
        CGFloat contentTitleHeight = 0;
        CGFloat contentMessageHeight = 0;
        if(title.length > 0){
            contentTitleHeight = [title boundingRectWithSize:CGSizeMake(contentWidth-2*ALERT_LEFT_MARGIN, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size.height+2+2*12;
            if(contentTitleHeight >100)contentTitleHeight = 100;
        }
        
        if(attMessage.length >0){
            contentMessageHeight = [attMessage boundingRectWithSize:CGSizeMake(contentWidth-2*TEXT_LEFT_MARGIN-2*8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height+2*8;//textview的文字高度计算不能按照label一样计算
            if(contentMessageHeight < MESSAGE_MIN_HEIGHT){
                contentMessageHeight = MESSAGE_MIN_HEIGHT;
            }
        }
        //为了美观，当内容超过一定高度的时候，则内容可以滑动
        BOOL canScroll = NO;
        CGFloat contentHeight = contentActionHeight+contentTitleHeight+contentMessageHeight;
        if(contentHeight > maxTotalHeight){
            canScroll = YES;
            contentHeight = maxTotalHeight;
            contentMessageHeight = contentHeight-contentActionHeight-contentTitleHeight;
        }
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-contentWidth)*0.5, (frame.size.height-contentHeight)*0.5, contentWidth, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        [contentView.layer setCornerRadius:5];
        [contentView.layer setMasksToBounds:YES];

        CGRect titleViewFrame = CGRectZero;
        CGRect messageViewFrame = CGRectZero;
        CGRect actionViewFrame = CGRectZero;
        //添加标题
        if(contentTitleHeight != 0){
            titleViewFrame = CGRectMake(0, 0, contentWidth, contentTitleHeight);
            actionViewFrame = CGRectMake(0, CGRectGetMaxY(titleViewFrame), contentWidth, contentActionHeight);
            UIView *titleView = [[UIView alloc]initWithFrame:titleViewFrame];
            [contentView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ALERT_LEFT_MARGIN, 12, titleView.frame.size.width-2*ALERT_LEFT_MARGIN, titleView.frame.size.height-2*12)];
            titleLabel.textColor = [UIColor colorWithRed:1.0*51/255 green:1.0*51/255 blue:1.0*51/255 alpha:1.0];
            titleLabel.font = [UIFont boldSystemFontOfSize:15];
            titleLabel.text = title;
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleView addSubview:titleLabel];
            
            UIView *titleLine = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height-0.8, titleView.frame.size.width, 0.8)];
            titleLine.backgroundColor = [UIColor colorWithRed:1.0*225/255 green:1.0*225/255 blue:1.0*225/255 alpha:1.0];
            [titleView addSubview:titleLine];
        }
        //添加内容
        if(contentMessageHeight != 0){
            messageViewFrame = CGRectMake(0, CGRectGetMaxY(titleViewFrame), contentWidth, contentMessageHeight);
            actionViewFrame = CGRectMake(0, CGRectGetMaxY(messageViewFrame), contentWidth, contentActionHeight);
            UIView *messageView = [[UIView alloc]initWithFrame:messageViewFrame];
            [contentView addSubview:messageView];
            
            UITextView *messageLabel = [[UITextView alloc]initWithFrame:CGRectMake(TEXT_LEFT_MARGIN, 0, messageView.frame.size.width-2*TEXT_LEFT_MARGIN, messageView.frame.size.height)];
            messageLabel.editable = NO;
            messageLabel.selectable = NO;
            messageLabel.scrollEnabled = canScroll;
            messageLabel.textColor = [UIColor colorWithRed:1.0*102/255 green:1.0*102/255 blue:1.0*102/255 alpha:1.0];;
            messageLabel.attributedText = attMessage;
            messageLabel.font = [UIFont systemFontOfSize:14];
            [messageView addSubview:messageLabel];
        }
        UIView *actionView = [[UIView alloc]initWithFrame:actionViewFrame];
        self.actionView = actionView;
        [contentView addSubview:actionView];
        
    }
    return self;
}


- (void)addAction:(BDNomalAlertAction *)action
{
    if(self.actionArray.count >=5)return;
    [self.actionArray addObject:action];
    NSInteger actionIndex = self.actionView.subviews.count;
    BDUnHightedBtn *button = [[BDUnHightedBtn alloc]init];
    button.tag = actionIndex;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    BDNomalAlertActionStyle *style = action.style;
    [button setTitle:action.title forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont systemFontOfSize:15];
    UIColor *btnColor = [UIColor colorWithRed:1.0*51/255 green:1.0*51/255 blue:1.0*51/255 alpha:1.0];
    if(style.titleFont){
        btnFont = style.titleFont;
    }
    if(style.titleColor){
        btnColor = style.titleColor;
    }
    
    button.titleLabel.font = btnFont;
    [button setTitleColor:btnColor forState:UIControlStateNormal];
    if(style.bgColor){
        [button setBackgroundColor:style.bgColor];
    }
    [button.layer setCornerRadius:3];
    [button.layer setMasksToBounds:YES];
    [self.actionView addSubview:button];
    [button addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickActionButton:(BDUnHightedBtn*)button
{
    BDNomalAlertAction *action = self.actionArray[button.tag];
    __weak typeof(action)weakAction = action;
    if(action.actionHandler){
        action.actionHandler(weakAction);
    }
    [self dismissAnimation];
}

- (void)showAlertViewFromView:(UIView*)fromView
{
    //设置actionview中的button的frame
    NSInteger count = self.actionView.subviews.count;
    CGFloat leftInset = _actionBtnLeftInset;
    
    CGFloat actionBtnWidth = (self.actionView.frame.size.width - ((count-1)*_actionBtnMargin)-(2*leftInset))/count;
    if(count == 1){
        if(actionBtnWidth >_actionBtnMaxWidth){
            actionBtnWidth = _actionBtnMaxWidth;
            //那么需要调整初始x
            leftInset = (self.actionView.frame.size.width - (actionBtnWidth*count+ (count-1)*_actionBtnMargin))*0.5;
        }
    }
    CGFloat actionBtnHeight = self.actionView.frame.size.height-15-ACTION_TOP_MARGIN;
    for (int i = 0; i<self.actionView.subviews.count; i++) {
        CGFloat actionBtnX = leftInset+(actionBtnWidth+_actionBtnMargin)*i;
        BDUnHightedBtn *button = self.actionView.subviews[i];
        button.frame = CGRectMake(actionBtnX, ACTION_TOP_MARGIN, actionBtnWidth, actionBtnHeight);
    }
    [self animationAlert:self.contentView];
    if(fromView){
        UIView *appShowView = [fromView viewWithTag:110];
        if(appShowView){
            [fromView insertSubview:self belowSubview:appShowView];
        }else{
            [fromView addSubview:self];
        }
    }else{
        UIView *appShowView = [[UIApplication sharedApplication].keyWindow viewWithTag:110];
        if(appShowView){
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:appShowView];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
}

- (void)showAlertView
{
    [self showAlertViewFromView:nil];
}


- (void)animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.05f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.2f, @0.4f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)dismissAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.4];
    scaleAnimation.duration = 0.3f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.contentView.layer addAnimation:scaleAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)hideAlertView
{
    [self dismissAnimation];
}

-(void)setTouchOtherSideToDismiss:(BOOL)touchOtherSideToDismiss
{
    _touchOtherSideToDismiss = touchOtherSideToDismiss;
    self.coverBtn.userInteractionEnabled = touchOtherSideToDismiss;
    
}

- (void)dealloc
{
    NSLog(@"BDAlertView销毁了");
}


@end
