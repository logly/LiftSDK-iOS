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
  return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"publishedAt": @"published_at", @"lead": @"lead", @"advertisingSubject": @"advertising_subject", @"score": @"score", @"imageWidth": @"image_width", @"beaconUrl": @"beacon_url", @"imageHeight": @"image_height", @"site": @"site", @"isArticle": @"is_article", @"imageUrl": @"image_url", @"url": @"url", @"title": @"title", @"ldUrl": @"ld_url", @"category": @"category" }];
}

/**
 * Indicates whether the property with the given name is optional.
 * If `propertyName` is optional, then return `YES`, otherwise return `NO`.
 * This method is used by `JSONModel`.
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName {

  NSArray *optionalProperties = @[@"publishedAt", @"lead", @"advertisingSubject", @"score", @"imageWidth", @"beaconUrl", @"imageHeight", @"site", @"isArticle", @"imageUrl", @"url", @"title", @"ldUrl", @"category"];
  return [optionalProperties containsObject:propertyName];
}

@end
