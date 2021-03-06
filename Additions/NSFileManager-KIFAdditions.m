//
//  NSFileManager-KIFAdditions.m
//  KIF
//
//  Created by Michael Thole on 6/1/11
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "NSFileManager-KIFAdditions.h"
#import "LoadableCategory.h"


MAKE_CATEGORIES_LOADABLE(NSFileManager_KIFAdditions)


@implementation NSFileManager (CCAdditions)

#pragma mark Public Methods

- (NSString *)createUserDirectory:(NSSearchPathDirectory)searchPath;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);
    if (!paths.count) {
        return nil;
    }
    
    NSString *rootDirectory = [paths objectAtIndex:0];

    BOOL isDir;
    BOOL created = NO;
    if ([self fileExistsAtPath:rootDirectory isDirectory:&isDir] && isDir) {
        created = YES;
    } else {
        created = [self recursivelyCreateDirectory:rootDirectory];
    }

    return created ? rootDirectory : nil;
}

- (BOOL)recursivelyCreateDirectory:(NSString *)path;
{
    BOOL isDir = NO;
    BOOL isParentADir = NO;
    NSString *parentDir = nil;

    if (![self fileExistsAtPath:path isDirectory:&isDir]) {
        // if file doesn't exist, first create parent
        parentDir = [path stringByDeletingLastPathComponent];

        if (!parentDir.length || [parentDir isEqualToString:@"/"]) {
            isParentADir = YES;
        } else {
            isParentADir = [self recursivelyCreateDirectory:parentDir];
        }

        if (isParentADir) {
            isDir = [self createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        } else {
            return NO;
        }
    }

    return isDir;
}

@end
