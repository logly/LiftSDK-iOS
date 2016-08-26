#import "LGInlineResponse200Items.h"

@implementation LGInlineResponse200Items

- (instancetype)init {
  self = [super init];
  if (self) {
    // initialize property's default value, if any
    
  }
  return self;
}


/**
 * Maps json key to property name.
 * This method is used by `JSONModel`.
 */
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{ @"published_at": @"publishedAt", @"lead": @"lead", @"advertising_subject": @"advertisingSubject", @"score": @"score", @"image_width": @"imageWidth", @"beacon_url": @"beaconUrl", @"image_height": @"imageHeight", @"site": @"site", @"is_article": @"isArticle", @"image_url": @"imageUrl", @"url": @"url", @"title": @"title", @"ld_url": @"ldUrl" }];
}

/**
 * Indicates whether the property with the given name is optional.
 * If `propertyName` is optional, then return `YES`, otherwise return `NO`.
 * This method is used by `JSONModel`.
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName {

  NSArray *optionalProperties = @[@"publishedAt", @"lead", @"advertisingSubject", @"score", @"imageWidth", @"beaconUrl", @"imageHeight", @"site", @"isArticle", @"imageUrl", @"url", @"title", @"ldUrl"];
  return [optionalProperties containsObject:propertyName];
}

@end
