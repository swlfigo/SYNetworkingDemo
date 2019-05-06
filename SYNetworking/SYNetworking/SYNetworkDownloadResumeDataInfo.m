//
//  SYNetworkDownloadResumeDataInfo.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/6.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkDownloadResumeDataInfo.h"

@implementation SYNetworkDownloadResumeDataInfo

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    if (self) {
        
        self.resumeDataRatio = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(resumeDataRatio))];
        self.resumeDataLength = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(resumeDataLength))];
        self.totalDataLength = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(totalDataLength))];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.resumeDataLength forKey:NSStringFromSelector(@selector(resumeDataLength))];
    [aCoder encodeObject:self.totalDataLength forKey:NSStringFromSelector(@selector(totalDataLength))];
    [aCoder encodeObject:self.resumeDataRatio forKey:NSStringFromSelector(@selector(resumeDataRatio))];
}



- (NSString *)description{
    
    return [NSString stringWithFormat:@"<%@: %p>:{resume data length:%@}, {total data length:%@},{ratio:%@}",NSStringFromClass([self class]), self,_resumeDataLength, _totalDataLength, _resumeDataRatio];
}


@end
