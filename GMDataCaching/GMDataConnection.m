//
//  GMDataConnection.m
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//

#import "GMDataConnection.h"

@interface GMDataConnection()

@property NSURL *dataURL;
@property id<GMDataConnectionDelegate> delegate;
@property NSURLSessionDataTask *downloadTask;

@end

@implementation GMDataConnection

- (id)initWithURL:(NSURL*)URL delegate:(id)delegate {
	if((self = [super init])) {
        self.dataURL = URL;
		self.delegate = delegate;
    }
	return self;
}

- (void)startDownloadTask {
    
    self.downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:self.dataURL
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              [self.delegate didReceiveData:data forUrl:[self.dataURL absoluteString]];
                                          }];
    [self.downloadTask resume];
}

- (void)suspendDownloadTask {
    [self.downloadTask suspend];
}

@end
