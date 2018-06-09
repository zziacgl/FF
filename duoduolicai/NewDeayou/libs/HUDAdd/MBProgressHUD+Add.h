
#import "MBProgressHUD.h"

@interface MBProgressHUD(add)


+ (BOOL)hideStaticHUDForView:(UIView *)view animated:(BOOL)animated;

+ (void)hudWithView:(UIView *)view label:(NSString *)msg;

+ (void)errorHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay;

+ (void)checkHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay;

+ (MBProgressHUD *)progressHudWithMessage:(NSString *)msg view:(UIView*)view;
@end
