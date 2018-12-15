//
//  NSObject+AMapFactory.h
//  amap_maps_flutter
//
//  Created by zxy on 2018/12/15.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>

@interface AMapFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end
