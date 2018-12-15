//
//  NSObject+AMapFactory.m
//  amap_maps_flutter
//
//  Created by zxy on 2018/12/15.
//

#import "AMapFactory.h"
#import "AMapController.h"


@implementation AMapFactory {
    NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    return [[AMapController alloc] initWithFrame:frame
                                          viewIdentifier:viewId
                                               arguments:args
                                               registrar:_registrar];
}

@end



