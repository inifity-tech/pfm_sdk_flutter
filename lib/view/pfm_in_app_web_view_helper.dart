import 'package:pfm_sdk_flutter/model/event_response.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PFMInAppWebViewWidget extends StatefulWidget {
  final String initialUrl;
  final Function(dynamic) onClosed;
  final Function(dynamic) onError;

  PFMInAppWebViewWidget({
    required this.initialUrl,
    required this.onClosed,
    required this.onError,
  });

  @override
  State<PFMInAppWebViewWidget> createState() => _PFMInAppWebViewWidgetState();
}

class _PFMInAppWebViewWidgetState extends State<PFMInAppWebViewWidget> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/pfm/close')) {
              _handleSdkEvents(request.url, context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
    super.initState();
  }

  // SDK Event Handling
  void _handleSdkEvents(String url, BuildContext context) {
    try {
      final uri = Uri.parse(url);
      if (url.contains('/close')) {
        final message = uri.queryParameters['message'];
        final status = uri.queryParameters['status'];
        final statusCode = uri.queryParameters['status_code'];
        if (status == "ERROR") {
          widget.onError.call(
            EventResponse(
                    status: 'ERROR',
                    message: message,
                    eventType: "PFM_SDK_CALLBACK",
                    statusCode: statusCode)
                .toJson(),
          );
        } else if (url.contains('CLOSED')) {
          widget.onClosed.call(EventResponse(
                  status: 'CLOSED',
                  message: message,
                  eventType: "PFM_SDK_CALLBACK",
                  statusCode: statusCode)
              .toJson());
        }
      }
    } catch (e) {
      widget.onError.call(
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
              widget.onError.call(
                EventResponse(
                  status: 'CLOSED',
                ).toJson(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog(context);
      },
      child: WebViewWidget(controller: controller),
    );
  }
}
