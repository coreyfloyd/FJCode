
#import <UIKit/UIKit.h>

extern NSString* const FJNetworkErrorDomain;

typedef enum  {
    
     FJNetworkErrorUnknown,
     FJNetworkErrorNilNetworkResponse,
     FJNetworkErrorJSONParse,
     FJNetworkErrorInvalidResponse,
     FJNetworkErrorNotAuthenticated,
     FJNetworkErrorCorruptImageResponse,
     FJNetworkErrorMissingRequiredInfo
    
} FJNetworkErrorType;

extern NSString* const kUnparsedJSONStringKey;
extern NSString* const kInvalidResponseDataKey;
extern NSString* const kCorruptImageResponseDataKey;


@interface NSError(FJNetwork)

+ (NSError*)errorWithErrorResponseDictionary:(NSDictionary*)dict;

+ (NSError*)invalidNetworkResponseErrorWithStatusCode:(int)status URL:(NSURL*)url;

+ (NSError*)invalidNetworkResponseErrorWithStatusCode:(int)status message:(NSString*)message URL:(NSURL*)url;

+ (NSError*)networkRequestTimeOutErrorWithURL:(NSURL*)url;

+ (NSError*)cancelledNetworkRequestWithURL:(NSURL*)url;

+ (NSError*)nilNetworkRespnseErrorWithURL:(NSURL*)url;

+ (NSError*)JSONParseErrorWithData:(NSString*)unparsedString;

+ (NSError*)invalidResponseErrorWithData:(id)invalidData;

+ (NSError*)userNotAuthenticatedInError;

+ (NSError*)unknownErrorWithDescription:(NSString*)desc;

+ (NSError*)corruptImageResponse:(NSURL*)url data:(NSData*)corruptData;

+ (NSError*)missingRequiredDataError;

@end
