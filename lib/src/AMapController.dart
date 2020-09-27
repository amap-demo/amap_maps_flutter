part of amap_maps_flutter;

class AMapController extends ChangeNotifier {
  static const String CHANNEL =
      "plugins.flutter.maps.amap.com/amap_maps_flutter";

  static const String METHOD_NAME_CALLBACK_AMAP_ON_MAP_LOADED =
      "amap#onMapLoaded";
  static const String METHOD_NAME_CALLBACK_AMAP_ON_CAMERA_CHANGE =
      "amap#onCameraChange";
  static const String MEHTOD_NAME_AMAP_CHANGE_CAMERA = "amap#changeCamera";
  static const String MEHTOD_NAME_AMAP_ADD_MARKER = "amap#addMarker";
  static const String MEHTOD_NAME_AMAP_UPDATE_MARKER = "amap#updateMarker";
  static const String METHOD_NAME_AMAP_SHOW_USER_LOCATION =
      "amap#showUserLocation";

  final int _id;

  AMapController._(this._id)
      : assert(_id != null),
        _channel = new MethodChannel(CHANNEL + _id.toString()) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final MethodChannel _channel;

  static AMapController init(int id) {
    assert(id != null);
    return AMapController._(id);
  }

  /// 地图状态发生变化的监听接口。
  final ArgumentCallbacks<CameraPosition> onCameraChanged =
      ArgumentCallbacks<CameraPosition>();

  /// 地图状态发生变化的监听接口。
  final ArgumentCallbacks onMapLoaded = ArgumentCallbacks();

  /// Marker集合
  Set<Marker> get markers => Set<Marker>.from(_markers.values);
  final Map<String, Marker> _markers = <String, Marker>{};

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case METHOD_NAME_CALLBACK_AMAP_ON_MAP_LOADED:
        onMapLoaded.call(null);
        break;
      case METHOD_NAME_CALLBACK_AMAP_ON_CAMERA_CHANGE:
        CameraPosition cameraPosition =
            CameraPosition.fromMap(call.arguments['position']);
        onCameraChanged.call(cameraPosition);
        break;
      default:
        throw MissingPluginException();
    }
  }

  /// 地图操作
  void changeCamera(CameraPosition cameraPosition, bool isAnimate) {
    if (_channel != null) {
      _channel.invokeMethod(
          MEHTOD_NAME_AMAP_CHANGE_CAMERA, [cameraPosition._toMap(), isAnimate]);
    }
  }

  /// 覆盖物添加
  Future<Marker> addMarker(MarkerOptions options) async {
    final MarkerOptions effectiveOptions =
        MarkerOptions.defaultOptions.copyWith(options);
    final String markerId = await _channel.invokeMethod(
      MEHTOD_NAME_AMAP_ADD_MARKER,
      <String, dynamic>{
        'options': effectiveOptions._toJson(),
      },
    );
    final Marker marker = Marker(markerId, effectiveOptions);
    _markers[markerId] = marker;
    notifyListeners();

    return marker;
  }

  ///
  /// 更新Marker内容 转换成内容，各平台再根据id去更新
  ///
  Future<void> updateMarker(Marker marker, MarkerOptions changes) async {
    assert(marker != null);
    assert(_markers[marker._id] == marker);
    assert(changes != null);
    await _channel
        .invokeMethod(MEHTOD_NAME_AMAP_UPDATE_MARKER, <String, dynamic>{
      'marker': marker._id,
      'options': changes._toJson(),
    });
    marker._options = marker._options.copyWith(changes);

    notifyListeners();
  }

  /// 是否显示位置
  void setShowUserLocation(bool showUserLocation) {
    if (_channel != null) {
      _channel.invokeMethod(
          METHOD_NAME_AMAP_SHOW_USER_LOCATION, showUserLocation);
    }
  }

  ///
  /// 工具转换

}
