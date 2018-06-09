//
//  DDReplyView.h
//  NewDeayou
//
//  Created by Tony on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMessageModel.h"
typedef NS_ENUM(NSInteger, ReplyType) {
    ReplyTypeSection,
    ReplyTypeCell
   };
@interface DDReplyView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sent;
@property (copy,nonatomic) void(^myBlock)(NSString*messageID);
@property(nonatomic,strong)DDMessageModel*model;
@property(nonatomic,assign)ReplyType type;
@end
