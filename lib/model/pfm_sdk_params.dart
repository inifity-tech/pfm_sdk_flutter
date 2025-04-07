class PFMSDKConfig {
  final String token;
  final String env;

  PFMSDKConfig({
    required this.token, 
    String? env,
  }) : env = env ?? "pre-prod";
}
