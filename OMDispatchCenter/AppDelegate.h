//
//  AppDelegate.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDispatchCenter.h"
#import "OMSong.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) OMDispatchCenter *center;
@property (strong, nonatomic) OMSong *song;
@end
