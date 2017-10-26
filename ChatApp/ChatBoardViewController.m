//
//  ChatBoardViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "ChatBoardViewController.h"
#import "IndexViewController.h"

@interface ChatBoardViewController ()

@end

@implementation ChatBoardViewController
@synthesize ContacterName = ContacterName;
@synthesize rootvc = rootvc;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    myname = [ud objectForKey:@"username"];
    //视图设置
    self.navigationItem.title = ContacterName;
    self.view.backgroundColor = [UIColor whiteColor];
    //数据视图初始化
    tb = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tb.delegate = self;
    tb.dataSource = self;
    //数据初始化
    ChatList  = [[NSMutableArray alloc] init];
    [NSThread detachNewThreadSelector:@selector(loaddatafromdb) toTarget:self withObject:nil];
    //输入框初始化
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(2,self.view.frame.size.height-38,self.view.frame.size.width-42, 36)];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    NSLog(@"输入框坐标%f,%f",inputField.frame.origin.x,inputField.frame.origin.y);
    //发送按钮初始化
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, self.view.frame.size.height-40, 40, 40)];
    sendButton.tintColor = [UIColor blueColor];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(pressSend) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"发送按钮坐标%f,%f",sendButton.frame.origin.x,sendButton.frame.origin.y);
    //添加视图
    [self.view addSubview:tb];
    [self.view addSubview:inputField];
    [self.view addSubview:sendButton];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (void) viewWillDisappear:(BOOL)animated{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.rootvc.ischatboardopen = NO;
    self.rootvc.chatingwithwho = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pressSend{
    
    NSString* msg = inputField.text;
    
    [ChatList addObject: [[myname stringByAppendingString:@">"] stringByAppendingString:msg]];
    [tb reloadData];
    IndexViewController* ivc = (IndexViewController*) self.navigationController.tabBarController;
    
    [ivc transmitmessage:[[ContacterName stringByAppendingString:@">"] stringByAppendingString:msg]];
    inputField.text = @"";
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ChatList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* str = @"cell";
    
    UITableViewCell* cell  = [tb dequeueReusableCellWithIdentifier:str];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    NSString* sendername =[[ChatList objectAtIndex:indexPath.row] substringToIndex: [[ChatList objectAtIndex:indexPath.row] rangeOfString:@">"].location];
    if([myname isEqualToString:sendername]){
    cell.textLabel.text = @"我";
    }
    else{
    cell.textLabel.text = sendername;
    }
    NSString* message = [[ChatList objectAtIndex:indexPath.row] substringFromIndex: [[ChatList objectAtIndex:indexPath.row] rangeOfString:@">"].location+1];
    cell.detailTextLabel.text = message;
    UIImage* image = [UIImage imageNamed:@"contact.jpg"];
    cell.imageView.image = image;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"历史记录";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [inputField resignFirstResponder];
}
-(void) updatechatboard:(NSString*)msg{
    [NSThread detachNewThreadWithBlock:^(void){
    NSLog(@"正在更新界面");
    [ChatList addObject:msg];
    [tb reloadData];
    }];
}
-(void) loaddatafromdb{
    NSString *selectSQL=@"select * from history where (sender = ? and recver =?) or (sender = ? and recver =?) order by id asc";
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* mname = [ud objectForKey:@"username"];
    //查询返回的为一个结果集
    IndexViewController* temp = self.rootvc.mydelegate;
    FMResultSet *set=[temp.db executeQuery:selectSQL,mname,ContacterName,ContacterName,mname];
    //需要对结果集进行遍历操作
    while([set next]){//获取吓一跳记录,如果没有下一条,返回NO;
    //取数据
    NSString *sender=[set stringForColumn:@"sender"];
    NSString *content=[set stringForColumn:@"content"];
        [ChatList addObject: [[sender stringByAppendingString:@">"] stringByAppendingString:content]];
    }
    [tb reloadData];
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
