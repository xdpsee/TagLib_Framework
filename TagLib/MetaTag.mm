//
// Created by zhenhui on 2020/5/29.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MetaTag.h"
#include "tag_c.h"

#define SAFE_FREE(p) {\
    if (p != NULL) {\
        free(p);\
    }\
}

@interface MetaTag ()

- (instancetype)init;

- (void)parseTags:(const TagLib_File *)file;

- (void)parseAudioProperties:(const TagLib_File *)file;

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
        self.path = path;
        TagLib_File *file = taglib_file_new([path cStringUsingEncoding:NSUTF8StringEncoding]);
        if (file != NULL) {
            [self parseTags:file];
            [self parseAudioProperties:file];
            // Free up our used memory so far
            taglib_tag_free_strings();
            taglib_file_free(file);
        }
    }

    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:@selector(init)];
    return nil;
}

- (void)parseTags:(const TagLib_File *)file {

    TagLib_Tag *tag = taglib_file_tag(file);
    self.isValid = tag != NULL;
    if (tag != NULL) {
        char *title = taglib_tag_title(tag);
        if (title != NULL && strlen(title) > 0) {
            self.title = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        }
        SAFE_FREE(title);

        char *artist = taglib_tag_artist(tag);
        if (artist != NULL && strlen(artist) > 0) {
            self.artist = [NSString stringWithCString:artist encoding:NSUTF8StringEncoding];
        }
        SAFE_FREE(artist);

        char *album = taglib_tag_album(tag);
        if (album != NULL && strlen(album) > 0) {
            self.album = [NSString stringWithCString:album encoding:NSUTF8StringEncoding];
        }
        SAFE_FREE(album);

        char *comment = taglib_tag_comment(tag);
        if (comment != NULL && strlen(comment) > 0) {
            self.comment = [NSString stringWithCString:comment encoding:NSUTF8StringEncoding];
        }
        SAFE_FREE(comment);

        char *genre = taglib_tag_genre(tag);
        if (genre != NULL && strlen(genre) > 0) {
            self.genre = [NSString stringWithCString:genre encoding:NSUTF8StringEncoding];
        }
        SAFE_FREE(genre);

        int year = taglib_tag_year(tag);
        if (year > 0) {
            self.year = @(year);
        }

        int track = taglib_tag_track(tag);
        if (track > 0) {
            self.track = @(track);
        }
    }
}

- (void)parseAudioProperties:(const TagLib_File *)file {

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

}
@end