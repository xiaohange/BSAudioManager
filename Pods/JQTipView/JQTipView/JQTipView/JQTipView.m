//
//  JQTipView.m
//  JQTipViewDemo
//
//  Created by Hari on 15-9-27.
//  Copyright (c) 2018 年 Hari. All rights reserved.
//

#import "JQTipView.h"
#import <UIKit/UIKit.h>
#import "HIToolsHeader.h"

#define DefaulttipAreaHeight  44
#define MaxTipAreaWidth_iPhone       240
#define MinTipAreaWidth_iPhone       80
#define TextEdgeXSpace 10
#define TextEdgeYSpace 8
#define ShowTimeSpace 1.5
#define DefaultTextWidth      240

@implementation JQTipView

static NSMutableArray *__tipControlMgr = nil;

+ (void)addTipControl:(JQTipView *)tipControl
{
    if (!tipControl)
    {
        return;
    }
    if (!__tipControlMgr)
    {
        __tipControlMgr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [__tipControlMgr addObject:tipControl];
}

+ (void)removeTipControl:(JQTipView *)tipControl
{
    [__tipControlMgr removeObject:tipControl];
}

+ (JQTipView *)getFirsttipControl
{
    if (__tipControlMgr && [__tipControlMgr count])
    {
        return [__tipControlMgr objectAtIndex:0];
    }
    return nil;
}

+ (JQTipView *)popTopTipControl
{
    JQTipView *topTipControl = nil;
    if (__tipControlMgr && [__tipControlMgr count])
    {
        topTipControl = [[[__tipControlMgr objectAtIndex:0] retain] autorelease];
    }
    [__tipControlMgr removeObjectAtIndex:0];
    return topTipControl;
}

+ (NSInteger)tipControlCount
{
    return [__tipControlMgr count];
}

+ (void)releaseTipControlMgr
{
    [__tipControlMgr release];
    __tipControlMgr = nil;
}

- (NSTimeInterval)getShowTimeSpace
{
    NSTimeInterval timeSpace = ShowTimeSpace;
    NSInteger textLength = [_label.text length];
    if (textLength <= 10)
    {
        timeSpace = 1.5;
    }
    else if (textLength <= 15)
    {
        timeSpace = 2.0;
    }
    else if (textLength <= 20)
    {
        timeSpace = 2.7;
    }
    else if (textLength <= 25)
    {
        timeSpace = 3;
        //timeSpace = 1.5;
    }
    else if(textLength <= 27) {
        timeSpace = 3.5;
    }
    else if (textLength < 35)
    {
        timeSpace = 3.5f;
    }
    else if (textLength < 40)
    {
        timeSpace = 4;
    }
    else {
        timeSpace = 4.5;
    }
    return timeSpace;
}

- (CGSize)gettipAreaSize
{
    CGFloat textWidth = [_label.text sizeWithAttributes:@{NSFontAttributeName:_label.font}].width;
    CGFloat needHeight = DefaulttipAreaHeight;
    textWidth += 2 * TextEdgeXSpace;
    if (textWidth < MaxTipAreaWidth_iPhone)
    {
        if (textWidth < MinTipAreaWidth_iPhone)
        {
            textWidth = MinTipAreaWidth_iPhone;
        }
    }
    else
    {
        textWidth = DefaultTextWidth;
       
        needHeight = [self heightForFont:_label.font width:textWidth andText:_label.text];
        needHeight += 2 * TextEdgeYSpace;
    }
    return CGSizeMake(textWidth, needHeight);
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width andText:(NSString *)text {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping andText:text];
    return ceill(size.height);
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode andText:(NSString *)text{
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [text sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGRect)gettipAreaRect
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = CGRectZero;
    rect.size = [self gettipAreaSize];
    rect.origin.x = (screenRect.size.width - rect.size.width) / 2;
    if (_withKeyBoard) {
        rect.origin.y = screenRect.size.height - rect.size.height - 210;
    } else {
        rect.origin.y = screenRect.size.height - rect.size.height - 59;
    }
    
    return rect;
}

- (UIWindow *)getWindow
{
    UIWindow *superWindow = nil;
    
    if ([[self shareAppDelegate] isKeyBoardAppear])
    {
        NSArray *windowArray = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windowArray)
        {
            if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")])
            {
                superWindow = window;
                break;
            }
        }
    }
    if (superWindow)
    {
        return superWindow;
    }
    UIWindow *window = [[self shareAppDelegate] window];
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

- (id)shareAppDelegate
{
    return (id)[UIApplication sharedApplication].delegate;
}

- (void)initSubControls
{
    _bgView = [HIModelWaitingBgView viewWithSuperView:self];
    
    _label = [HIUIViewHelper createLabelWithFrame:CGRectZero textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor whiteColor]];
    [self addSubview:_label];
    _label.numberOfLines = 0;
}

- (void)resetSubControlFrame
{
    CGRect rect = self.frame;
    rect.origin = CGPointZero;
    _bgView.frame = rect;
    _label.frame = CGRectInset(rect, TextEdgeXSpace, 0);
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (NSString *)showtext
{
    return _label.text;
}

+ (JQTipView *)showWithTip:(NSString *)tip
{
    
    if ([tip compare:NSLocalizedString(@"网络不给力，请您检查网络设置或稍后再试", @"网络不给力，请您检查网络设置或稍后再试")]==NSOrderedSame) {
        if(![[HIDialogManager shareManager] canIShowTip])
        {
            return nil;
        }
    }
    
    JQTipView *tipCtrl = [[JQTipView alloc] initWithTip:tip withKeyBoard:NO];
    [[self class] addTipControl:tipCtrl];
    if ([[self class] tipControlCount] == 1)
    {
        [tipCtrl show];
    }
    return [tipCtrl autorelease];
    
}

+ (JQTipView *)showWithTip:(NSString *)tip withKeyBoard:(BOOL)withKeyBoard
{
    JQTipView *tipCtrl = [[JQTipView alloc] initWithTip:tip withKeyBoard:withKeyBoard];
    [[self class] addTipControl:tipCtrl];
    if ([[self class] tipControlCount] == 1)
    {
        [tipCtrl show];
    }
    return [tipCtrl autorelease];
}

- (id)initWithTip:(NSString *)tip withKeyBoard:(BOOL)withKeyBoard
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubControls];
        _label.text = tip;
        _withKeyBoard = withKeyBoard;
        self.frame = [self gettipAreaRect];
        [self resetSubControlFrame];
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)stopDismissTimer
{
    [_timer invalidate];
    [_timer release];
    _timer = nil;
}

- (void)startDismissTimer
{
    [_timer invalidate];
    [_timer release];
    _timer = [NSTimer scheduledTimerWithTimeInterval:[self getShowTimeSpace] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [_timer retain];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)startDismissTimerRepeat
{
    [_timer invalidate];
    [_timer release];
    _timer = [NSTimer scheduledTimerWithTimeInterval:[self getShowTimeSpace]/2 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [_timer retain];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)_dismissFinish
{
    [[self class] removeTipControl:self];
    [_timer invalidate];
    [_timer release];
    _timer = nil;
    self.hidden = YES;
    [self autorelease];
    JQTipView *tipControl = [[self class] getFirsttipControl];
    [tipControl show];
}

- (void)dismiss
{
    JQTipView *tipControl = [[self class] getFirsttipControl];
    if ([[tipControl showtext] isEqualToStringCaseInsensitive:[self showtext]]) {
        [[self class] popTopTipControl];
        [self startDismissTimerRepeat];
        NSLog(@"提示内容重复");
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.2;
        } completion:^(BOOL finished) {
            [self _dismissFinish];
        }];
    }
}

- (void)show
{
    [self retain];
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished){
                         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         [self startDismissTimer];
                     }];
}

@end
