//
//  MasterViewController.h
//  LiftSample-objc
//
//  Created by Logly on H28/07/18.
//  Copyright © 平成28年 Logly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

