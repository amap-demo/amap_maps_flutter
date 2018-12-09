
part of amap_maps_flutter;

class AMapController {

  static final String CHANNEL = "plugins.flutter.maps.amap.com/amap_maps_flutter";

  final int _id;

  AMapController._(this._id) : assert(_id != null)
  , _channel = new MethodChannel(CHANNEL+_id.toString())
  {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final MethodChannel _channel;

  static AMapController init(int id) {
    assert(id != null);
      return AMapController._(id);
  }



  /// 地图状态发生变化的监听接口。
  final ArgumentCallbacks<CameraPosition> onCameraChanged = ArgumentCallbacks<CameraPosition>();

  /// 地图状态发生变化的监听接口。
  final ArgumentCallbacks onMapLoaded = ArgumentCallbacks();



  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'amap#onMapLoaded':
        onMapLoaded.call(null);
        break;
      case 'amap#onCameraChange':
        CameraPosition cameraPosition = CameraPosition.fromMap(call.arguments['position']);
        onCameraChanged.call(cameraPosition);
        break;
      default:
        throw MissingPluginException();
    }
  }



  /// 地图操作
  void changeCamera(CameraPosition cameraPosition, bool isAnimate) {
    if(_channel != null) {
      _channel.invokeMethod("changeCamera",[cameraPosition._toMap(), isAnimate]);
    }
  }





  /// 覆盖物添加

  /// 工具转换

}