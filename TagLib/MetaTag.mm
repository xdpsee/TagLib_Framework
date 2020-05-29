//
// Created by zhenhui on 2020/5/29.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MetaTag.h"
#include "tag_c.h"

@interface MetaTag ()

- (instancetype) init;

@end

@implementation MetaTag

- (void)dealloc {
    self.path = nil;
    self.title = nil;
    self.artist = nil;
    self.album = nil;
    self.genre = nil;
    self.track = nil;
    self.year = nil;
    self.comment = nil;
    self.length = nil;
    self.sampleRate = nil;
    self.bitRate = nil;
    self.channels = nil;
}

- (instancetype)initWithFileAtPath:(NSString *)path {
    self = [super init];
    if (self) {
        taglib_set_strings_unicode(TRUE);
        TagLib_File *file = taglib_file_new([path cStringUsingEncoding:NSUTF8StringEncoding]);
        self.path = path;
        if (file != NULL) {
            TagLib_Tag *tag;
            tag = taglib_file_tag(file);
            self.isValid = tag != NULL;
            if (tag != NULL) {
                if (taglib_tag_title(tag) != NULL && strlen(taglib_tag_title(tag)) > 0) {
                    self.title = [NSString stringWithCString:taglib_tag_title(tag)
                                                    encoding:NSUTF8StringEncoding];
                }

                if (taglib_tag_artist(tag) != NULL && strlen(taglib_tag_artist(tag)) > 0) {
                    self.artist = [NSString stringWithCString:taglib_tag_artist(tag)
                                                     encoding:NSUTF8StringEncoding];
                }

                if (taglib_tag_album(tag) != NULL && strlen(taglib_tag_album(tag)) > 0) {
                    self.album = [NSString stringWithCString:taglib_tag_album(tag)
                                                    encoding:NSUTF8StringEncoding];
                }

                if (taglib_tag_comment(tag) != NULL && strlen(taglib_tag_comment(tag)) > 0) {
                    self.comment = [NSString stringWithCString:taglib_tag_comment(tag)
                                                      encoding:NSUTF8StringEncoding];
                }

                if (taglib_tag_genre(tag) != NULL && strlen(taglib_tag_genre(tag)) > 0) {
                    self.genre = [NSString stringWithCString:taglib_tag_genre(tag)
                                                    encoding:NSUTF8StringEncoding];
                }

                if (taglib_tag_year(tag) > 0) {
                    self.year = @(taglib_tag_year(tag));
                }

                if (taglib_tag_track(tag) > 0) {
                    self.track = @(taglib_tag_track(tag));
                }
            }

            const TagLib_AudioProperties *properties = taglib_file_audioproperties(file);
            self.isAudioPropertyValid = properties != NULL;
            if (self.isAudioPropertyValid && taglib_audioproperties_length(properties) > 0) {
                self.length = @(taglib_audioproperties_length(properties));
            }
            if (self.isAudioPropertyValid && taglib_audioproperties_samplerate(properties) > 0) {
                self.sampleRate = @(taglib_audioproperties_samplerate(properties));
            }
            if (self.isAudioPropertyValid && taglib_audioproperties_bitrate(properties) > 0) {
                self.bitRate = @(taglib_audioproperties_bitrate(properties));
            }
            if (self.isAudioPropertyValid && taglib_audioproperties_channels(properties) > 0) {
                self.channels = @(taglib_audioproperties_channels(properties));
            }
            // Free up our used memory so far
            taglib_tag_free_strings();
            taglib_file_free(file);
        }
    }

    return self;
}

-(instancetype) init {
    [self doesNotRecognizeSelector:@selector(init)];
    return nil;
}

@end