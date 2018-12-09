


part of amap_maps_flutter;


/**
 * 地图创建完成回调
 */
typedef void AMapCreatedCallback(AMapController controller);

class AMap extends StatefulWidget{

  const AMap({this.onMapCreated,this.gestureRecognizers});

  final AMapCreatedCallback onMapCreated;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State<StatefulWidget> createState() => _AMapState();

}


class _AMapState  extends State<AMap> {


  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'options': null,
    };

    // 使用原生view进行展示
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: AMapController.CHANNEL,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: AMapController.CHANNEL,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  void onPlatformViewCreated(int id) {
    final AMapController controller = AMapController.init(id);

    if(widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }
}