import 'dart:io';

import 'package:dart_azure_ad_sign_in/dart_azure_ad_sign_in.dart';
import 'package:dart_azure_ad_sign_in/src/dart_azure_ad_sign_in_base.dart';

Future<void> main(List<String> arguments) async {
  // Create instance of Azure SignIn, all parameters are optional.
  final azureSignIn = AzureSignIn(port: 5050);

  // Print the SignIn URL.
  print(azureSignIn.authUri);

  // Let the user to open the URL and signing in
  // can also b cancelled with azureSignIn.cancelSignIn();
  Token token = await azureSignIn.signIn();

  // Print the token information
  printToken(token: token, title: 'Initial Token');

  // refresh an expired token
  token = await azureSignIn.refreshToken(token: token);

  // Print the updated token information
  printToken(token: token, title: 'Refreshed Token');

  // wait for input
  print('Press any key to exit');
  stdin.readLineSync();
}

void printToken({required Token token, required String title}) {
  print(
      '------------------------------------------------------------------------------------------------------------------------------------');
  print(title);
  print(
      '------------------------------------------------------------------------------------------------------------------------------------');
  print('Status: ${token.status}');
  print('Error: ${token.error}');
  print('Error Message: ${token.errorDescription}');
  print('Refresh Token:');
  print(token.accessToken);
  print('Refresh Token:');
  print(token.accessToken);
}
