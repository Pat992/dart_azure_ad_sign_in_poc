import 'package:dart_azure_ad_sign_in/dart_azure_ad_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Initialize AzureSignIn
  final azureSignIn = AzureSignIn(port: 8080);
  // Token instance for later usage
  late Token token;
  // Some variables to show in the app
  bool isSignIn = false;
  int status = 0;
  String error = '';
  String errorDesc = '';
  String activeFrom = '0';
  String activeTo = '0';
  String authToken = '';
  String refToken = '';

  // Function to get a new token
  Future<void> getToken() async {
    // Check if can launch URL
    if (await canLaunchUrl(Uri.parse(azureSignIn.signInUri))) {
      // Launch sign-in page in browser
      await launchUrl(Uri.parse(azureSignIn.signInUri));
      // Start the sign-in process
      token = await azureSignIn.signIn();
      // Call function to set fields
      tokenToFields();
    }
  }

  // Cancel a sign-in process
  Future<void> cancelGetToken() async {
    await azureSignIn.cancelSignIn();
  }

  // Refresh an existing token
  Future<void> refreshToken() async {
    token = await azureSignIn.refreshToken(token: token);
    tokenToFields();
  }

  // Set fields with generated token
  void tokenToFields() {
    setState(() {
      status = token.status;
      error = token.error;
      errorDesc = token.errorDescription;
      activeFrom = token.notBefore != '' ? token.notBefore : '0';
      activeTo = token.expiresOn != '' ? token.expiresOn : '0';
      authToken = token.accessToken;
      refToken = token.refreshToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In to Azure')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: getToken,
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: cancelGetToken,
                  child: const Text('Cancel Sign In'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: refreshToken,
                  child: const Text('Refresh Token'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(status.toString()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Error: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(error),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Error Description: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(child: Text(errorDesc)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Token active from: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                                (int.tryParse(activeFrom) ?? 0) * 1000)
                            .toString(),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Token active to: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                                (int.tryParse(activeTo) ?? 0) * 1000)
                            .toString(),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Auth Token: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          authToken,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Refresh Token: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(child: Text(refToken)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
