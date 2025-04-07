import 'package:pfm_sdk_flutter/method_channel/pfm_sdk_flutter_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An implementation of [EqualSdkFlutterPlatform] that uses method channels.
class MethodChannelEqualSdkFlutter extends EqualSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('equal_sdk_flutter');
}
