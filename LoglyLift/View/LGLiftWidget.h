//
//  LGLiftWidget.h
//  Pods
//
//  Created by Logly on H28/07/18.
//
//

#import <UIKit/UIKit.h>

@interface LGLiftWidget : UIView <UICollectionViewDataSource,UICollectionViewDelegate>

- (void) requestByURL:(NSString*) url adspotId:(NSNumber*)adspotId widgetId:(NSNumber*)wedgetId ref:(NSString*)ref;

@end
