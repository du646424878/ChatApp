//
//  ContactViewController.h
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexViewController.h"
#import "AppDelegate.h"
@interface ContactViewController : UIViewController<IndexViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    id<ContactViewDelegate> mydelegate;
    UITableView* tb;
    NSMutableArray *ContactsList;
    NSMutableArray *LastMsgList;
    BOOL ischatboardopen;
    NSString* chatingwithwho;
    
}

@property id<ContactViewDelegate> mydelegate;
@property BOOL ischatboardopen;
@property NSString* chatingwithwho;
-(void) updateList:(NSString *)msg;
-(void) updateList_msg:(NSString *)msg;
@end
