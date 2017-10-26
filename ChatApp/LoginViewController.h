//
//  LoginViewController.h
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mUsernameTF;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTF;
- (IBAction)pressLogin:(UIButton *)sender;
- (IBAction)pressRegister:(UIButton *)sender;

@end
