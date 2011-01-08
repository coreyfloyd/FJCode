
#import "NSError+FJNetwork.h"

NSString* const FJNetworkErrorDomain = @"FJNetworkErrorDomain";
NSString* const kUnparsedJSONStringKey = @"kUnparsedJSONStringKey";
NSString* const kInvalidResponseDataKey = @"kInvalidResponseDataKey";
NSString* const kCorruptImageResponseDataKey = @"kCorruptImageResponseDataKey";



@implementation NSError(FJNetwork)

+ (NSError*)errorWithErrorResponseDictionary:(NSDictionary*)dict{
    
    NSString* errorCode = [dict objectForKey:@"code"];
    NSString* description = [dict objectForKey:@"msg"];

    NSDictionary* newDict = [NSDictionary dictionaryWithObjectsAndKeys:
                          description, NSLocalizedDescriptionKey, 
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:[errorCode intValue] userInfo:newDict];
    
    return err;
}


+ (NSError*)errorWithCode:(FJNetworkErrorType)type localizedDescription:(NSString*)desc{
     
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:desc, NSLocalizedDescriptionKey, nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:type userInfo:dict];
    
    return err;
    
}
+ (NSError*)invalidNetworkResponseErrorWithStatusCode:(int)status URL:(NSURL*)url{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Invalid Network Status Code", NSLocalizedDescriptionKey, 
                          url, NSURLErrorKey, 
                          nil];   
    
    NSError* err = [NSError errorWithDomain:NSURLErrorDomain code:status userInfo:dict];
    
    return err;
    
}

+ (NSError*)cancelledNetworkRequestWithURL:(NSURL*)url{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Request was cancelled", NSLocalizedDescriptionKey, 
                          url, NSURLErrorKey, 
                          nil];   
    
    NSError* err = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:dict];
    
    return err;
    
    
}
+ (NSError*)nilNetworkRespnseErrorWithURL:(NSURL*)url{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Empty response from server", NSLocalizedDescriptionKey, 
                          url, NSURLErrorKey, 
                          nil];   
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorNilNetworkResponse userInfo:dict];
    
    return err;
    
}

+ (NSError*)JSONParseErrorWithData:(NSString*)unparsedString{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Could Not Parse, Invalid JSON Response", NSLocalizedDescriptionKey, 
                          unparsedString, kUnparsedJSONStringKey, 
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorJSONParse userInfo:dict];

    return err;

}

+ (NSError*)invalidResponseErrorWithData:(id)invalidData{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Invalid response from server", NSLocalizedDescriptionKey, 
                          invalidData, kInvalidResponseDataKey, 
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorInvalidResponse userInfo:dict];
    
    return err;
    
}

+ (NSError*)unknownErrorWithDescription:(NSString*)desc{
    
    NSDictionary* dict = nil;
    if(desc)
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                desc, NSLocalizedDescriptionKey, 
                nil];   
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorUnknown userInfo:dict];
    
    return err;
}

+ (NSError*)userNotAuthenticatedInError{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"User not logged in", NSLocalizedDescriptionKey, 
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorNotAuthenticated userInfo:dict];
    
    return err;
    
    
}

+ (NSError*)corruptImageResponse:(NSURL*)url data:(NSData*)corruptData{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Returned Image is corrupt", NSLocalizedDescriptionKey, 
                          corruptData, kCorruptImageResponseDataKey, 
                          url, NSURLErrorKey,
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorCorruptImageResponse userInfo:dict];
    
    return err;
    
    
}

+ (NSError*)missingRequiredDataError{
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Required Data missing, request not sent", NSLocalizedDescriptionKey, 
                          nil];
    
    NSError* err = [NSError errorWithDomain: FJNetworkErrorDomain code:FJNetworkErrorMissingRequiredInfo userInfo:dict];
    
    return err;
    
    
}
@end
