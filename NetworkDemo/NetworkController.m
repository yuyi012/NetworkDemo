//
//  NetworkController.m
//  NetworkDemo
//
//  Created by 俞 億 on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkController.h"
#import "WNProgressView.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface NetworkController ()
@end

@implementation NetworkController
@synthesize progressViewBlue;
@synthesize progressViewYellow;
-(void)viewDidLoad{
    [super viewDidLoad];

}

- (void)dealloc
{
    [imageData release];
    [super dealloc];
}

-(IBAction)startButton:(id)sender{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=kNotReachable) {
        NSString *imagePath = @"http://img.evolife.cn/2011-07/ad1e1823f6c67c75.jpg";
        NSURL *url = [NSURL URLWithString:imagePath];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];        
//        NSURLConnection *urlConn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
//        [urlConn start];
        MBProgressHUD *loadingView = [[[MBProgressHUD alloc]initWithView:self.view]autorelease];
        loadingView.labelText = @"正在加载...";
        [self.view addSubview:loadingView];
        [loadingView setMode:MBProgressHUDModeDeterminate];
        loadingView.taskInProgress = YES;
        [loadingView show:YES];
        
        ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:url];
        [httpRequest setCompletionBlock:^{
            [loadingView hide:YES];
            
            UIImage *downloadedImage = [UIImage imageWithData:[httpRequest responseData]];
            progressViewBlue.hidden = YES;
            imageView.image = downloadedImage;
        }];
        static long long downloadedBytes = 0;
        [httpRequest setBytesReceivedBlock:^(unsigned long long size, unsigned long long total){
            NSLog(@"size:%lld,total:%lld",size,total);
            downloadedBytes += size;
            CGFloat progressPercent = (CGFloat)downloadedBytes/total;
            loadingView.progress = progressPercent;
            progressViewBlue.progress = progressPercent;
            progressViewYellow.progress = progressPercent;
            progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progressPercent*100];
        }];
        [httpRequest startAsynchronous];
    }else {
        NSLog(@"network not available");
    }

    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [imageData release];
    imageData = [[NSMutableData alloc]init];
    expectedLength = response.expectedContentLength;
    progressViewBlue.hidden = NO;
    progressViewBlue.progress = 0;
    progressViewYellow.progress = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [imageData appendData:data];
    CGFloat progressPercent = (CGFloat)imageData.length/expectedLength;
    NSLog(@"%f",progressPercent);
    progressViewBlue.progress = progressPercent;
    progressViewYellow.progress = progressPercent;
    progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progressPercent*100];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *downloadedImage = [UIImage imageWithData:imageData];
    progressViewBlue.hidden = YES;
    imageView.image = downloadedImage;
}
@end
