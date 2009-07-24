//
//  FJSFIleManager.m
//  FJSCode
//
//  Created by Corey Floyd on 7/13/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSFileManager.h"
#import "NSString+extensions.h"


NSString *const saveDateKey = @"SaveDate";

@implementation FJSFileManager


@synthesize fileName;
@synthesize folderName;
@synthesize saveLocation;
@synthesize dataCache;



- (BOOL)saveData:(NSDictionary*)data withError:(NSError**)error{
    
    BOOL didWrite = NO;
    
    NSMutableDictionary *mutableData = [data mutableCopy];
    dataCache = mutableData;
    
    [mutableData setObject:[NSDate date] forKey:saveDateKey];
    
    if([self createFolder]){
        
        didWrite = [mutableData writeToFile:[self filePath] atomically:YES];
        
        if(!didWrite)
            didWrite = [NSKeyedArchiver archiveRootObject:mutableData toFile:[self filePath]];
                
    }
    
    return didWrite;
    
    
}
- (NSDictionary*)loadDataWithError:(NSError**)error{
    
    [dataCache release];
    dataCache=nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        
        dataCache = [[NSDictionary dictionaryWithContentsOfFile:[self filePath]] retain];
        
        if(dataCache==nil)
            dataCache = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]] retain]; 
    }
    
        return dataCache;
    
}


- (BOOL)deleteFileWithError:(NSError**)error{
    
    
    return [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:nil];

    
}

- (BOOL)deleteFolderWithError:(NSError**)error{
    
    
    return [[NSFileManager defaultManager] removeItemAtPath:[self folderPath] error:nil];
    
    
}

    
    
    
- (BOOL)createFolder{
    
    BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[self folderPath] isDirectory:&isDirectory]) {
        
        if(!isDirectory){
            [[NSFileManager defaultManager] removeItemAtPath:[self folderPath] error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:[self folderPath] attributes:nil];
        }
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self folderPath]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[self folderPath] attributes:nil];
        
    } 
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self folderPath]];
    
}

- (BOOL)emptyFolderWithError:(NSError**)error{
    BOOL answer = YES;
    
    BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[self folderPath] isDirectory:&isDirectory]) {
        
        if(isDirectory){
         
            NSArray *files  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:nil];
            
            for (NSString *eachPath in files){
                
                if(![[NSFileManager defaultManager] removeItemAtPath:[[self folderPath] stringByAppendingPathComponent:eachPath] error:nil]){
                    *error = [NSError errorWithDomain:NSCocoaErrorDomain code:512 userInfo:nil];
                    answer = NO;
                }
                
            }
        } else {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:4 userInfo:nil];
            answer = NO;
        }

    }else{
        
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:4 userInfo:nil];
        answer = NO;
    }
    
    return answer;
}


- (NSString *)folderPath{
    
    NSArray *paths; 
    
    if(saveLocation==UserFolderCache)
        paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    else if(saveLocation==UserFolderDocuments)
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [paths objectAtIndex:0]; 
    
    if(folderName!=nil){
        if(![folderName isEmpty])
            filePath = [filePath stringByAppendingPathComponent:folderName]; 
        
    }
    
    return filePath;
}
    
    
    
- (NSString *)filePath{
	
    NSString *filePath = nil;
    NSString *folder = [self folderPath]; 
    
    if(folder!=nil){
        if(fileName!=nil){
            if(![fileName isEmpty])
                filePath = [folder stringByAppendingPathComponent:fileName]; 
            
        }         
    }
    
        
	return filePath;
	
}




- (void) dealloc{
    
    
    self.fileName = nil;
    self.folderName = nil;
    [dataCache release];
    dataCache=nil;    
    [super dealloc];
}


@end
