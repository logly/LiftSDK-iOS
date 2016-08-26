//
//  DetailViewController.m
//  LiftSample-objc
//
//  Created by Logly on H28/07/18.
//  Copyright © 平成28年 Logly. All rights reserved.
//

#import "DetailViewController.h"

#define kLoglySampleAdspotId @(3777016)
#define kLoglySampleWidgetId @(1684)
#define kLoglySampleRef @"http://blog.logly.co.jp/"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDictionary*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem[@"text"];
        [self.liftWidget requestByURL:self.detailItem[@"url"]
                             adspotId:kLoglySampleAdspotId
                             widgetId:kLoglySampleWidgetId
                                  ref:kLoglySampleRef];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
