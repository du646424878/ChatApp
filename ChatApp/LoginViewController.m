//
//  LoginViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "IndexViewController.h"
#import <arpa/inet.h>
@interface LoginViewController (){
    int _clientSocketId;
    //接收缓冲区
    char revbuffer[100];
    UIAlertView* _alertview;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mPasswordTF.secureTextEntry = YES;
    [self Connect];
}

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

- (IBAction)pressLogin:(UIButton *)sender {
        NSString* NSmessage = [[_mUsernameTF.text stringByAppendingString:@"&"] stringByAppendingString:_mPasswordTF.text];
        NSLog(@"发送字符串：%@",NSmessage);
        const char * cmessage = [NSmessage cStringUsingEncoding:NSASCIIStringEncoding];
        send(_clientSocketId,cmessage, strlen(cmessage)+1, 0);
        recv(_clientSocketId,revbuffer, 100,0);
        if(revbuffer[0]=='Y'){
            
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setObject: _mUsernameTF.text forKey:@"username"];
            [self presentViewController:[[IndexViewController alloc] init] animated:YES completion:nil];
        }
        else{
            _alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:@"用户名或密码错误"
                                                  delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [_alertview show];
        }
}
- (void)pressRegister:(UIButton *)sender{
    [self presentViewController:[[RegisterViewController alloc] init] animated:YES completion:nil];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mUsernameTF resignFirstResponder];
    [_mPasswordTF resignFirstResponder];
}
-(void) Connect{
    //建立套接字并连接服务器
    _clientSocketId = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"套接字已创建");
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(13000);
    //连接到服务器端的地址
    inet_pton(AF_INET,"192.168.1.115", &addr.sin_addr);
    //连接
    int connectId = connect(_clientSocketId, ( struct sockaddr*)&addr, sizeof(addr));
    if (connectId == -1) {
        
        NSLog(@"connect error");
        
    }
}
@end
