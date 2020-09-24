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
#import "Constants.h"

static bool toBool(id json);
static int toInt(id json);
static double toDouble(id json);
static float toFloat(id json);
static double toDouble(id json);
static CLLocationCoordinate2D toLocation(id json);
static MAMapStatus* toMapStatus(id json);


@implementation AMapController {
    
    MAMapView * _mapView;
    FlutterMethodChannel* _channel;
    
    NSObject<FlutterPluginRegistrar>* _registrar;
    
    // 覆盖物记录
    NSMutableDictionary* _annotations;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    if ([super init]) {
        
        NSString* channelName = [NSString stringWithFormat:@"%@%lld", CHANNEL,viewId];
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
        
        _annotations =[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    NSLog(@"AMapController onMethodCall %s" , call.method);
    
    if ([call.method isEqualToString:MEHTOD_NAME_AMAP_CHANGE_CAMERA]) {
        MAMapStatus* mapStauts = toMapStatus(call.arguments[0]);
        BOOL isAnimate = toBool(call.arguments[1]);
        [self changeCamera:mapStauts animated:isAnimate];
        result(nil);
    } else if ([call.method isEqualToString:MEHTOD_NAME_AMAP_ADD_MARKER]) {
        NSDictionary* options = call.arguments[@"options"];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = toLocation(options[@"position"]);
        
        [_mapView addAnnotation:pointAnnotation];
        
        NSString* markerId = @"1";
        
        [_annotations setObject:pointAnnotation forKey:markerId];
        
        result(markerId);
    }  else if ([call.method isEqualToString:MEHTOD_NAME_AMAP_UPDATE_MARKER]) {
        NSDictionary* options = call.arguments[@"options"];
        NSString* markerId = call.arguments[@"marker"];
        
        MAPointAnnotation *pointAnnotation = _annotations[markerId];
        if (pointAnnotation != nil) {
            
            [pointAnnotation setCoordinate:CLLocationCoordinate2DMake(
             [pointAnnotation coordinate].latitude, [pointAnnotation coordinate].longitude + 0.01
             )];
        }
        
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
    
}

-(UIView *)view {
    return _mapView;
}

//// 操作地图的方法

- (void)changeCamera:(MAMapStatus *)cameraPosition animated: (BOOL)isAnimate {
    if(cameraPosition != nil) {
        [_mapView setMapStatus:cameraPosition animated:isAnimate];
    }
}

@end



static bool toBool(id json) {
    NSNumber* data = json;
    return data.boolValue;
}

static int toInt(id json) {
    NSNumber* data = json;
    return data.intValue;
}

static double toDouble(id json) {
    NSNumber* data = json;
    return data.doubleValue;
}

static float toFloat(id json) {
    NSNumber* data = json;
    return data.floatValue;
}

static CLLocationCoordinate2D toLocation(id json) {
    NSArray* data = json;
    return CLLocationCoordinate2DMake(toDouble(data[0]), toDouble(data[1]));
}

static CGPoint toPoint(id json) {
    NSArray* data = json;
    return CGPointMake(toDouble(data[0]), toDouble(data[1]));
}

static MAMapStatus* toMapStatus(id json) {
    NSDictionary* data = json;
    return [MAMapStatus statusWithCenterCoordinate:toLocation(data[@"target"]) zoomLevel:toFloat(data[@"zoom"]) rotationDegree:toFloat(data[@"bearing"]) cameraDegree:toFloat(data[@"tilt"]) screenAnchor:CGPointMake(0.5,0.5)];
}
