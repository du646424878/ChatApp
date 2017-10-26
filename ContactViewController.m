//
//  ContactViewController.m
//  ChatApp
//
//  Created by 杜哲凯 on 2017/10/24.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "ContactViewController.h"
#import "ChatBoardViewController.h"
@interface ContactViewController (){

}
@end

@implementation ContactViewController
@synthesize mydelegate = mydelegate;
@synthesize ischatboardopen = ischatboardopen;
@synthesize chatingwithwho = chatingwithwho;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化变量
    self.ischatboardopen= NO;
    chatingwithwho = nil;
    //将自己设置为tabviewcontroller的委托
    IndexViewController* father = (IndexViewController*)self.navigationController.tabBarController;
    father.mydele = self;
    //设置背景颜色和导航栏title
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"联系人";
    //数据视图设置
    tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tb.delegate = self;
    tb.dataSource = self;
    //初始化数组
    ContactsList = [[ NSMutableArray alloc] init];
    LastMsgList =[[ NSMutableArray alloc] init];
    NSLog(@"%@",ContactsList);
    //通知fathercontroller可以接收数据了
    mydelegate = father;
    [mydelegate startgetlist];
    //添加视图
    [self.view addSubview:tb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ContactsList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

NSString* str = @"cell";
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    UITableViewCell* cell  = [tb dequeueReusableCellWithIdentifier:str];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    cell.textLabel.text = [ContactsList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [LastMsgList objectAtIndex:indexPath.row];;
    UIImage* image = [UIImage imageNamed:@"contact.jpg"];
    cell.imageView.image = image;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
return @"所有在线用户";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
//打开chatboard视图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.ischatboardopen =YES;
    ChatBoardViewController* cbvc = [[ChatBoardViewController alloc] init];
    NSString* Chatusername= [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    cbvc.ContacterName =Chatusername;
    cbvc.rootvc = self;
    self.chatingwithwho =Chatusername;
    [self.navigationController pushViewController:cbvc animated:YES];
}

-(void) updateList:(NSString *)msg{
    [NSThread detachNewThreadWithBlock:^(void){
    if([[msg substringToIndex:1] isEqualToString:@"+"]){
        NSLog(@"yyyyy");
        [ContactsList addObject:[msg substringFromIndex:1]];
        [LastMsgList addObject:@""];
        NSLog(@"添加后%@",ContactsList);
        [tb reloadData];
    }
    else if([[msg substringToIndex:1] isEqualToString:@"-"]){
        NSLog(@"nnnnn");
        [ContactsList removeObject:[msg substringFromIndex:1]];
        [tb reloadData];
    }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) updateList_msg:(NSString *)msg{
    [NSThread detachNewThreadWithBlock:^(void){
    NSString* srcuser = [msg substringToIndex:[msg rangeOfString:@">"].location];
    NSString* content = [msg substringFromIndex:[msg rangeOfString:@">"].location+1];
    NSLog(@"%@发来消息%@",srcuser,content);
    for(int i =0; i< ContactsList.count;i++){
        if([[tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].textLabel.text isEqualToString:srcuser]){
            NSLog(@"找到了");
            [LastMsgList replaceObjectAtIndex:i withObject:content];
            [tb reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:i inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    } ];
}
@end
