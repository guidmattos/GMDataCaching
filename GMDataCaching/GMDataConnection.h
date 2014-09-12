//
//  GMDataConnection.h
//  DataCaching
//
//  Created by Guilherme Duarte Mattos on 9/10/14.
//  Copyright (c) 2014 Guilherme Duarte Mattos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMDataConnectionDelegate

-(void) didReceiveData:(NSData *) data forUrl:(NSString *) url;

@end

@interface GMDataConnection : NSObject

- (id)initWithURL:(NSURL*)URL delegate:(id)delegate;
- (void)startDownloadTask;
- (void)suspendDownloadTask;

@end
