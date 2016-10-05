//
//  SADownloadItem.m
//  Pods
//
//  Created by Gabriel Coman on 30/09/2016.
//
//

#import "SADownloadItem.h"

@implementation SADownloadItem

- (id) init {
    if (self = [super init]) {
        _urlKey = nil;
        _diskUrl = nil;
        _ext = nil;
        _isOnDisk = false;
        _nrRetries = 0;
        _responses = [@[] mutableCopy];
    }
    
    return self;
}

- (void) incrementNrRetries {
    _nrRetries++;
}

- (void) clearResponses {
    [_responses removeAllObjects];
}

- (void) addResponse:(id)response {
    if (response != nil) {
        [_responses addObject:response];
    }
}

@end
