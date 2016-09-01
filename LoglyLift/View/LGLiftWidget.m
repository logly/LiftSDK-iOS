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
                       NSLog(@"error while accesss Lift: %@", error.localizedDescription);
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
        
        dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q_global, ^{
            // image.
            NSString *imageUrl = item.imageUrl;
            NSError *error = nil;

            if (imageUrl != nil) {
                imageUrl = [self resolveUrl:imageUrl referenceUrl:item.url];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl] options:NSDataReadingUncached error:&error];
                UIImage *image = [UIImage imageWithData:data];

                if (image != nil ) {
                    dispatch_queue_t q_main   = dispatch_get_main_queue();
                    dispatch_async(q_main, ^{
                        cell.imageView.image = image;
                    });
                }
            }

            // beacon.
            NSString *beacon_url = [self resolveUrl:item.beaconUrl referenceUrl:item.url];
            if (beacon_url != nil) {
                [NSData dataWithContentsOfURL:[NSURL URLWithString:beacon_url] options:NSDataReadingUncached error:&error];
            }
        });
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LGInlineResponse200Items *item = self.items[indexPath.item];

    NSString *trackUrl = item.url;
    NSString *openUrl = item.ldUrl;
    if (openUrl == nil) {
        openUrl = trackUrl;
        trackUrl = nil;
    }
    
    if (trackUrl != nil) {
        dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q_global, ^{
            // click tracking.
            NSString *trackUrl2 = [self resolveUrl:openUrl referenceUrl:trackUrl];
            NSError *error = nil;
            [NSData dataWithContentsOfURL:[NSURL URLWithString:trackUrl2] options:NSDataReadingUncached error:&error];
        });
    }

    // open URL.
    openUrl = [self resolveUrl:openUrl referenceUrl:item.url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
}

- (NSString*)resolveUrl:(NSString*)url referenceUrl:(NSString*)ref
{
    if (url == nil) {
        return nil;
    }

    NSString* protocol = [[NSURL URLWithString:ref].scheme stringByAppendingString:@":"];
    if ([url hasPrefix:@"//"]) {
        return [protocol stringByAppendingString:url];
    }
    return url;
}

@end
