//
//  IndexViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "IndexViewController.h"
#import "TAB1ViewController.h"
#import "TAB2ViewController.h"
#import "ChatBoardViewController.h"
#import <arpa/inet.h>
@interface IndexViewController (){
    int _BoardConnectionClientSocketId;
    int _ChatConnectionClientSocketiId;
    char bufferForBoard[20];
    char bufferForChat[100];
}

@end

@implementation IndexViewController
@synthesize mydele = mydele;
@synthesize db = db;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数据库对象
    NSString* dbpath = [NSHomeDirectory() stringByAppendingString:@"/Documents/chatHistory.db"];
    db = [FMDatabase databaseWithPath:dbpath];
    if([db open])
        NSLog(@"数据库连接成功！");
    NSString* strCreatetable = @"create table if not exists history(id integer primary key autoincrement,sender varchar(20),recver varchar(20),content varchar(100))";
    BOOL success=[db executeUpdate:strCreatetable];
    if(success){
        NSLog(@"创建数据表成功");
    }
    else{
        NSLog(@"创建数据表失败");
    }
    //初始化两个TABController
    TAB1ViewController* tab1 = [[TAB1ViewController alloc] init];
    UITabBarItem* tbitem1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:101];
    tbitem1.title = @"联系人";
    
    tab1.tabBarItem = tbitem1;
    
    TAB2ViewController* tab2 = [[TAB2ViewController alloc] init];
    UITabBarItem* tbitem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:102];
    tbitem2.title = @"更多";
    tab2.tabBarItem = tbitem2;
    NSArray* Controllers = [[NSArray alloc] initWithObjects:tab1,tab2,nil];
    [self setViewControllers:Controllers];
    [self BoardConnect];
    [self ChatConnect];
    
    
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
-(void) BoardConnect{
    //建立套接字并连接服务器
    _BoardConnectionClientSocketId = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"套接字已创建");
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(13002);
    //连接到服务器端的地址
    inet_pton(AF_INET,"192.168.1.115", &addr.sin_addr);
    //连接
    int connectId = connect(_BoardConnectionClientSocketId, ( struct sockaddr*)&addr, sizeof(addr));
    if (connectId == -1) {
        
        NSLog(@"connect error");
        
    }
    else{
        NSLog(@"连接到联系人列表服务器！");
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        NSString* name = [ud objectForKey:@"username"];
        const char * message = [[@"+" stringByAppendingString:name] cStringUsingEncoding: NSASCIIStringEncoding];
        send(_BoardConnectionClientSocketId,message,strlen(message)+1,0);
    }
    
}
//线程执行函数
-(void) getContacts:(id)sender{
    while(1){
        recv(_BoardConnectionClientSocketId,bufferForBoard,sizeof(bufferForBoard),0);
        NSLog(@"BoardConnection:%s",bufferForBoard);
        NSLog(@"%@",self.mydele);
        [self.mydele updateList:[NSString stringWithUTF8String:bufferForBoard]];
    }
 
}
-(void) startgetlist{
 [NSThread detachNewThreadSelector:@selector(getContacts:) toTarget:self withObject:nil];
}
-(void) ChatConnect{
    //建立套接字并连接服务器
    _ChatConnectionClientSocketiId  = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"套接字已创建");
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(13003);
    //连接到服务器端的地址
    inet_pton(AF_INET,"192.168.1.115", &addr.sin_addr);
    //连接
    int connectId = connect(_ChatConnectionClientSocketiId, ( struct sockaddr*)&addr, sizeof(addr));
    if (connectId == -1) {
        
        NSLog(@"connect error");
        
    }
    else{
        NSLog(@"连接到聊天服务器！");
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        NSString* name = [ud objectForKey:@"username"];
        const char * message = [name cStringUsingEncoding: NSASCIIStringEncoding];
        send(_ChatConnectionClientSocketiId,message,strlen(message)+1,0);
        [NSThread detachNewThreadSelector:@selector(listenMsg:) toTarget:self withObject:nil];
        
    }
}
-(void)transmitmessage:(NSString *)msg{
    [NSThread detachNewThreadWithBlock:^(void){
    const char* Cmsg = [msg cStringUsingEncoding:NSASCIIStringEncoding];
    //存数据库
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString *sender = [ud objectForKey:@"username"];
    NSString * insertSQL=@"insert into history (sender,recver,content) values (?,?,?)";
    NSString * recver = [msg substringToIndex:[msg rangeOfString:@">"].location];
    NSString * content =[msg substringFromIndex:[msg rangeOfString:@">"].location+1];
    BOOL success=[db executeUpdate:insertSQL,sender,recver,content];
    if (success) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    send(_ChatConnectionClientSocketiId,Cmsg,strlen(Cmsg)+1,0);
    }];
}
//监听服务器发消息过来
-(void) listenMsg:(id)sender{
    while(1){
        recv(_ChatConnectionClientSocketiId,bufferForChat,sizeof(bufferForChat),0);
        NSLog(@"ChatConnection:%s",bufferForChat);
        //存数据库
        NSString * recvmsg = [NSString stringWithUTF8String:bufferForChat];
        NSString * insertSQL=@"insert into history (sender,recver,content) values (?,?,?)";
        NSString * sender = [recvmsg substringToIndex:[recvmsg rangeOfString:@">"].location];
        NSString * content =[recvmsg substringFromIndex:[recvmsg rangeOfString:@">"].location+1];
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        NSString *recver = [ud objectForKey:@"username"];
        BOOL success=[db executeUpdate:insertSQL,sender,recver,content];
        if (success) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
        //更新Contact视图
        [self.mydele updateList_msg:[NSString stringWithUTF8String:bufferForChat]];
        //判断chat是否开着
        ContactViewController* contactvc = self.mydele;
        if((contactvc.ischatboardopen == YES)&&([contactvc.chatingwithwho isEqualToString:sender])){
            NSLog(@"开着窗口的");
           ChatBoardViewController* a =  contactvc.navigationController.topViewController;
            [a updatechatboard:[NSString stringWithUTF8String:bufferForChat]];
        }
    }

}

@end
