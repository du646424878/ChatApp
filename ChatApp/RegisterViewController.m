//
//  RegisterViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "RegisterViewController.h"
#import "IndexViewController.h"
#import <arpa/inet.h>
@interface RegisterViewController (){
    int _clientSocketId;
    //接收缓冲区
    char revbuffer[100];
    UIAlertView* _alertview;

}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)PressCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Register:(UIButton *)sender {
    if([_mPasswordTF.text isEqualToString:_checkPasswordTF.text]){
    
    NSString* NSmessage = [[_mUsernameTF.text stringByAppendingString:@"&"] stringByAppendingString:_mPasswordTF.text];
    NSLog(@"发送字符串：%@",NSmessage);
    const char * cmessage = [NSmessage cStringUsingEncoding:NSASCIIStringEncoding];
    send(_clientSocketId,cmessage, strlen(cmessage)+1, 0);
    recv(_clientSocketId,revbuffer, 100,0);
    if(revbuffer[0]=='Y'){
        _alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:@"注册成功！"
                                               delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
        [_alertview show];
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setObject: _mUsernameTF.text forKey:@"username"];
        [self presentViewController:[[IndexViewController alloc] init] animated:YES completion:nil];
    }
    else{
        _alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:@"该用户名已被占用"
                                               delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
        [_alertview show];
    }
}
    else{
        _alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:@"两次输入密码不一致"
                                               delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
        [_alertview show];
      
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mUsernameTF resignFirstResponder];
    [_mPasswordTF resignFirstResponder];
    [_checkPasswordTF resignFirstResponder];
}
-(void) Connect{
    //建立套接字并连接服务器
    _clientSocketId = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"套接字已创建");
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(13004);
    //连接到服务器端的地址
    inet_pton(AF_INET,"192.168.1.115", &addr.sin_addr);
    //连接
    int connectId = connect(_clientSocketId, ( struct sockaddr*)&addr, sizeof(addr));
    if (connectId == -1) {
        
        NSLog(@"connect error");
        
    }
}
@end
