//
//  SYNetworkPrivate.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/5.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetworkRequest.h"
#import "SYNetworkBaseRequest.h"
#import "SYNetworkManager.h"
#import "SYNetworkConfig.h"

//Cache Folder 
extern NSString * _Nonnull const SYNetworkCacheBaseFolderName;


@interface SYNetworkBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

//下载信息
@property (nonatomic, readwrite, copy)    NSString *resumeDataFilePath;                // resume data file path
@property (nonatomic, readwrite, copy)    NSString *resumeDataInfoFilePath;            // resume data info file path
@end

@interface SYNetworkUtils : NSObject

+ (NSString *)md5StringFromString:(NSString *)string;

+ (BOOL)validateResumeData:(NSData *)data;

/**
 *  This method is used to return resume data file path of the given requestIdentifer
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *  @param downloadFileName     the download file name (the last path component of a complete download request url)
 *
 *  @return resume data file path
 */
+ (NSString * _Nonnull)resumeDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer downloadFileName:(NSString * _Nonnull)downloadFileName;


/**
 *  This method is used to create a folder of a given folder name
 *
 *  @param folderName                   folder name
 *
 *  @return the full path of the new folder
 */
+ (NSString * _Nonnull)createBasePathWithFolderName:(NSString * _Nonnull)folderName;




/**
 *  This method is used to create cache base folder path
 *
 *
 *  @return the base cache  folder path
 */
+ (NSString * _Nonnull)createCacheBasePath;

@end
