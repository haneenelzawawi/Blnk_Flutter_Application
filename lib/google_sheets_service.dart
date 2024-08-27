import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class GoogleSheetsService {
  final _scopes = [sheets.SheetsApi.spreadsheetsScope];

   Future<AutoRefreshingAuthClient> _getAuthClientDrive() async {
  // Load credentials from JSON file
  final jsonString = await rootBundle.loadString('assets/credentials/drive_credentials.json');
  final credentials = json.decode(jsonString);

  final clientId = ClientId(
    credentials['web']['client_id'],
    credentials['web']['client_secret'],
  );
  
  final scopes = ['https://www.googleapis.com/auth/drive'];

  // Get the authentication URL for user consent (you'll need to handle this)
  final authClient = await clientViaUserConsent(clientId, scopes, (url) {
    // Open the URL in a browser for user consent
    print('Please go to the following URL and grant access:');
    print('  => $url');
  });

  return authClient;
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
  final authClient = await _getAuthClientDrive();
  final driveApi = drive.DriveApi(authClient);
  
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
}
