//
//  GMDataCache.m
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//
//  Some code was inspired in EGOCache class from EGO Library.
//
//

#import "GMDataCache.h"

static NSString* _GMDataCacheDirectory;

static inline NSString* GMDataCacheDirectory() {
	if(!_GMDataCacheDirectory) {
		NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		_GMDataCacheDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"GMDataCache"] copy];
	}
	return _GMDataCacheDirectory;
}

static inline NSString* cachePathForKey(NSString* key) {
    key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [GMDataCacheDirectory() stringByAppendingPathComponent:key];
}

static GMDataCache* __instance;

@implementation GMDataCache

+(GMDataCache*)currentCacheWithDelegate:(id<CacheUpdatedCallback>) callback {
	@synchronized(self) {
		if(!__instance) {
			__instance = [[GMDataCache alloc] initWithDelegate:callback];
		}
	}
	return __instance;
}

-(id)initWithDelegate:(id<CacheUpdatedCallback>) callback {
    if((self = [super init])) {
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(@"GMDataCache.plist")];
		
		if([dict isKindOfClass:[NSDictionary class]]) {
			self.cacheDictionary = [dict mutableCopy];
		} else {
			self.cacheDictionary = [[NSMutableDictionary alloc] init];
		}
		
		self.diskOperationQueue = [[NSOperationQueue alloc] init];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:GMDataCacheDirectory()
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
        self.callback = callback;
	}
	
	return self;
}

-(BOOL) hasCacheForKey:(NSString *) key {
    return ([self.cacheDictionary objectForKey:key] != nil) ? YES : NO;
}

#pragma mark - Data methods

-(void)setData:(NSData*)data forKey:(NSString*)key {
    
    NSData* dataUsafe = data;
    NSString *fileName = [NSString stringWithFormat:@"%.0f%@",[[NSDate date] timeIntervalSince1970], [key lastPathComponent]];
    NSString* dataPath = cachePathForKey(fileName);
    
    [self.cacheDictionary setValue:dataPath forKey:key];
    
	[self writeData:dataUsafe toPath:dataPath];
	
	[self saveCacheDictionary:key];
}

-(NSURL *) cachedDataUriForKey:(NSString *)key {
    if([self hasCacheForKey:key]) {
        self.cacheDictionary = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(@"GMDataCache.plist")];
		NSString *dataPath = [self.cacheDictionary objectForKey:key];
        return [NSURL fileURLWithPath:dataPath];
	} else {
		return nil;
	}
}

-(void)saveCacheDictionary:(NSString *) key {
	@synchronized(self) {
		[self.cacheDictionary writeToFile:cachePathForKey(@"GMDataCache.plist") atomically:YES];
        NSURL *uri = [NSURL fileURLWithPath:[self.cacheDictionary objectForKey:key]];
        [self.callback didUpdateCacheDictionaryWithURI:uri];
	}
}

-(void)writeData:(NSData*)data toPath:(NSString *)path; {
    NSError *error;
    [data writeToFile:path options:NSDataWritingAtomic error:&error];
}

@end
