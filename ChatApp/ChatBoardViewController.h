//
//  ChatBoardViewController.h
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//
#import "ContactViewController.h"
#import <UIKit/UIKit.h>
@interface ChatBoardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString* ContacterName;
    UITableView* tb;
    UITextField* inputField;
    UIButton* sendButton;
    NSMutableArray *ChatList;
    NSString* myname;
    ContactViewController* rootvc;
}
-(void) updatechatboard:(NSString*)msg;
@property(retain,nonatomic) NSString* ContacterName;
@property ContactViewController* rootvc;
@end
