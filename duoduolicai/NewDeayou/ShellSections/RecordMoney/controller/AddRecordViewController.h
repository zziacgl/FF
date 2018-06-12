//
//  AddRecordViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRecordViewController : UIViewController

@property (nonatomic, assign) RecordType recordType;
@property (nonatomic, strong) ShellRecordModel *recordModel;

@end
