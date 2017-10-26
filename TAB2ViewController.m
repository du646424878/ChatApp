//
//  TAB2ViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "TAB2ViewController.h"
#import "MyInfoViewController.h"
@interface TAB2ViewController ()

@end

@implementation TAB2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyInfoViewController * mivc = [[MyInfoViewController alloc] init];
    [self pushViewController:mivc animated:YES];
    
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

@end
