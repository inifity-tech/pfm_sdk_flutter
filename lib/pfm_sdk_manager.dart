import 'package:pfm_sdk_flutter/model/pfm_sdk_params.dart';
import 'package:pfm_sdk_flutter/model/event_response.dart';

class PFMSDKManager {
  static const String PROD_PFM_APP_URL = 'https://pfm.equal.in';
  static const String UAT_PFM_APP_URL = 'https://uat.pfm.equal.in';

  String _getEqualDomain(PFMSDKConfig equalSDKConfig) =>
      equalSDKConfig.env.contains('production') ? PROD_PFM_APP_URL : UAT_PFM_APP_URL;

  Future<String?> getGatewayURL(
      PFMSDKConfig equalSDKConfig, Function(EventResponse) onError) async {
    try {

      final String equalDomain = _getEqualDomain(equalSDKConfig);

      final Map<String, String> queryParams = {
        'access_token': equalSDKConfig.token,
      };

      final Uri iframeUri = Uri.parse(equalDomain + '/pfm')
          .replace(queryParameters: queryParams);

      return iframeUri.toString();
    } catch (e) {
      const errorMessage =
          'Unable to load the pfm due to a technical error. Please try again.';
      onError(EventResponse(status: 'ON_ERROR', message: errorMessage));
      return null;
    }
  }
}
