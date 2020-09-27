import 'package:flutter/material.dart';
import 'package:amap_maps_flutter/amap_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AMap Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter AMap Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // 动态申请定位权限
    requestPermission();
  }

  AMapController mapController;

  Marker currentMarker;

  bool _isAnimation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          Center(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  width: 400.0,
                  height: 400.0,
                  child: AMap(
                    onMapCreated: onMapCreated,
                  ))),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text("移动到北京"),
                onPressed: () {
                  if (mapController != null) {
                    mapController.changeCamera(
                        CameraPosition(
                            target: LatLng(39.893927, 116.405972), zoom: 10),
                        _isAnimation);
                  }
                },
              ),
              _isAnimationButton(),
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text("添加Marker"),
                onPressed: () {
                  if (mapController != null) {
                    MarkerOptions options = MarkerOptions.defaultOptions;

                    mapController.addMarker(options).then((marker) {
                      setState(() {
                        currentMarker = marker;
                      });
                    });
                  }
                },
              ),
              FlatButton(
                child: Text("修改位置"),
                onPressed: () {
                  if (mapController != null) {
                    if (currentMarker != null) {
                      //fixme 如果默认值不一样如何更新
                      MarkerOptions markerOptions = MarkerOptions(
                          position: LatLng(
                              currentMarker.options.position.latitude,
                              currentMarker.options.position.longitude +
                                  0.001));
                      mapController.updateMarker(currentMarker, markerOptions);
                    } else {
                      print("currentMarker is null");
                    }
                  }
                },
              ),
              FlatButton(
                child: Text("显示位置"),
                onPressed: () {
                  if (mapController != null) {
                    mapController.setShowUserLocation(true);
                  }
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text("添加Polyline"),
                onPressed: () {
                  if (mapController != null) {
                    MarkerOptions options = MarkerOptions.defaultOptions;
                    mapController.addMarker(options);
                  }
                },
              ),
            ],
          ),
        ]));
  }

  Widget _isAnimationButton() {
    return FlatButton(
      child: Text('${_isAnimation ? '关闭' : '开启'} 动画'),
      onPressed: () {
        setState(() {
          _isAnimation = !_isAnimation;
        });
      },
    );
  }

  void onMapCreated(AMapController controller) {
    print("onMapCreated");
    mapController = controller;

    // 注册监听
    mapController.onMapLoaded.add(onMapLoaded);
    mapController.onCameraChanged.add(onCameraChanged);
  }

  void onMapLoaded(argument) {
    print("onMapLoaded");
  }

  void onCameraChanged(CameraPosition cameraPostion) {
    print("onCameraChanged " + onCameraChanged.toString());
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
