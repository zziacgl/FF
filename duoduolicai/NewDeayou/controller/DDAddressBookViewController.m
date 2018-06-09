//
//  DDAddressBookViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/21.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAddressBookViewController.h"
#import <AddressBook/AddressBook.h>
@interface DDAddressBookViewController ()

@end

@implementation DDAddressBookViewController
{
    ABAddressBookRef addressBook;
    NSArray *myContacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    addressBook=ABAddressBookCreate();
//    ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, (__bridge void *)(self));
}
-(BOOL)checkAddressBookAuthorizationStatus:(UITableView *)tableView
{
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted,CFErrorRef error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@",(__bridge NSError *)error);
                }else if (!granted){
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Authorization Denied"
                                                                 message:@"Set permissions in Settiong>General>Privacy."
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
                    [av show];
                }else{
                    //还原 ABAddressBookRef
                    ABAddressBookRevert(addressBook);
                    myContacts = [NSArray arrayWithArray:(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook)];
                    [tableView reloadData];
                }
            });
        });
    }
    return authStatus == kABAuthorizationStatusAuthorized;
}
//-(void)addressBookChanged(ABAddressBookRef addressBook,CFDictionaryRef info,void *context)
//{
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
