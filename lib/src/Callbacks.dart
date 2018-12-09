
part of amap_maps_flutter;

/// 带参数回调
typedef void ArgumentCallback<T>(T argument);

/// 带参数回调
class ArgumentCallbacks<T> {
  final List<ArgumentCallback<T>> _callbacks = <ArgumentCallback<T>>[];

  /// 依次调用回调中各方法
  void call(T argument) {
    final int length = _callbacks.length;
    if (length == 1) {
      _callbacks[0].call(argument);
    } else if (0 < length) {
      for (ArgumentCallback<T> callback
      in List<ArgumentCallback<T>>.from(_callbacks)) {
    callback(argument);
    }
  }
  }

  /// 注册监听
  void add(ArgumentCallback<T> callback) {
    assert(callback != null);
    _callbacks.add(callback);
  }

  /// 移除监听
  void remove(ArgumentCallback<T> callback) {
    _callbacks.remove(callback);
  }

  /// 判断是否为空
  bool get isEmpty => _callbacks.isEmpty;

  /// 判断是否不是空
  bool get isNotEmpty => _callbacks.isNotEmpty;
}
