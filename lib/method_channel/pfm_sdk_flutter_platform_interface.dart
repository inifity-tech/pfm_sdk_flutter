import 'package:pfm_sdk_flutter/method_channel/pfm_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


abstract class EqualSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a EqualSdkFlutterPlatform.
  EqualSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static EqualSdkFlutterPlatform _instance = MethodChannelEqualSdkFlutter();

  /// The default instance of [EqualSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelEqualSdkFlutter].
  static EqualSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EqualSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(EqualSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
