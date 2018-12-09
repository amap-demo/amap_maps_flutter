import 'package:flutter/material.dart';

import 'package:amap_maps_flutter/amap_maps_flutter.dart';

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


  AMapController mapController;

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
                  width: 200.0,
                  height: 200.0,
                  child: AMap(
                    onMapCreated: onMapCreated,
                  ))),
          Row(children: <Widget>[
            FlatButton(
              child: Text("移动到北京"),
              onPressed: () {
                if (mapController != null) {
                  mapController.changeCamera(CameraPosition(
                      target: LatLng(39.893927, 116.405972),
                      zoom: 10
                  ), _isAnimation);
                }
              },),
            _isAnimationButton(),
          ],),

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



}
