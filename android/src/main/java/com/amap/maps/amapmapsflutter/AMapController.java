package com.amap.maps.amapmapsflutter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.MapView;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.Marker;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

/**
 * @author zxy
 * @data 2018/12/8
 */

@TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
public class AMapController implements Application.ActivityLifecycleCallbacks, PlatformView, MethodChannel.MethodCallHandler, AMap.OnMapLoadedListener, AMap.OnCameraChangeListener, AMap.OnMarkerClickListener {

    public static final String CHANNEL = "plugins.flutter.maps.amap.com/amap_maps_flutter";
    private final Context context;
    private final AtomicInteger activityState;
    private final PluginRegistry.Registrar registrar;
    private final MethodChannel methodChannel;

    private MapView mapView;
    private AMap aMap;

    private boolean disposed = false;

    private final int registrarActivityHashCode;

    AMapController(int id, Context context,
                   AtomicInteger activityState,
                   PluginRegistry.Registrar registrar) {
        this.context = context;
        this.activityState = activityState;
        this.registrar = registrar;
        this.registrarActivityHashCode = registrar.activity().hashCode();

        registrar.activity().getApplication().registerActivityLifecycleCallbacks(this);

        methodChannel =
                new MethodChannel(registrar.messenger(), CHANNEL + id);
        methodChannel.setMethodCallHandler(this);


        mapView = new MapView(context);
        mapView.onCreate(null);

        aMap = mapView.getMap();

        initListener();


    }



    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        mapView.onDestroy();
        registrar.activity().getApplication().unregisterActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
        mapView.onCreate(savedInstanceState);
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
//        mapView.onStart();
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
        mapView.onPause();
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
//        mapView.onStop();
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
        mapView.onSaveInstanceState(outState);
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return;
        }
        mapView.onDestroy();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        switch (methodCall.method) {
            case "changeCamera":
//                setText(methodCall, result);

                List<Object> arguments = (List<Object>) methodCall.arguments;
                CameraPosition cameraPosition = Convert.toCameraPosition(arguments.get(0));
                boolean isAnimate = (boolean) arguments.get(1);


                android.util.Log.e("zxy","onMethodCall " + cameraPosition + " " + isAnimate);
                changeCamera(cameraPosition, isAnimate);

                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }



    public void changeCamera(CameraPosition cameraPosition, boolean isAnimate) {
        if(cameraPosition != null) {
            if (isAnimate) {
                aMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            } else {
                aMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            }
        }
    }



    /**
     * 注册回调监听
     */
    private void initListener() {
        aMap.setOnMapLoadedListener(this);
        aMap.setOnCameraChangeListener(this);

        //覆盖物
        aMap.setOnMarkerClickListener(this);
    }


    @Override
    public void onMapLoaded() {
        if(methodChannel != null) {
            final Map<String, Object> arguments = new HashMap<>(2);
            methodChannel.invokeMethod("camera#onMapLoaded", arguments);
        }
    }

    @Override
    public void onCameraChange(CameraPosition position) {
        if(methodChannel != null) {
            final Map<String, Object> arguments = new HashMap<>(2);
            arguments.put("position", Convert.toJson(position));
            arguments.put("isFinish", false);
            methodChannel.invokeMethod("camera#onCameraChange", arguments);
        }
    }

    @Override
    public void onCameraChangeFinish(CameraPosition position) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("position", Convert.toJson(position));
        arguments.put("isFinish", true);
        methodChannel.invokeMethod("camera#onCameraChange", arguments);
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        return false;
    }
}
