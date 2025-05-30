import 'dart:io';

import 'package:dio/dio.dart';

class UploadImagesModel {
  bool hasFile;
  File file;
  String fileName;
  String fileExtension;
  String serverUrl;
  String serverFullUrl;
  bool uploaded;
  int serverID;
  String serverName;
  String serverBaseName;

  UploadImagesModel({
    bool? hasFile,
    File? file,
    String? fileName,
    String? fileExtension,
    String? serverUrl,
    String? serverFullUrl,
    bool? uploaded,
    int? serverID,
    String? serverName,
    String? serverBaseName,
  })  : file = file ?? File(''),
        hasFile = hasFile ?? true,
        fileName = fileName ?? '',
        fileExtension = fileExtension ?? '',
        serverUrl = serverUrl ?? '',
        serverFullUrl = serverFullUrl ?? '',
        serverName = serverName ?? '',
        serverBaseName = serverBaseName ?? '',
        serverID = serverID ?? 0,
        uploaded = uploaded ?? false;

  @override
  String toString() {
    return 'UploadImagesModel(File: $file, Filename: $fileName, Extension: $fileExtension,'
        'ServerUrl; $serverUrl, ServerFullUrl: $serverFullUrl, ServerName: $serverName,ServerBaseName: $serverBaseName,'
        'ServerID: $serverID, Uploaded $uploaded)';
  }
}

extension convertToMultipartFile on UploadImagesModel {
  MultipartFile toMultipartFile()  {
    return MultipartFile.fromFileSync(
      file.path,
      filename: fileName,
    );
  }
}
