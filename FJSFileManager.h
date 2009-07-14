//
//  FJSFIleManager.h
//  FJSCode
//
//  Created by Corey Floyd on 7/13/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  {
    UserFolderDocuments = 0,
    UserFolderCache  = 1
} UserFolder;


//TODO: rewrite methods to respond to errors and remove fileExists logic

@interface FJSFileManager : NSObject {
    
    NSString *fileName;
    NSString *folderName;
    UserFolder saveLocation;
    
    NSDictionary *dataCache;
    
}
//set these 3 properties to determine where file is loaded or saved
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *folderName; //if no folder is set, data will be saved directly into the UserFolder
@property(nonatomic,assign)UserFolder saveLocation;

//holds last loaded or saved dictionary
@property(nonatomic,readonly)NSDictionary *dataCache;

//save and load data
- (BOOL)saveData:(NSDictionary*)data withError:(NSError*)error;
- (NSDictionary*)loadDataWithError:(NSError*)error;

//deleted file at path to fileName
- (BOOL)deleteFileWithError:(NSError*)error;

//create folder at path to folderName
- (BOOL)createFolder;

//delete contents of folderName
- (BOOL)emptyFolderWithError:(NSError*)error;

- (NSString *)folderPath;
- (NSString *)filePath;

@end

//Additional dictionary Keys
NSString *saveDateKey = @"SaveDate";
