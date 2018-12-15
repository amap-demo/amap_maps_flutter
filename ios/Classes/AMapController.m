//
//  AMapController.m
//  amap_maps_flutter
//
//  Created by zxy on 2018/12/15.
//

#import <Foundation/Foundation.h>
#import "AMapController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


@implementation AMapController {
    
    MAMapView * _mapView;
    FlutterMethodChannel* _channel;
    
    NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    if ([super init]) {
    
        NSString* channelName =
        [NSString stringWithFormat:@"plugins.flutter.maps.amap.com/amap_maps_flutter%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                               binaryMessenger:registrar.messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            if (weakSelf) {
                [weakSelf onMethodCall:call result:result];
            }
        }];
        _mapView =  [[MAMapView alloc] initWithFrame:frame];
        _registrar = registrar;
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"AMapController onMethodCall " , call.method);
}

-(UIView *)view {
    return _mapView;
}

@end

