//
//  ViewController.m
//  SocketDemo
//
//  Created by orilme on 2017/9/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "ViewController.h"
#import "AsyncSocketViewController.h"
#import "SocketViewController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (!self.dataArray) {
        self.dataArray=@[@"AsyncSocket举例", @"socket举例"];
    }
    
    //初始化表格
    if (!self.myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,10, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        self.myTableView.showsVerticalScrollIndicator   = NO;
        self.myTableView.showsHorizontalScrollIndicator = NO;
        self.myTableView.dataSource                     = self;
        self.myTableView.delegate                       = self;
        [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:self.myTableView];
    }
}

#pragma mark UITableViewDataSource, UITableViewDelegate相关内容
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AsyncSocketViewController *asyncSocketView = [[AsyncSocketViewController alloc]init];
        [self presentViewController:asyncSocketView animated:YES completion:nil];
    }else if (indexPath.row == 1) {
        SocketViewController *socketView = [[SocketViewController alloc]init];
        [self presentViewController:socketView animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
