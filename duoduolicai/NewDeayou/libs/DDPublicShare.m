//
//  DDPublicShare.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/7/4.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDPublicShare.h"

#define kSpace  20

@implementation DDPublicShare

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lifeLineView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightLineView];
        [self addSubview:self.weixinBtn];
        [self addSubview:self.weixinLabel];
        [self addSubview:self.qqBtn];
        [self addSubview:self.qqLabel];
        [self addSubview:self.weixinFriendBtn];
        [self addSubview:self.weixinFriendLabel];
        [self addSubview:self.zoneBtn];
        [self addSubview:self.zoneLabel];
        [self addSubview:self.cancelBtn];
        
        
    }
    return self;
}

- (UIView *)lifeLineView {
    if (!_lifeLineView) {
        self.lifeLineView = [[UIView alloc] initWithFrame:CGRectMake(kSpace, 40, CGRectGetWidth(self.frame) / 2 - 50, 1)];
        _lifeLineView.backgroundColor = [UIColor lightGrayColor];
        _lifeLineView.alpha = 0.7;
    }
    return _lifeLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lifeLineView.frame), 30, 60, 20)];
        _titleLabel.text = @"分享到";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    return _titleLabel;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        self.rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 40, CGRectGetWidth(self.frame) / 2 - 50 , 1)];
        _rightLineView.backgroundColor = [UIColor lightGrayColor];
        _rightLineView.alpha = 0.7;
        
    }
    return _rightLineView;
}


-(UIButton *)weixinBtn {
    if (!_weixinBtn) {
        self.weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinBtn.frame = CGRectMake(kSpace, CGRectGetMaxY(self.titleLabel.frame) + 30, (CGRectGetWidth(self.frame) - kSpace * 5) / 4, (CGRectGetWidth(self.frame) - kSpace * 5) / 4);
        [_weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    }
    return _weixinBtn;
}

- (UILabel *)weixinLabel {
    if (!_weixinLabel) {
        
        self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.weixinBtn.frame), (CGRectGetWidth(self.frame) - kSpace * 5) / 4, 20)];
        _weixinLabel.textAlignment = NSTextAlignmentCenter;
        _weixinLabel.font = [UIFont systemFontOfSize:12];
        _weixinLabel.text = @"微信";
        _weixinLabel.textColor = [UIColor grayColor];
        
        
    }
    return _weixinLabel;
}
- (UIButton *)qqBtn {
    if (!_qqBtn) {
        self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqBtn.frame = CGRectMake(CGRectGetMaxX(self.weixinLabel.frame) + kSpace, CGRectGetMaxY(_titleLabel.frame) + 30, (CGRectGetWidth(self.frame) - kSpace * 5) / 4, (CGRectGetWidth(self.frame) - kSpace * 5) / 4);
        [_qqBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        
        
    }
    return _qqBtn;

}

- (UILabel *)qqLabel {
    if (!_qqLabel) {
        self.qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinBtn.frame) + kSpace, CGRectGetMaxY(self.qqBtn.frame), (CGRectGetWidth(self.frame) - kSpace * 5) / 4, 20)];
        _qqLabel.text = @"腾讯QQ";
        _qqLabel.textColor = [UIColor grayColor];
        _qqLabel.textAlignment = NSTextAlignmentCenter;
        _qqLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _qqLabel;

}

- (UIButton *)weixinFriendBtn {
    if (!_weixinFriendBtn) {
        self.weixinFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinFriendBtn.frame = CGRectMake(CGRectGetMaxX(self.qqBtn.frame) + kSpace, CGRectGetMaxY(_titleLabel.frame) + 30, (CGRectGetWidth(self.frame) - kSpace * 5) / 4, (CGRectGetWidth(self.frame) - kSpace * 5) / 4);
        [_weixinFriendBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    }
    return _weixinFriendBtn;
}

- (UILabel *)weixinFriendLabel {
    if (!_weixinFriendLabel) {
        self.weixinFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.qqLabel.frame) + kSpace, CGRectGetMaxY(self.weixinFriendBtn.frame), (CGRectGetWidth(self.frame) - kSpace * 5) / 4, 20)];
        _weixinFriendLabel.text = @"朋友圈";
        _weixinFriendLabel.textColor = [UIColor grayColor];
        _weixinFriendLabel.textAlignment = NSTextAlignmentCenter;
        _weixinFriendLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _weixinFriendLabel;
}


- (UIButton *)zoneBtn {
    if (!_zoneBtn) {
        self.zoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoneBtn.frame = CGRectMake(CGRectGetMaxX(self.weixinFriendBtn.frame) + kSpace, CGRectGetMaxY(_titleLabel.frame) + 30, (CGRectGetWidth(self.frame) - kSpace * 5) / 4, (CGRectGetWidth(self.frame) - kSpace * 5) / 4);
        [_zoneBtn setImage:[UIImage imageNamed:@"空间"] forState:UIControlStateNormal];
        
    }
    return _zoneBtn;
}


- (UILabel *)zoneLabel {
    if (!_zoneLabel) {
        self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinFriendBtn.frame) + kSpace, CGRectGetMaxY(self.zoneBtn.frame),(CGRectGetWidth(self.frame) - kSpace * 5) / 4 , 20)];
        _zoneLabel.text = @"QQ空间";
        _zoneLabel.textColor = [UIColor grayColor];
        _zoneLabel.textAlignment = NSTextAlignmentCenter;
        _zoneLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _zoneLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(CGRectGetWidth(self.frame) / 5, CGRectGetHeight(self.frame) - 56, CGRectGetWidth(self.frame) / 5 * 3, 36);
        _cancelBtn.backgroundColor = [UIColor orangeColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.layer setCornerRadius:5];
        [_cancelBtn.layer setMasksToBounds:YES];
    }
    return _cancelBtn;
}






@end
