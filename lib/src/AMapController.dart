
part of amap_maps_flutter;

class AMapController {

  static final String CHANNEL = "plugins.flutter.maps.amap.com/amap_maps_flutter";

  final int _id;

  AMapController._(this._id) : assert(_id != null)
  , _channel = new MethodChannel(CHANNEL+_id.toString());

  final MethodChannel _channel;

  static AMapController init(int id) {
    assert(id != null);
      return AMapController._(id);
  }


  /// 地图操作
  void changeCamera(CameraPosition cameraPosition, bool isAnimate) {
    if(_channel != null) {
      _channel.invokeMethod("changeCamera",[cameraPosition._toMap(), isAnimate]);
    }
  }


  /// 回调监听


  /// 覆盖物添加

  /// 工具转换

}