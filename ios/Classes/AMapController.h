//
//  AMapController.h
//  Pods
//
//  Created by zxy on 2018/12/15.
//

#import <Flutter/Flutter.h>

@interface AMapController : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
viewIdentifier:(int64_t)viewId
arguments:(id _Nullable)args
registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

