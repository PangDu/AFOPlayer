//
//  AFOReadDirectoryFile.m
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOReadDirectoryFile.h"
#import "AFODirectoryWatcher.h"
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
    dispatch_queue_t queue = dispatch_queue_create("com.AFOPlayer.AFOReadDirectoryFile", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (NSString* curFileName in [documentsDirectoryContents objectEnumerator]) {
            NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
            BOOL isDirectory;
            [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isDirectory){
                [self.fileArray addObjectAFOAbnormal:curFileName];
            }
        }
    });
    dispatch_async(queue, ^{
      [self.delegate directoryFromDocument:self.fileArray];
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
