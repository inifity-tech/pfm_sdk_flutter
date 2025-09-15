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
        "exchange_application_id": "pfm.equal.tata_amc_uat",
        "user_profile": {
          "mobile_number": mobile_number,
          "name": "Dummy name",
          "dob": "18-01-1990",
          "pan": "RQNPS9280W"
        }
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
                      pfmSdkConfig: PFMSDKConfig(token: token),
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
