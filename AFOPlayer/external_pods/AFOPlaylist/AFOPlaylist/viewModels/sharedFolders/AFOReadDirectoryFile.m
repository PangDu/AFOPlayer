//
//  AFOReadDirectoryFile.m
//  AFOPlayer
//
//  Created by zhao yun on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOReadDirectoryFile.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFODirectoryWatcher.h"

static BOOL AFOPLIsSupportedVideoFileName(NSString *fileName) {
    if (fileName.length == 0) {
        return NO;
    }
    if ([fileName hasPrefix:@"."] || [fileName containsString:@".nosync"]) {
        return NO;
    }
    static NSSet<NSString *> *extensions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        extensions = [NSSet setWithArray:@[@"mp4", @"mov", @"m4v", @"avi", @"mkv", @"flv", @"wmv", @"3gp", @"ts", @"m2ts"]];
    });
    NSString *ext = fileName.pathExtension.lowercaseString;
    return [extensions containsObject:ext];
}

@interface AFOReadDirectoryFile ()<DirectoryWatcherDelegate>
@property (nonnull, nonatomic, strong) NSMutableArray       *fileArray;
@property (nonnull, nonatomic, strong) AFODirectoryWatcher  *directoryWatcher;
@property (nonatomic, weak) id<AFOReadDirectoryFileDelegate> delegate;
@end

@implementation AFOReadDirectoryFile
#pragma mark ------------ init
+ (AFOReadDirectoryFile *)readDirectoryFiledelegate:(id)directoryDelegate{
    AFOReadDirectoryFile *directoryFile = NULL;
    if (directoryDelegate != NULL){
        AFOReadDirectoryFile *tempManager = [[AFOReadDirectoryFile alloc] init];
        tempManager.delegate = directoryDelegate;
        [tempManager settingDirectoryWatcher];
        directoryFile = tempManager;
    }
    return directoryFile;
}
#pragma mark ------------
- (void)settingDirectoryWatcher{
    self.directoryWatcher = [AFODirectoryWatcher watchFolderWithPath:[NSFileManager documentSandbox] delegate:self];
    [self directoryDidChange:self.directoryWatcher];
}
#pragma mark ------------ DirectoryWatcherDelegate
- (void)directoryDidChange:(AFODirectoryWatcher *)directoryWatcher {
    [self.fileArray removeAllObjects];
    NSString *documentsDirectoryPath = [NSFileManager documentSandbox];
    NSArray *documentsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath
                                                                                              error:NULL];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString* curFileName in [documentsDirectoryContents objectEnumerator]) {
            NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
            BOOL isDirectory;
            [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isDirectory && AFOPLIsSupportedVideoFileName(curFileName)){
                [self.fileArray addObjectAFOAbnormal:curFileName];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate directoryFromDocument:self.fileArray];
        });
    });
}
#pragma mark ------------ property
- (NSMutableArray *)fileArray{
    if (!_fileArray) {
        _fileArray = [[NSMutableArray alloc] init];
    }
    return _fileArray;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOReadDirectoryFile dealloc");
}
@end
