//
//  AFOPLMainListViewModelTests.m
//  AFOPlaylistTests
//

#import <XCTest/XCTest.h>
#import "AFOPLMainListViewModel.h"
#import "AFOPLPlaylistRoutingDataSource.h"
#import "AFOPLMainListViewState.h"
#import <AFORouter/AFORouting.h>

@interface AFOPLPlaylistRoutingDataSourceStub : NSObject <AFOPLPlaylistRoutingDataSource>
@property (nonatomic, copy) NSString *stubPath;
@property (nonatomic, copy) NSString *stubName;
@property (nonatomic, assign) UIInterfaceOrientationMask stubMask;
@property (nonatomic, assign) NSUInteger stubItemCount;
@end

@implementation AFOPLPlaylistRoutingDataSourceStub

- (NSString *)vedioAddressIndexPath:(NSIndexPath *)indexPath {
    return self.stubPath;
}

- (NSString *)vedioNameIndexPath:(NSIndexPath *)indexPath {
    return self.stubName;
}

- (UIInterfaceOrientationMask)orientationMask:(NSIndexPath *)indexPath {
    return self.stubMask;
}

- (NSUInteger)playlistItemCount {
    return self.stubItemCount;
}

@end

@interface AFOPLMainListViewModelTests : XCTestCase
@end

@implementation AFOPLMainListViewModelTests

- (void)testOpenPlayerProducesExpectedRouteParameters {
    AFOPLPlaylistRoutingDataSourceStub *stub = [[AFOPLPlaylistRoutingDataSourceStub alloc] init];
    stub.stubPath = @"/Documents/foo/bar.mp4";
    stub.stubName = @"bar.mp4";
    stub.stubMask = UIInterfaceOrientationMaskPortrait;

    AFOPLMainListViewModel *vm = [[AFOPLMainListViewModel alloc] initWithRoutingDataSource:stub];
    __block NSDictionary *captured = nil;
    vm.routePerformBlock = ^(NSDictionary *parameters) {
        captured = [parameters copy];
    };

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    [vm openPlayerAtIndexPath:indexPath currentControllerClassName:@"AFOPLMainController"];

    XCTAssertNotNil(captured);
    XCTAssertEqualObjects(captured[AFORouteKeyModelName], @"playlist");
    XCTAssertEqualObjects(captured[AFORouteKeyCurrent], @"AFOPLMainController");
    XCTAssertEqualObjects(captured[AFORouteKeyNext], @"AFOMediaPlayController");
    XCTAssertEqualObjects(captured[AFORouteKeyAction], @"push");
    XCTAssertEqualObjects(captured[AFORouteKeyValue], stub.stubPath);
    XCTAssertEqualObjects(captured[AFORouteKeyTitle], stub.stubName);
    XCTAssertEqualObjects(captured[AFORouteKeyDirection], @(stub.stubMask));
}

- (void)testOpenPlayerNoOpWhenDataSourceNil {
    AFOPLMainListViewModel *vm = [[AFOPLMainListViewModel alloc] initWithRoutingDataSource:nil];
    __block BOOL called = NO;
    vm.routePerformBlock = ^(NSDictionary *parameters) { called = YES; };
    [vm openPlayerAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] currentControllerClassName:@"X"];
    XCTAssertFalse(called);
}

- (void)testOpenPlayerNoOpWhenClassNameEmpty {
    AFOPLPlaylistRoutingDataSourceStub *stub = [[AFOPLPlaylistRoutingDataSourceStub alloc] init];
    AFOPLMainListViewModel *vm = [[AFOPLMainListViewModel alloc] initWithRoutingDataSource:stub];
    __block BOOL called = NO;
    vm.routePerformBlock = ^(NSDictionary *parameters) { called = YES; };
    [vm openPlayerAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] currentControllerClassName:@""];
    XCTAssertFalse(called);
}

- (void)testSyncListStateAfterReloadUpdatesItemCount {
    AFOPLPlaylistRoutingDataSourceStub *stub = [[AFOPLPlaylistRoutingDataSourceStub alloc] init];
    stub.stubItemCount = 3;
    AFOPLMainListViewModel *vm = [[AFOPLMainListViewModel alloc] initWithRoutingDataSource:stub];
    __block NSUInteger lastCount = NSNotFound;
    vm.onListStateChange = ^(AFOPLMainListViewState *state) {
        lastCount = state.itemCount;
    };
    [vm syncListStateAfterReload];
    XCTAssertEqual(lastCount, 3u);
    XCTAssertEqual(vm.listState.itemCount, 3u);
}

@end
