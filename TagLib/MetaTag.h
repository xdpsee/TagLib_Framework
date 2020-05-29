//
// Created by zhenhui on 2020/5/29.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaTag : NSObject

@property(nonatomic, copy) NSString *path;
// Tags
@property(nonatomic) BOOL isValid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *artist;
@property(nonatomic, copy) NSString *album;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, copy) NSString *genre;
@property(nonatomic, retain) NSNumber *track;
@property(nonatomic, retain) NSNumber *year;
// Audio properties
@property(nonatomic) BOOL isAudioPropertyValid;
@property(nonatomic, retain) NSNumber *length;
@property(nonatomic, retain) NSNumber *sampleRate;
@property(nonatomic, retain) NSNumber *bitRate;
@property(nonatomic, retain) NSNumber *channels;

- (instancetype)initWithFileAtPath:(NSString *)path;

@end
