
part of amap_maps_flutter;

/// bitmap 描述信息
/// 在高德地图API 里，如果需要将一张图片绘制为Marker，需要用这个类把图片包装成对象，可以通过BitmapDescriptorFactory
/// 获得一个BitmapDescriptor 对象。
class BitmapDescriptor {
  const BitmapDescriptor._(this._json);

  static const double HUE_RED = 0.0;
  static const double HUE_ORANGE = 30.0;
  static const double HUE_YELLOW = 60.0;
  static const double HUE_GREEN = 120.0;
  static const double HUE_CYAN = 180.0;
  static const double HUE_AZURE = 210.0;
  static const double HUE_BLUE = 240.0;
  static const double HUE_VIOLET = 270.0;
  static const double HUE_MAGENTA  = 300.0;
  static const double HUE_ROSE = 330.0;

  /// 创建默认的marker 图标的 bitmap 描述信息对象。
  static const BitmapDescriptor defaultMarker =
  BitmapDescriptor._(<dynamic>['defaultMarker']);

  /// API 提供了10 个颜色的Marker 图标，用户可以通过此方法传入值来调用。请参见本类的常量。
  static BitmapDescriptor defaultMarkerWithHue(double hue) {
    assert(0.0 <= hue && hue < 360.0);
    return BitmapDescriptor._(<dynamic>['defaultMarker', hue]);
  }

  /// 根据 asset 目录内资源名称，创建 bitmap 描述信息对象。
  static BitmapDescriptor fromAsset(String assetName, {String package}) {
    if (package == null) {
      return BitmapDescriptor._(<dynamic>['fromAsset', assetName]);
    } else {
      return BitmapDescriptor._(<dynamic>['fromAsset', assetName, package]);
    }
  }

  final dynamic _json;

  dynamic _toJson() => _json;
}
