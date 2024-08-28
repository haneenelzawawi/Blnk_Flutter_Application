import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
//import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:io' show Platform;

class GoogleSheetsService {
  final _scopes = [sheets.SheetsApi.spreadsheetsScope];

  final FlutterAppAuth appAuth = FlutterAppAuth();

  final String clientId_Web = '976143728678-6uapv1m8hmuqd35oo2rtd45j459ko9i6.apps.googleusercontent.com';
  final String clientId_ios = '976143728678-cgptbj49gd86a03j82uu5fji66ddkl8a.apps.googleusercontent.com';
  final String clientId_android ='976143728678-cr4ju97p2nn36hruu10ebmtofqm1cj9t.apps.googleusercontent.com';
  final String clientSecret = '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';
  final String redirectUrl = 'https://blnkdomain.com/oauth2redirect';
  final String redirectUrl2 = 'com.blnk.myapp:/oauth2redirect'; 
  final List<String> scopes = ['https://www.googleapis.com/auth/drive'];

Future<AuthClient?>  authenticate() async {
  try {
    
      // Mobile authentication (Android/iOS)
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Platform.isAndroid ? clientId_android : clientId_ios,
          redirectUrl2,
          discoveryUrl:
              'https://accounts.google.com/.well-known/openid-configuration',
          scopes: <String>[
            'https://www.googleapis.com/auth/drive.file',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        ),
      );

      if (result != null) {
        // Handle mobile authentication result
        print('Access Token: ${result.accessToken}');
         final DateTime expirationTime = DateTime.now().add(Duration(hours: 1));
      final AccessCredentials credentials = AccessCredentials(
        AccessToken(result.tokenType!, result.accessToken!, expirationTime),
        result.refreshToken,
        result.scopes!,
      );

      return authenticatedClient(http.Client(), credentials);
      } else {
        print('Authentication failed.');
        return null;
      }
    
  } catch (e) {
    print('Error during authentication: $e');
    return null;
  }
}



  
  Future<AutoRefreshingAuthClient> _getAuthClient() async {
    // Load credentials from JSON file
    final credentials = json.decode(await rootBundle.loadString('assets/credentials/your_credentials.json'));

    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    return client;
  }

  

  Future<void> insertData(List<List<dynamic>> data, String spreadsheetId, String range) async {
    final authClient = await _getAuthClient();
    final sheetsApi = sheets.SheetsApi(authClient);

    final valueRange = sheets.ValueRange(values: data);
    
    try {
      await sheetsApi.spreadsheets.values.append(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
      print('Data inserted successfully!');
    } catch (e) {
      print('Error inserting data: $e');
    } finally {
      authClient.close();
    }
  }

 

  Future<void> uploadImage(File? image, String folderId, String imageName) async {
  final authClient = await authenticate();
  if (authClient != null) {
    
    print('Authentication succeeded.');
    final driveApi = drive.DriveApi(authClient as http.Client);
    if(driveApi !=null){
      
      print('Drive Authentication succeeded.');
      if(image !=null){
    final fileExtension = image.uri.pathSegments.last.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
    var media = drive.Media(image.openRead(), image.lengthSync());
    var driveFile = drive.File()
      ..name = imageName
      ..parents = [folderId];
    
    await driveApi.files.create(driveFile, uploadMedia: media);
    print('Uploaded $imageName to Google Drive');
  } else {
    print('The selected file is not an image.');
  }
  }else{
    print('No Image Added');
  }
    }
    else{
      print('Authentication failed.');
    }
  } else {
    print('Authentication failed.');
  }
  
  
  }
}
