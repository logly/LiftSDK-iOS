//
//  DetailViewController.m
//  LiftSample-objc
//
//  Created by Logly on H28/07/18.
//  Copyright © 平成28年 Logly. All rights reserved.
//

#import "DetailViewController.h"

#define kLoglySampleAdspotId @(4228263)
#define kLoglySampleWidgetId @(3624)
#define kLoglySampleRef @"http://blog.logly.co.jp/"

@interface DetailViewController ()
@property BOOL isDebugMode;

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
    self.isDebugMode = NO;

    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem[@"text"];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressed:)];
        [self.detailDescriptionLabel addGestureRecognizer:longPress];
        self.detailDescriptionLabel.userInteractionEnabled = YES;
    }
    
    if (self.liftWidget) {
        [self.liftWidget requestByURL:self.detailItem[@"url"]
                             adspotId:kLoglySampleAdspotId
                             widgetId:kLoglySampleWidgetId
                                  ref:kLoglySampleRef];
        
        self.liftWidget.onWigetItemClickCallback = ^(LGLiftWidget *widget, NSString *url, LGInlineResponse200Items *item) {
            if (self.isDebugMode) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Debug Mode"
                                                                               message:url
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction: [UIAlertAction actionWithTitle:@"Dissmis"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil] ];
                [self presentViewController:alert animated: YES completion: nil];
                return YES;
            }
            return NO;
        };
    }
}

- (void)longpressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    self.isDebugMode = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Debug Mode"
                                                                   message:@"Debug Mode Enabled"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"Dissmis"
                                             style:UIAlertActionStyleDefault
                                           handler:nil] ];
    [self presentViewController:alert animated: YES completion: nil];
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
