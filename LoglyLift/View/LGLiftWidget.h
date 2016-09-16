//
//  LGLiftWidget.h
//  Pods
//
//  Created by Logly on H28/07/18.
//
//

#import <UIKit/UIKit.h>
#import "LGInlineResponse200Items.h"

@interface LGLiftWidget : UIView <UICollectionViewDataSource,UICollectionViewDelegate>

/**
 click callback.
 @param widget Lift widget
 @param url URL to go.
 @param item Lift result data.
 */
@property (nonatomic, copy) BOOL (^onWigetItemClickCallback)(LGLiftWidget *widget, NSString *url, LGInlineResponse200Items *item);

/**
 request Lift recomendations asyncronusly.
 note that actual access will be run by other thread. so this method returns soon.
 @param url page URL (/MDL) for recomendation key.
 @param adspotId Adspot ID, obtained from Logly.
 @param widgetId Widget ID, obtained from Logly.
 @param ref Referer URL, can be empty (usually not used in mobile client).
 */
- (void) requestByURL:(NSString*) url adspotId:(NSNumber*)adspotId widgetId:(NSNumber*)wedgetId ref:(NSString*)ref;

@end
