//
//  AppDelegate.h
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContactViewDelegate <NSObject>
-(void) startgetlist;
-(void) transmitmessage:(NSString*) msg;
@end
@protocol IndexViewDelegate <NSObject>

-(void) updateList:(NSString*) msg;
-(void) updateList_msg:(NSString *)msg;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

