//
//  SocketSingleton.m
//  SocketDemo
//
//  Created by orilme on 2017/9/6.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "SocketSingleton.h"

@implementation SocketSingleton

+(SocketSingleton *) sharedInstance {
    static SocketSingleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

// socket连接
-(void)socketConnectHost {
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    BOOL isConnect = [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:-1 error:&error];;
    if (isConnect) {
        NSLog(@"连接成功");
    }else {
        NSLog(@"连接失败");
    }
}

// socket发送数据
-(void)socketSendData:(NSData *) data {
    [self.socket writeData:data withTimeout:-1 tag:1];//-1不设置超时
}

// 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"socket连接成功");
    [self.socket readDataWithTimeout: -1 tag: 0];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}

// 心跳连接
-(void)longConnectToSocket{
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    NSData   *dataStream  = [@"longConnect" dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:-1 tag:1];//-1不设置超时
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *msg = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"message":msg};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SOCKETREAGSUCCESS" object:nil userInfo:dic];
    
    [self.socket readDataWithTimeout: -1 tag: 0];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    // [self addMessage:[NSString stringWithFormat:@"发送了"]];
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}

// 切断socket
-(void)cutOffSocket{
    self.socket.userData = SocketOfflineByUser;
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

@end
