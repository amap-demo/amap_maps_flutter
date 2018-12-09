part of amap_maps_flutter;

/// 存储经纬度坐标值的类，单位角度。
class LatLng {
  const LatLng(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        latitude =
        (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  ///  纬度 (垂直方向)
  final double latitude;

  /// 经度 (水平方向)
  final double longitude;


  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);


  /// 传递到平台的时候更方便
  dynamic _toJson() {
    return <double>[latitude, longitude];
  }

  static LatLng _fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLng(json[0], json[1]);
  }

}


/// 代表了经纬度划分的一个矩形区域。
class LatLngBounds {

  ///
  /// 使用传入的西南角坐标和东北角坐标创建一个矩形区域。
  ///
  /// @param southwest 西南角坐标。
  /// @param northeast 东北角坐标。
  ///
  LatLngBounds({@required this.southwest, @required this.northeast})
      : assert(southwest != null),
        assert(northeast != null),
        assert(southwest.latitude <= northeast.latitude);

  final LatLng southwest;

  final LatLng northeast;

  /// 传递到平台的时候更方便
  dynamic _toList() {
    return <dynamic>[southwest._toJson(), northeast._toJson()];
  }


  @override
  String toString() {
    return '$runtimeType($southwest, $northeast)';
  }

  @override
  bool operator ==(Object o) {
    return o is LatLngBounds &&
        o.southwest == southwest &&
        o.northeast == northeast;
  }

  @override
  int get hashCode => hashValues(southwest, northeast);
}