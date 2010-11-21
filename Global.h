#import <Foundation/Foundation.h>

//uncomment if using the simulator with charles
#define USE_CHARLES_PROXY

//structs
typedef struct {
    NSUInteger complete;
    NSUInteger total;
    double ratio;
} Progress;

Progress progressWithIntegers(NSUInteger complete, NSUInteger total);
extern Progress const kProgressZero;

typedef enum  {
	SORT_DATE, 
	SORT_DATE_DESC,
	SORT_ALPHA,
	SORT_SIZE,
} SortType;


float nanosecondsWithSeconds(float seconds);
dispatch_time_t dispatchTimeFromNow(float seconds);

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath);
double megaBytesWithBytes(NSUInteger bytes);
double megaBytesWithLongBytes(long long bytes);

NSString* prettyFormattedIntegerString(NSUInteger number);

NSString* documentsDirectoryPath();

extern NSString* const kLastLaunchDate;  

