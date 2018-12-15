#import "AmapMapsFlutterPlugin.h"
#import "AMapFactory.h"

@implementation AmapMapsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    AMapFactory* aMapFactory = [[AMapFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:aMapFactory withId:@"plugins.flutter.maps.amap.com/amap_maps_flutter"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
