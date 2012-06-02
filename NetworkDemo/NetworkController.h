//
//  NetworkController.h
//  NetworkDemo
//
//  Created by 俞 億 on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNProgressView;

@interface NetworkController : UIViewController<NSURLConnectionDataDelegate>{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *progressLabel;
    NSMutableData *imageData;
    long long expectedLength;
}
-(IBAction)startButton:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet WNProgressView *progressViewBlue;
@property (unsafe_unretained, nonatomic) IBOutlet WNProgressView *progressViewYellow;
@end
