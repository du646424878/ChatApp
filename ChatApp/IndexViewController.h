//
//  IndexViewController.h
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "ContactViewController.h"
@interface IndexViewController : UITabBarController<ContactViewDelegate>{
    id<IndexViewDelegate> mydele;
    FMDatabase * db;
}
-(void) startgetlist;
@property(retain,atomic) id<IndexViewDelegate> mydele;
@property FMDatabase * db;

@end
