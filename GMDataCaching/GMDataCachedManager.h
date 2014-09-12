//
//  GMDataCachedManager.h
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMDataConnection.h"
#import "GMDataCache.h"

@protocol GMDataCachedManagerCallback

-(void) dataReceived:(NSURL *) dataUrl;

@end

@interface GMDataCachedManager : NSObject <GMDataConnectionDelegate, CacheUpdatedCallback>

@property GMDataCache *cachedData;
@property id<GMDataCachedManagerCallback> callback;

-(void) cacheAsyncWithUrl:(NSString *) url callback:(id<GMDataCachedManagerCallback>)callback;

@end
