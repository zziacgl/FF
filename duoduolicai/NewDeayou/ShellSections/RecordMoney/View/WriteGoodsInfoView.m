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

@end

@implementation WriteGoodsInfoView


+ (void)showWithView:(UIView *)view sureButtonAction:(void(^)(ShellGoodsModel *shellGoodsModel))sureButtonAction {
    WriteGoodsInfoView *goodsView = [[NSBundle mainBundle] loadNibNamed:@"WriteGoodsInfoView" owner:nil options:nil].firstObject;
    goodsView.frame = view.bounds;
    goodsView.sureButtonAction = sureButtonAction;
    [goodsView show];
    [view addSubview:goodsView];
//    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    
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
    ShellGoodsModel *model = [ShellGoodsModel new];
    model.goodsName = self.nameTextField.text;
    model.count = self.countTextField.text;
    model.buyingPrice = self.buyPriceTextField.text;
    model.sellingPrice = self.sellPriceTextField.text;
    if (self.sureButtonAction) self.sureButtonAction(model);
    [self hide];
}

@end
