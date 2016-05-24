//
//  ViewController.m
//  12-1网络连接
//
//  Created by cj on 16/5/2.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    
    //2.建立请求
#warning 在iOS 9 中此方法过时了，先学习旧的
   // NSURLRequest *request = [NSURLRequest requestWithURL:url];
   /**
    cachePolicy:缓存策略
    timeoutInterval:超时时间，默认60秒，一般我们设置15到20秒
    */
   NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:3];
    
    //3.建立连接，发送异步请求到服务器
    /**
     queue:看具体情况，如果更新UI，就写NSOperationQueue mainQueue ;如果类似下载一个压缩包的场景，还需要子线程解压缩，就alloc init新线程。
     hander:网络访问完成以后执行的代码块，回调
     response:服务器的响应
     connectionError:服务器返回的错误
     */
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable connectionError) {
        
        if (connectionError || data == nil) {
            NSLog(@"网络不给力，请稍后再试,%@",data);
            return ;
        }
        //解压缩在子线程
        NSLog(@"开始解压缩......");
        
        //更新UI在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"主线程更新UI");
        });
        
        //网络请求完成以后调用这块代码，从服务器获得二进制数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
   //4.同步请求
    //NULL:本身就是0，标志地址是0
    //nil:表示地址为0的空对象
    NSURLResponse *response =nil;//服务器响应的信息存放的地址
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&request error:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
