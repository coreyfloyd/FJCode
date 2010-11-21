#import "Global.h"
 

NSString* const kLastLaunchDate = @"kLastLaunchDate"; 

Progress progressWithIntegers(NSUInteger complete, NSUInteger total){
    
    if(total == 0)
        return kProgressZero;
    
     
    Progress p;

    p.total = total;
    p.complete = complete;
    
    NSNumber* t = [NSNumber numberWithUnsignedInteger:total];
    NSNumber* c = [NSNumber numberWithUnsignedInteger:complete];
    
    double r = [c doubleValue]/[t doubleValue];
    
    p.ratio = r;
    
    return p;
}


Progress const kProgressZero = {
    0,
    0,
    0.0
};


float nanosecondsWithSeconds(float seconds){
    
    return (seconds * 1000000000);
    
}

dispatch_time_t dispatchTimeFromNow(float seconds){
    
    return  dispatch_time(DISPATCH_TIME_NOW, nanosecondsWithSeconds(seconds));
    
}

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath){
    
    NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error != nil){
        return NSNotFound;
    }
    
    double bytes = 0.0;
    for(NSString* eachFile in contents){
        
        NSDictionary* meta = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:eachFile] error:&error];
        
        if(error != nil){
            
            break;
        }
        
        NSNumber* fileSize = [meta objectForKey:NSFileSize];
        bytes += [fileSize unsignedIntegerValue];
    } 
    
    if(error != nil){
        
        return NSNotFound;
    }
    
    return bytes;
    
}

double megaBytesWithBytes(NSUInteger bytes){
    
    NSNumber* b = [NSNumber numberWithUnsignedInteger:bytes];
    
    double bytesAsDouble = [b doubleValue];
    
    return bytesAsDouble/1048576.0;
    
}


double megaBytesWithLongBytes(long long bytes){
    
    NSNumber* b = [NSNumber numberWithLongLong:bytes];
    
    double bytesAsDouble = [b doubleValue];
    
    return bytesAsDouble/1048576.0;
    
}

NSString* prettyFormattedIntegerString(NSUInteger number){
    
    if(number < 1000){
        
        return [NSString stringWithFormat:@"%i", number];
        
    }
    
    float thousands = ((float)number/1000.0f);

    if(number < 10000){
        
        float halfThousands = roundf(thousands/.5)*.5;
        
        return [NSString stringWithFormat:@"%.1f K", halfThousands];
    }
    
    thousands = roundf(thousands);
    
    return [NSString stringWithFormat:@"%.0f K", thousands];
}


NSString* documentsDirectoryPath(){
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
        
}