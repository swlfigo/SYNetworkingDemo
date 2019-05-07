//
//  SYNetworkPrivate.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/5.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkPrivate.h"
#import <CommonCrypto/CommonDigest.h>

NSString * const SYNetworkCacheBaseFolderName = @"SYNetworkCache";
NSString * const SYNetworkDownloadResumeDataInfoFileSuffix = @"resumeInfo";

@implementation SYNetworkUtils

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

+ (BOOL)validateResumeData:(NSData *)data {
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    // After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
    // complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
    // We can only assume that the plist being successfully parsed means the resume data is valid.
    return YES;
}

+ (NSString * _Nonnull)resumeDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer downloadFileName:(NSString * _Nonnull)downloadFileName{
    NSParameterAssert(requestIdentifer != nil);
    NSString *dataFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer, downloadFileName];
    NSString * resumeDataFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:dataFileName];
    return resumeDataFilePath;
}

+ (NSString * _Nonnull)resumeDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer{
    
    NSString * dataInfoFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer,SYNetworkDownloadResumeDataInfoFileSuffix];
    NSString * resumeDataInfoFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:dataInfoFileName];
    return resumeDataInfoFilePath;
}


+ (NSString * _Nonnull)createBasePathWithFolderName:(NSString * _Nonnull)folderName{
    
    NSString *pathOfCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfCache stringByAppendingPathComponent:folderName];
    [self p_createDirectoryIfNeeded:path];
    return path;
    
}


+ (NSString * _Nonnull)createCacheBasePath{
    
    return [self createBasePathWithFolderName:SYNetworkCacheBaseFolderName];
}

+ (void)p_createDirectoryIfNeeded:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        
        [self p_createBaseDirectoryAtPath:path];
        
    } else {
        
        if (!isDir) {
            
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self p_createBaseDirectoryAtPath:path];
        }
    }
}




+ (void)p_createBaseDirectoryAtPath:(NSString *)path {
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}



+ (SYNetworkDownloadResumeDataInfo *)loadResumeDataInfo:(NSString *)filePath {
    
    SYNetworkDownloadResumeDataInfo *dataInfo = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        dataInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if ([dataInfo isKindOfClass:[SYNetworkDownloadResumeDataInfo class]]) {
            return dataInfo;
        }else{
            return nil;
        }
    }
    return nil;
}
@end
