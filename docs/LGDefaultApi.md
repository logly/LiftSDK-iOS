# LGDefaultApi

All URIs are relative to *https://l.logly.co.jp*

Method | HTTP request | Description
------------- | ------------- | -------------
[**requestLift**](LGDefaultApi.md#requestlift) | **GET** /lift.json | Liftレコメンデーション結果検索


# **requestLift**
```objc
-(NSURLSessionTask*) requestLiftWithAdspotId: (NSNumber*) adspotId
    widgetId: (NSNumber*) widgetId
    url: (NSString*) url
    ref: (NSString*) ref
    toplevel: (NSString*) toplevel
        completionHandler: (void (^)(LGInlineResponse200* output, NSError* error)) handler;
```

Liftレコメンデーション結果検索

Liftレコメンデーション結果検索 注：返される結果数はLogly Lift コンソールの方で設定するが、表示はエリアの空きがある分だけ表示される

### Example 
```objc

NSNumber* adspotId = @789; // Lift adspot ID
NSNumber* widgetId = @789; // Lift wiget ID
NSString* url = @"url_example"; // キーとなるページ URL (MDL)
NSString* ref = @"ref_example"; // リファラーURL（通常Mobileでは必要なし） (optional)
NSString* toplevel = @"items"; // jsonトップレベルhash名: 通常は'items'を指定 (optional) (default to items)

LGDefaultApi*apiInstance = [[LGDefaultApi alloc] init];

// Liftレコメンデーション結果検索
[apiInstance requestLiftWithAdspotId:adspotId
              widgetId:widgetId
              url:url
              ref:ref
              toplevel:toplevel
          completionHandler: ^(LGInlineResponse200* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling LGDefaultApi->requestLift: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adspotId** | **NSNumber***| Lift adspot ID | 
 **widgetId** | **NSNumber***| Lift wiget ID | 
 **url** | **NSString***| キーとなるページ URL (MDL) | 
 **ref** | **NSString***| リファラーURL（通常Mobileでは必要なし） | [optional] 
 **toplevel** | **NSString***| jsonトップレベルhash名: 通常は&#39;items&#39;を指定 | [optional] [default to items]

### Return type

[**LGInlineResponse200***](LGInlineResponse200.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

