part of amap_maps_flutter;

/// 定义地图 Marker 覆盖物 Marker 是在地图上的一个点绘制图标。这个图标和屏幕朝向一致，和地图朝向无关，也不会受地图的旋转、倾斜、缩放影响。
/// 一个marker有如下属性：
///
/// 锚点：图标摆放在地图上的基准点。默认情况下，锚点是从图片下沿的中间处。
/// 位置：marker是通过经纬度的值来标注在地图上的。
/// 标题：当点击Marker 显示在信息窗口的文字，随时可以更改。
/// 片段：除了标题外其他的文字，随时可以更改。
/// 图标：Marker 显示的图标。如果未设置图标，API 将使用默认的图标，高德为默认图标提供了10 种颜色备选。默认情况下，Marker 是可见的。你们随时更改marker 的可见性。
///
///

class Marker {

  Marker(this._id, this._options);

  /// marker 唯一标识
  final String _id;

  String get id => _id;

  /// 属性集合
  MarkerOptions _options;

  MarkerOptions get options => _options;
}


dynamic _offsetToJson(Offset offset) {
  if (offset == null) {
    return null;
  }
  return <dynamic>[offset.dx, offset.dy];
}


/// Marker 的选项类。
/// 包含Marker所有的熟悉
class MarkerOptions {
  /// Marker 的选项类。
  const MarkerOptions({
    this.alpha,
    this.anchorU,
    this.anchorV,
    this.draggable,
    this.flat,
    this.icon,
    this.position,
    this.rotation,
    this.visible,
    this.zIndex,
  }) : assert(alpha == null || (0.0 <= alpha && alpha <= 1.0));


  /// 设置Marker覆盖物的透明度
  //  alpha 透明度范围[0,1] 1为不透明
  final double alpha;

  /// 设置Marker覆盖物的锚点比例。锚点是marker 图标接触地图平面的点。图标的左顶点为（0,0）点，右底点为（1,1）点。<br>
  ///
  /// 默认为（0.5,1.0）
  /// @param u 锚点水平范围的比例，建议传入0 到1 之间的数值。
  /// @param v 锚点垂直范围的比例，建议传入0 到1 之间的数值。
  final double anchorU;
  final double anchorV;

  /// 一个布尔值，表示Marker是否可拖拽，true表示可拖拽，false表示不可拖拽。
  final bool draggable;

  /// 若marker平贴在地图上返回 true；若marker面对镜头返回 false。
  final bool flat;

  /// 设置Marker覆盖物的图标。相同图案的 icon 的 Marker 最好使用同一个 BitmapDescriptor 对象以节省内存空间。
  final BitmapDescriptor icon;

  /// 设置Marker覆盖物的位置坐标。Marker经纬度坐标不能为Null，坐标无默认值。
  final LatLng position;

  /// 设置Marker覆盖物的图片旋转角度，从正北开始，逆时针计算。
  final double rotation;

  /// 设置Marker覆盖物是否可见。
  final bool visible;

  /// 设置Marker覆盖物 zIndex。
  final double zIndex;


//
//  /// 是否传递点击事件
//  final bool consumeTapEvents;
//
//  /// The icon image point that will be the anchor of the info window when
//  /// displayed.
//  ///
//  /// The image point is specified in normalized coordinates: An anchor of
//  /// (0.0, 0.0) means the top left corner of the image. An anchor
//  /// of (1.0, 1.0) means the bottom right corner of the image.
//  final Offset infoWindowAnchor;
//
//  /// Text content for the info window.
//  final InfoWindowText infoWindowText;


  /// 默认 marker options.
  static const MarkerOptions defaultOptions = MarkerOptions(
    alpha: 1.0,
    anchorU: 0.5,
    anchorV: 1.0,
    draggable: false,
    flat: false,
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.893927, 116.405972),
    rotation: 0.0,
    visible: true,
    zIndex: 0.0,
  );

  /// 根据已有属性生成
  MarkerOptions copyWith(MarkerOptions changes) {
    if (changes == null) {
      return this;
    }
    return MarkerOptions(
      alpha: changes.alpha ?? alpha,
      anchorU: changes.anchorU ?? anchorU,
      anchorV: changes.anchorV ?? anchorV,
      draggable: changes.draggable ?? draggable,
      flat: changes.flat ?? flat,
      icon: changes.icon ?? icon,
      position: changes.position ?? position,
      rotation: changes.rotation ?? rotation,
      visible: changes.visible ?? visible,
      zIndex: changes.zIndex ?? zIndex,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('alpha', alpha);
    addIfPresent('anchorU', anchorU);
    addIfPresent('anchorV', anchorV);
    addIfPresent('draggable', draggable);
    addIfPresent('flat', flat);
    addIfPresent('icon', icon?._toJson());
    addIfPresent('position', position?._toJson());
    addIfPresent('rotation', rotation);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    return json;
  }
}