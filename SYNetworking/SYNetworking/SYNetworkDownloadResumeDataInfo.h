//
//  SYNetworkDownloadResumeDataInfo.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/6.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Use for Record infomation of resume data.
 */

@interface SYNetworkDownloadResumeDataInfo : NSObject<NSSecureCoding>

// Record the resume data length
@property (nonatomic, readwrite, copy) NSString *resumeDataLength;

// Record total length of the download data
@property (nonatomic, readwrite, copy) NSString *totalDataLength;

// Record the ratio of resume data length and total length of download data (resumeDataLength/dataTotalLength)
@property (nonatomic, readwrite, copy) NSString *resumeDataRatio;

@end


