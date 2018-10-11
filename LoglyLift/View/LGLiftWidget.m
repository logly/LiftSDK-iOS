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


#define kLiftItemCellWidth 300
#define kLiftItemCellHeight 72
#define kCellMargin 2


@interface LGLiftWidget ()
@property UICollectionView* collection;
@property NSArray<LGInlineResponse200Items>* items;
@property NSMutableDictionary* sentBeaconIndexes;       // IndexPath => @YES
@property NSMutableDictionary* loadingImageTasks;       // IndexPath => NSURLSessionDataTask
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
    self.onWigetItemClickCallback = nil;

    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"LGLiftWidget" bundle:bundle];
    NSArray* views = [nib instantiateWithOwner:nil options:nil];
    UIView* view = (UIView*)views[0];

    view.frame = self.bounds;
    view.autoresizingMask = 0;
    
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

- (void) layoutSubviews
{
    [super layoutSubviews];

    for (UIView* view in self.subviews) {
        CGRect frame = view.frame;
        frame.size.width = self.frame.size.width;
        view.frame = frame;
        [view layoutIfNeeded];
    }
    
    [self.collection.collectionViewLayout invalidateLayout];
    [self sendBeaconIfNeeded];
}

- (void) requestByURL:(NSString*) url adspotId:(NSNumber*)adspotId widgetId:(NSNumber*)widgetId ref:(NSString*)ref
{
    self.sentBeaconIndexes = @{}.mutableCopy;   // clear
    self.loadingImageTasks = @{}.mutableCopy;   // clear
    
    LGDefaultApi* api = [[LGDefaultApi alloc] init];
    [api requestLiftWithAdspotId:adspotId
                        widgetId:widgetId
                             url:url
                             ref:ref
                        toplevel:@"items"
               completionHandler:^(LGInlineResponse200 *output, NSError *error) {
                   if (error != nil) {
                       NSLog(@"LiftWidget - error while accesss Lift: %@", error.localizedDescription);
                       return;
                   }
                   self.items = output.items;
                   [self.collection reloadData];
                   [self.collection layoutIfNeeded];
                   [self sendBeaconIfNeeded];
               }];
}

- (void) sendBeaconIfNeeded
{
    CGRect contentFrame = self.collection.frame;
    contentFrame.origin = self.collection.contentOffset;
    
    NSArray* visibles = self.collection.visibleCells;
    [visibles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LGLiftWidgetCell *cell = (LGLiftWidgetCell*)obj;
        NSIndexPath *indexPath = [self.collection indexPathForCell:cell];
        if (cell != nil &&
            CGRectContainsRect(contentFrame, cell.frame) &&
            self.sentBeaconIndexes[@(indexPath.item)] == nil) {

            // send beacon.
            LGInlineResponse200Items *item = self.items[indexPath.item];
            NSString *beacon_url = [self resolveUrl:item.beaconUrl referenceUrl:item.url];
            
            if (beacon_url != nil && beacon_url.length > 0) {
                dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(q_global, ^{
                    NSError *error;
                    [NSData dataWithContentsOfURL:[NSURL URLWithString:beacon_url] options:NSDataReadingUncached error:&error];
                    if (error != nil) {
                        NSLog(@"LiftWidget - error while sending beacon: %@", error.localizedDescription);
                    } else {
                        self.sentBeaconIndexes[@(indexPath.item)] = @(YES);
                    }
                });
            }
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

    if (self.items != nil &&
        indexPath.item < self.items.count &&
        !self.loadingImageTasks[@(indexPath.item)] )
    {
        cell.textLabel.text = nil;
        cell.subtextLabel.text = nil;
        cell.imageView.image = nil;

        LGInlineResponse200Items *item = self.items[indexPath.item];
        cell.textLabel.text = item.title;
        cell.subtextLabel.text = nil;
        if (item.isArticle.longValue == 0 && item.advertisingSubject != nil) {
            cell.subtextLabel.text = [@"PR: " stringByAppendingString: item.advertisingSubject];
        }
        
        // image.
        NSString *imageUrl = item.imageUrl;
        if (imageUrl != nil) {
            imageUrl = [self resolveUrl:imageUrl referenceUrl:item.url];
            NSURLSession *sesssion = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [sesssion dataTaskWithURL:[NSURL URLWithString:imageUrl]
                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                if (error != nil) {
                    NSLog(@"LiftWidget - error while getting image: %@", error.localizedDescription);
                    return;
                }

                UIImage *image = [UIImage imageWithData:data];
                if (image != nil ) {
                    dispatch_queue_t q_main   = dispatch_get_main_queue();
                    dispatch_async(q_main, ^{
                        LGLiftWidgetCell *imageCell = (LGLiftWidgetCell*)[collectionView cellForItemAtIndexPath:indexPath];
                        imageCell.imageView.image = image;
                        [self.loadingImageTasks removeObjectForKey: @(indexPath.item)];
                    });
                }
            }];
            [dataTask resume];
            self.loadingImageTasks[@(indexPath.item)] = dataTask;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int colNum = fmax(1, collectionView.bounds.size.width / kLiftItemCellWidth);
    int leftWidth = collectionView.bounds.size.width - (colNum * kLiftItemCellWidth + (colNum -1) * kCellMargin);
    int cellWidth = kLiftItemCellWidth + leftWidth / colNum;
    return CGSizeMake(cellWidth, kLiftItemCellHeight);
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
            NSError *error = nil;
            [NSData dataWithContentsOfURL:[NSURL URLWithString:trackUrl] options:NSDataReadingUncached error:&error];
            if (error != nil) {
                if ([error.domain isEqualToString: (NSString*)kCFErrorDomainCocoa] && error.code != NSFileReadUnknownError) { // redirected to custom schema. ignore.
                    NSLog(@"LiftWidget - error while tracking access: %@ -> %@", error.localizedDescription, trackUrl);
                }
            }
        });
    }

    // open URL.
    openUrl = [self resolveUrl:openUrl referenceUrl:item.url];
    if (self.onWigetItemClickCallback != nil) {
        if (self.onWigetItemClickCallback(self, openUrl, item)) {
            return; // stop handle.
        }
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.loadingImageTasks removeObjectForKey: @(indexPath.item)];
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
