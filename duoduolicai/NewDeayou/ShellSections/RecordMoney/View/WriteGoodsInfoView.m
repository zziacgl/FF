//
//  WriteGoodsInfoView.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "WriteGoodsInfoView.h"
#import "ShellGoodsModel.h"

@interface WriteGoodsInfoView ()

@property (nonatomic, copy) void(^sureButtonAction)(ShellGoodsModel *shellGoodsModel);
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *sellPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@property (weak, nonatomic) IBOutlet UIView *firstBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *secondBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *thirdBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *fourBackgroundView;

@end

@implementation WriteGoodsInfoView


+ (void)showWithView:(UIView *)view sureButtonAction:(void(^)(ShellGoodsModel *shellGoodsModel))sureButtonAction {
    WriteGoodsInfoView *goodsView = [[NSBundle mainBundle] loadNibNamed:@"WriteGoodsInfoView" owner:nil options:nil].firstObject;
    goodsView.frame = view.bounds;
    goodsView.sureButtonAction = sureButtonAction;
    [goodsView show];
    [view addSubview:goodsView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupBackgroundView:self.firstBackgroundView];
    [self setupBackgroundView:self.secondBackgroundView];
    [self setupBackgroundView:self.thirdBackgroundView];
    [self setupBackgroundView:self.fourBackgroundView];

}

- (void)setupBackgroundView:(UIView *)view {
    view.layer.cornerRadius = view.height / 2;
    view.clipsToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = kMainColor.CGColor;
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hide];
}

- (IBAction)sureButtonPressed:(id)sender {
    if (!self.nameTextField.text.length) {
        [MBProgressHUD errorHudWithView:self label:@"商品名称不能为空" hidesAfter:1.2];
        return;
    }
    if (!self.buyPriceTextField.text.length) {
        [MBProgressHUD errorHudWithView:self label:@"进价不能为空" hidesAfter:1.2];
        return;
    }
    if (!self.sellPriceTextField.text.length) {
        [MBProgressHUD errorHudWithView:self label:@"售价不能为空" hidesAfter:1.2];
        return;
    }
    if (!self.countTextField.text.length) {
        [MBProgressHUD errorHudWithView:self label:@"数量不能为空" hidesAfter:1.2];
        return;
    }
    ShellGoodsModel *model = [ShellGoodsModel new];
    model.goodsName = self.nameTextField.text;
    model.count = self.countTextField.text;
    model.buyingPrice = self.buyPriceTextField.text;
    model.sellingPrice = self.sellPriceTextField.text;
    if (self.sureButtonAction) self.sureButtonAction(model);
    [self hide];
}


@end
