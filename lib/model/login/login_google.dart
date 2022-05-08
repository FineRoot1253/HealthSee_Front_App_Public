import 'package:google_sign_in/google_sign_in.dart';
import 'package:heathee/controller/account_controller.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;

class GoogleLogin {
  GoogleSignInAccount _currentUser;
  String _contactText;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignIn get getGoogleSignin => this._googleSignIn;

  Future<void> handleGetContact() async {
    _contactText = "Loading contact info...";
    print(_contactText);
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      _contactText = "People API gave a ${response.statusCode} "
          "response. Check logs for details.";
      print(_contactText);
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    if (namedContact != null) {
      _contactText = "I see you know $namedContact!";
    } else {
      _contactText = "No contacts to display.";
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      AccountController.to.storePlatformData(
          _currentUser.email, 'google', _currentUser.displayName);
    } catch (error) {
      print(error);
    }
  }
}
