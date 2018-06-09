//
//  DDReplyView.m
//  NewDeayou
//
//  Created by Tony on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDReplyView.h"
#import "DDVRPlayerViewController.h"
@implementation DDReplyView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.sent.layer.cornerRadius = 4;
    self.textField.delegate = self;
}
- (IBAction)sentAction:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    
    if (self.type == ReplyTypeSection) {
 
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"reply" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID] ]forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:self.model.messageID forKey:@"root_id" atIndex:0];
    [diyouDic1 insertObject:self.model.messageID forKey:@"f_id" atIndex:0];
    
    [diyouDic1 insertObject:self.textField.text forKey:@"message" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
//        NSLog(@"日了🐩了%@",object);
        if (self.myBlock) {
            self.myBlock(self.model.messageID);
        }
        
    } fail:^{
        
    }];
    }else if (self.type == ReplyTypeCell){
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"reply" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
        
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID] ]forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:self.model.root_id forKey:@"root_id" atIndex:0];
        [diyouDic1 insertObject:self.model.messageID forKey:@"f_id" atIndex:0];
        
        [diyouDic1 insertObject:self.textField.text forKey:@"message" atIndex:0];
        [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
//            NSLog(@"日了🐩了%@",object);
            if (self.myBlock) {
                self.myBlock(self.model.root_id);
            }
            
        } fail:^{
            
        }];

    }

    self.textField.text = nil;
    [self.textField resignFirstResponder];
}
- (void)setModel:(DDMessageModel *)model{
    _model = model;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) return YES;
    if (textField.text.length>20){
        
        return NO;
    }
    
    
    return YES;
}

@end
