//
//  ViewController.h
//  ToDo List
//
//  Created by Jackson on 30/01/2017.
//  Copyright © 2017 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSDate * eventDate;
@property (nonatomic, strong) NSString * eventInfo;
@property (nonatomic, assign) BOOL isDetail;

@end

