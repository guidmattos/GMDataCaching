//
//  GMDataCache.h
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheUpdatedCallback

-(void) didUpdateCacheDictionaryWithURI:(NSURL *) uri;

@end

@interface GMDataCache : NSObject

@property id<CacheUpdatedCallback> callback;
@property NSMutableDictionary *cacheDictionary;
@property NSOperationQueue* diskOperationQueue;

+(GMDataCache*)currentCacheWithDelegate:(id<CacheUpdatedCallback>) callback;
-(id)initWithDelegate:(id<CacheUpdatedCallback>) callback;
-(void)setData:(NSData*)data forKey:(NSString*)key;
-(NSURL *) cachedDataUriForKey:(NSString *)key;

@end
