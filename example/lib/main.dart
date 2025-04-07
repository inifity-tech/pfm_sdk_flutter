import 'dart:convert';

import 'package:pfm_sdk_flutter/pfm_sdk_flutter.dart';
import 'package:pfm_sdk_flutter/model/pfm_sdk_params.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext buildContext, _, ScreenType type) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
        ),
        home: HomePage(),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _mobile_number;
  late TextEditingController _refID;

  final ValueNotifier<dynamic> _sdkResponse = ValueNotifier('');

  static const String PROD_APP_URL = 'https://api.equal.in';

  static const String TEST_APP_URL = 'https://api-uat.pfm.equal.in';

  String _getEqualDomain() => TEST_APP_URL;

  Future<String?> getAccessToken(String mobile_number, String refID) async {
    try {
      final String equalDomain = _getEqualDomain();

      final Map<String, Object> bodyParams = {
        "reference_id": refID,
        "exchange_application_id": "pfm.equal.pidg_testing",
        "user_profile": {"mobile_number": mobile_number}
      };

      // Basic Authentication credentials
      const String username =
          'equal.business.3532351c-6152-4b89-9fe3-14f2c8fcb5a5#6c3a650d-d90e-4456-bf5c-79890fdf8112'; // Replace with your username
      const String password =
          'aDRhhDTH5vdcBl1gMQh9GgIHifmRCnE_xLTceuRVSRbq5ptDgMRGU_3Gxi-vf3pZGWscXxusofi6Xig8GDqUbQ=='; // Replace with your password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      final response = await http.post(
        Uri.parse('$equalDomain/pfm/sdk/init'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(bodyParams), // Convert bodyParams to JSON
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
            jsonDecode(response.body); // Parse the response body
        return responseBody['session_token'];
      } else {
        print('Failed to load: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      const errorMessage =
          'Unable to load the pfm due to a technical error. Please try again.';
      print(errorMessage);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _mobile_number = TextEditingController(text: '');
    _refID = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _mobile_number,
                decoration: const InputDecoration(
                    label: Text("mobile number"), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _refID,
                decoration: const InputDecoration(
                    label: Text("unique ref id"), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String token = await getAccessToken(
                            _mobile_number.text, _refID.text) ??
                        "";
                    PFMSDK.instance.launchSDK(
                      context: context,
                      pfmSdkConfig: PFMSDKConfig(
                        token:
                            "eyJhbGciOiJSUzI1NiJ9.eyJ0cmFuc2FjdGlvbl9pZCI6ImQ0Yzg5OTFjLWI5ZjAtNDU0OS05YjNmLWE3M2Y5YzkwNjRlNSIsImlzcyI6Imh0dHBzOi8vcGZtLmVxdWFsLmluIiwiZXhwIjoxNzQ0NjA3NTk3LCJyZXF1ZXN0X2lkIjoiNDYyNTFkYTctZjNjNi00YjcxLWJlODItNTQ3NzRkYTk3OTg4IiwiaWF0IjoxNzQ0MDA3NTk3fQ.VR-GhEfC6y4Xs4IO4nl9VE_YcFT6Yvs82YaaZXs6SW7d4D5MFCKMlyirzyQ58oKYoxvd1rM1rAYBcuoA6f5QArbCONhNMooB8850uknn6MempMU_B5faZhheTv1dZDtv0ixoic8LwyIJk_g5wiZh24iW1yTaDLOxzLF8MGef8ZHwjdCbV5_G0aVWQ29_FDRcUXjawAoNHVCbTgYr-zUhIRSD5CLDymOREjCrwMIeW1aR2li9wD3lbZIz1EoG520Ua9RAUfrB3raJKy4_QjlC5KX9HQc7tQDXnexRG-3Y7iiZLUo-E5HgDcIyg3dpVdnI3eZU7j_D1nrt3xNrmZMVUA",
                      ),
                      onClosed: (data) {
                        _sdkResponse.value = data;
                      },
                      onError: (data) {
                        _sdkResponse.value = data;
                      },
                    );
                  },
                  child: const Text('Launch SDK'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ValueListenableBuilder(
                valueListenable: _sdkResponse,
                builder: (_, __, ___) => Text(_sdkResponse.value.isNotEmpty
                    ? "SDK Response is ${_sdkResponse.value}"
                    : ''),
              )
            ],
          ),
        ),
      ),
    );
  }
}
