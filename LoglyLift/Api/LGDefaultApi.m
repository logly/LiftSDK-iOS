#import "LGDefaultApi.h"
#import "LGQueryParamCollection.h"
#import "LGApiClient.h"
#import "LGInlineResponse200.h"


@interface LGDefaultApi ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableDefaultHeaders;

@end

@implementation LGDefaultApi

NSString* kLGDefaultApiErrorDomain = @"LGDefaultApiErrorDomain";
NSInteger kLGDefaultApiMissingParamErrorCode = 234513;

@synthesize apiClient = _apiClient;

#pragma mark - Initialize methods

- (instancetype) init {
    return [self initWithApiClient:[LGApiClient sharedClient]];
}


-(instancetype) initWithApiClient:(LGApiClient *)apiClient {
    self = [super init];
    if (self) {
        _apiClient = apiClient;
        _mutableDefaultHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -

-(NSString*) defaultHeaderForKey:(NSString*)key {
    return self.mutableDefaultHeaders[key];
}

-(void) setDefaultHeaderValue:(NSString*) value forKey:(NSString*)key {
    [self.mutableDefaultHeaders setValue:value forKey:key];
}

-(NSDictionary *)defaultHeaders {
    return self.mutableDefaultHeaders;
}

#pragma mark - Api Methods

///
/// Liftレコメンデーション結果検索
/// Liftレコメンデーション結果検索 注：返される結果数はLogly Lift コンソールの方で設定するが、表示はエリアの空きがある分だけ表示される
///  @param adspotId Lift adspot ID 
///
///  @param widgetId Lift wiget ID 
///
///  @param url キーとなるページ URL (MDL) 
///
///  @param ref リファラーURL（通常Mobileでは必要なし） (optional)
///
///  @param toplevel jsonトップレベルhash名: 通常は'items'を指定 (optional, default to items)
///
///  @returns LGInlineResponse200*
///
-(NSURLSessionTask*) requestLiftWithAdspotId: (NSNumber*) adspotId
    widgetId: (NSNumber*) widgetId
    url: (NSString*) url
    ref: (NSString*) ref
    toplevel: (NSString*) toplevel
    completionHandler: (void (^)(LGInlineResponse200* output, NSError* error)) handler {
    // verify the required parameter 'adspotId' is set
    if (adspotId == nil) {
        NSParameterAssert(adspotId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"adspotId"] };
            NSError* error = [NSError errorWithDomain:kLGDefaultApiErrorDomain code:kLGDefaultApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    // verify the required parameter 'widgetId' is set
    if (widgetId == nil) {
        NSParameterAssert(widgetId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"widgetId"] };
            NSError* error = [NSError errorWithDomain:kLGDefaultApiErrorDomain code:kLGDefaultApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    // verify the required parameter 'url' is set
    if (url == nil) {
        NSParameterAssert(url);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"url"] };
            NSError* error = [NSError errorWithDomain:kLGDefaultApiErrorDomain code:kLGDefaultApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/lift.json"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (adspotId != nil) {
        queryParams[@"adspot_id"] = adspotId;
    }
    if (widgetId != nil) {
        queryParams[@"widget_id"] = widgetId;
    }
    if (url != nil) {
        queryParams[@"url"] = url;
    }
    if (ref != nil) {
        queryParams[@"ref"] = ref;
    }
    if (toplevel != nil) {
        queryParams[@"toplevel"] = toplevel;
    }
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[@"application/json"]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"LGInlineResponse200*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((LGInlineResponse200*)data, error);
                                }
                            }];
}



@end
