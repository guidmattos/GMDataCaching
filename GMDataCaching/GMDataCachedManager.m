
//  GMDataCachedManager.m
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//

#import "GMDataCachedManager.h"

@interface GMDataCachedManager()

@property NSURL *cachedUri;

@end

@implementation GMDataCachedManager

-(void) cacheAsyncWithUrl:(NSString *) url callback:(id<GMDataCachedManagerCallback>)callback{

    self.callback = callback;
    self.cachedData = [GMDataCache currentCacheWithDelegate:self];
    self.cachedUri = [self.cachedData cachedDataUriForKey:url];
    if (self.cachedUri != nil) {
        [self alreadyHaveURICached];
        return;
    }
    
    GMDataConnection *connection = [[GMDataConnection alloc] initWithURL:[NSURL URLWithString:url] delegate:self];
    [connection startDownloadTask];
}

-(void) didReceiveData:(NSData *) data forUrl:(NSString *) url{
    [self.cachedData setData:data forKey:url];
}

-(void) alreadyHaveURICached{
    [self.callback dataReceived:self.cachedUri];
}

-(void) didUpdateCacheDictionaryWithURI:(NSURL *)uri{
    self.cachedUri = uri;
    [self.callback dataReceived:self.cachedUri];
}

@end
