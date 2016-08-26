//
//  DetailViewController.h
//  LiftSample-objc
//
//  Created by Logly on H28/07/18.
//  Copyright © 平成28年 Logly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LGLiftWidget.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary* detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet LGLiftWidget *liftWidget;

@end

