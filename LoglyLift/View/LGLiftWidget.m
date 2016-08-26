//
//  LGLiftWidget.m
//  Pods
//
//  Created by Logly on H28/07/18.
//
//

#import "LGLiftWidget.h"
#import "LGLiftWidgetCell.h"
#import "LGDefaultApi.h"

@interface LGLiftWidget ()
@property UICollectionView* collection;
@property NSArray<LGInlineResponse200Items>* items;
@end

@implementation LGLiftWidget

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.items = nil;

    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"LGLiftWidget" bundle:bundle];
    NSArray* views = [nib instantiateWithOwner:nil options:nil];
    UIView* view = (UIView*)views[0];

    view.frame = self.bounds;
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.collection = [view viewWithTag:1000];
    if (self.collection) {
        self.collection.dataSource = self;
        self.collection.delegate = self;
        self.collection.scrollEnabled = NO;
        self.collection.pagingEnabled = NO;
        
        UINib *nibFirst = [UINib nibWithNibName:@"LGLiftWidgetCell" bundle:bundle];
        [self.collection registerNib:nibFirst forCellWithReuseIdentifier:@"LGLiftWidgetCell"];
    }

    [self addSubview:view];
}

- (void) requestByURL:(NSString*) url adspotId:(NSNumber*)adspotId widgetId:(NSNumber*)wedgetId ref:(NSString*)ref
{
    LGDefaultApi* api = [LGDefaultApi sharedAPI];
    [api requestLiftWithAdspotId:adspotId
                        widgetId:wedgetId
                             url:url
                             ref:ref
                        toplevel:@"items"
               completionHandler:^(LGInlineResponse200 *output, NSError *error) {
                   if (error != nil) {
                       NSLog(error.localizedDescription);
                   } else {
                       self.items = output.items;
                       [self.collection reloadData];
                   }
               }];
}

#pragma mark - UICollectionView Datasource / Delegate.

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.items == nil) {
        return 0;
    }
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGLiftWidgetCell *cell = (LGLiftWidgetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"LGLiftWidgetCell" forIndexPath:indexPath];
    cell.textLabel.text = nil;
    cell.subtextLabel.text = nil;
    cell.imageView.image = nil;

    if (self.items != nil && indexPath.item < self.items.count) {
        LGInlineResponse200Items *item = self.items[indexPath.item];
        cell.textLabel.text = item.lead;
        cell.subtextLabel.text = item.title;
        
        NSString* protocol = [[NSURL URLWithString:item.url].scheme stringByAppendingString:@":"];

        dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q_global, ^{
            // image.
            NSString *url = item.imageUrl;
            if ([url hasPrefix:@"//"]) {
                url = [protocol stringByAppendingString:url];
            }
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
            UIImage *image = [UIImage imageWithData:data];

            if (image != nil ) {
                dispatch_queue_t q_main   = dispatch_get_main_queue();
                dispatch_async(q_main, ^{
                    cell.imageView.image = image;
                });
            }

            // beacon.
            url = item.beaconUrl;
            if ([url hasPrefix:@"//"]) {
                url = [protocol stringByAppendingString:url];
            }
            [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
        });
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGInlineResponse200Items *item = self.items[indexPath.item];

    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q_global, ^{
        // click tracking.
        NSString* protocol = [[NSURL URLWithString:item.url].scheme stringByAppendingString:@":"];
        NSString *url = item.ldUrl;
        if ([url hasPrefix:@"//"]) {
            url = [protocol stringByAppendingString:url];
        }
        NSError *error = nil;
        [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
    });

    // open URL.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.url]];
}

@end
