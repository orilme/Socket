//
//  AsyncSocketViewController.m
//  SocketDemo
//
//  Created by orilme on 2017/9/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "AsyncSocketViewController.h"
#import "SocketSingleton.h"

@interface AsyncSocketViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UITextView *showTextView;
@end

@implementation AsyncSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:@"SOCKETREAGSUCCESS" object:nil];
    
    self.hostTextField.text = @"192.168.1.112";// 自己的IP地址
    self.portTextField.text = @"8888";
}

- (IBAction)sendConnect:(id)sender {
    [SocketSingleton sharedInstance].socketHost = self.hostTextField.text;// host设定
    [SocketSingleton sharedInstance].socketPort = [self.portTextField.text intValue];// port设定
    
    // 在连接前先进行手动断开
    [SocketSingleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[SocketSingleton sharedInstance] socketConnectHost];
    
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
//    [SocketSingleton sharedInstance].socket.userData = SocketOfflineByServer;
//    [[SocketSingleton sharedInstance] cutOffSocket];
}

- (IBAction)sendMessage:(id)sender {
    [self.view endEditing:YES];
    NSData *data = [self.sendTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    [[SocketSingleton sharedInstance] socketSendData:data];
}

-(void)addMessage:(NSString *)str{
    self.showTextView.text = [self.showTextView.text stringByAppendingFormat:@"%@\n",str];
    [self.showTextView scrollRangeToVisible:[self.showTextView.text rangeOfString:str options:NSBackwardsSearch]];
}

-(void)getMessage:(NSNotification *)notification {
    [self addMessage:[NSString stringWithFormat:@"收到数据：%@",notification.userInfo[@"message"]]];
    [[SocketSingleton sharedInstance].socket readDataWithTimeout: -1 tag: 0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
