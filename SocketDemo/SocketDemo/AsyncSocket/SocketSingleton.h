//
//  SocketSingleton.h
//  SocketDemo
//
//  Created by orilme on 2017/9/6.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

enum{
    SocketOfflineByServer,
    SocketOfflineByUser,
};

@interface SocketSingleton : NSObject<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

+ (SocketSingleton *)sharedInstance;

-(void)socketConnectHost;// socket连接

-(void)cutOffSocket;// 断开socket连接

-(void)socketSendData:(NSData *) data;// socket发送数据

@end
