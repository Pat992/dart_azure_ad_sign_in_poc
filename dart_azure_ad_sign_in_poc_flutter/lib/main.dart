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
  final azureSignIn = AzureSignIn(port: 5000);
  late Token token;
  bool isSignIn = false;
  int status = 0;
  String error = '';
  String errorDesc = '';
  String activeFrom = '0';
  String activeTo = '0';
  String authToken = '';
  String refToken = '';

  Future<void> getToken() async {
    if (await canLaunchUrl(Uri.parse(azureSignIn.authUri))) {
      await launchUrl(Uri.parse(azureSignIn.authUri));
      token = await azureSignIn.signIn();
      tokenToFields();
    }
  }

  Future<void> cancelGetToken() async {
    await azureSignIn.cancelSignIn();
  }

  Future<void> refreshToken() async {
    token = await azureSignIn.refreshToken(token: token);
    tokenToFields();
  }

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
                      Text(errorDesc),
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
                                int.parse(activeFrom) * 1000)
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
                                int.parse(activeTo) * 1000)
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
