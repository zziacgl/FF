//
// MBProgressHUD.m
// Version 0.6
// Created by Matej Bukovinski on 2.4.09.
//

#import "MBProgressHUD+Add.h"


@implementation UIApplication (KeyboardView)

- (UIView *)keyboardView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
			if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end
@implementation MBProgressHUD(add)

+ (BOOL)hideStaticHUDForView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].delegate.window;
    }
    [activityHUD hide:animated];
	MBProgressHUD *hud = [self HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

static MBProgressHUD *activityHUD;

+ (MBProgressHUD *)progressHudWithMessage:(NSString *)msg view:(UIView*)view
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].delegate.window;
    }
    
    view = [MBProgressHUD viewForView:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.dimBackground = NO;
    HUD.animationType = MBProgressHUDAnimationFade;
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.detailsLabelText = msg;
    [HUD show:YES];
    activityHUD = HUD;
    return HUD;
}

+ (void)hudWithView:(UIView *)view label:(NSString *)msg
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].delegate.window;
    }
    
    //view = [MBProgressHUD viewForView:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.dimBackground = NO;
    HUD.animationType = MBProgressHUDAnimationFade;
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.detailsLabelText = msg;
    [HUD show:YES];
    activityHUD = HUD;
}

+ (void)errorHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].delegate.window;
    }
    
    if ([msg isKindOfClass:[NSNull class]]||!msg) {
        return;
    }
    
   // view = [MBProgressHUD viewForView:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:HUD action:@selector(hideHud)];
    [HUD addGestureRecognizer:tap];
    HUD.dimBackground = NO;
    HUD.animationType = MBProgressHUDAnimationFade;
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.detailsLabelText = msg;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}

+ (void)checkHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].delegate.window;
    }
    
   // view = [MBProgressHUD viewForView:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:HUD action:@selector(hideHud)];
    [HUD addGestureRecognizer:tap];
    
    HUD.dimBackground = NO;
    HUD.animationType = MBProgressHUDAnimationFade;
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.detailsLabelText = msg;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}

+ (UIView *)viewForView:(UIView *)view;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (keyboardView)
    {
        view = keyboardView.superview;
    }
    else
    {
    }
    return view;
}

-(void)hideHud
{
    [self hide:YES];
}


@end
