import 'package:pfm_sdk_flutter/helper/web_view_settings_helper.dart';
import 'package:pfm_sdk_flutter/model/event_response.dart';
import 'package:pfm_sdk_flutter/view/i_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PFMInAppWebViewWidget extends IWebView {
  final ValueNotifier<InAppWebViewController?> _webViewController =
      ValueNotifier(null);

  PFMInAppWebViewWidget({
    required super.initialUrl,
    required super.onClosed,
    required super.onError,
  });

  // SDK Event Handling
  void _handleSdkEvents(String url, BuildContext context) {
    try {
      final uri = Uri.parse(url);
      if (url.contains('/close')) {
        final message = uri.queryParameters['message'];
        final status = uri.queryParameters['status'];
        final statusCode = uri.queryParameters['status_code'];
        if (status == "ERROR") {
          onError.call(
            EventResponse(
                    status: 'ERROR',
                    message: message,
                    eventType: "PFM_SDK_CALLBACK",
                    statusCode: statusCode)
                .toJson(),
          );
        } else if (url.contains('CLOSED')) {
          onClosed.call(EventResponse(
                  status: 'CLOSED',
                  message: message,
                  eventType: "PFM_SDK_CALLBACK",
                  statusCode: statusCode)
              .toJson());
        }
      }
    } catch (e) {
      onError.call(
        EventResponse(
                status: 'ERROR',
                eventType: "PFM_SDK_CALLBACK",
                message: e.toString())
            .toJson(),
      );
    } finally {
      Navigator.pop(context);
    }
  }

  // Exit Confirmation Dialog
  Future<void> _showExitDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              onError.call(
                EventResponse(
                  status: 'CLOSED',
                ).toJson(),
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  final GlobalKey _webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                key: _webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
                initialSettings: getWebViewOptions(),
                onWebViewCreated: (controller) {
                  _webViewController.value = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url.toString();
                  print("Redirection URL ---->$url");
                  if (url.contains('/pfm/close')) {
                    _handleSdkEvents(url, context);
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
