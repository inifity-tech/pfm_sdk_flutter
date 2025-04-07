import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppWebViewSettings getWebViewOptions() {
  return InAppWebViewSettings(
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    userAgent:
        'Firefox/5.0 (Linux; Android 11; Nokia 8.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
    mediaPlaybackRequiresUserGesture: false,
    useShouldOverrideUrlLoading: true,
    iframeAllowFullscreen: true,
    allowsBackForwardNavigationGestures: false,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    domStorageEnabled: true,
    useHybridComposition: true,
    transparentBackground: true,
    supportZoom: false,
  );
}
