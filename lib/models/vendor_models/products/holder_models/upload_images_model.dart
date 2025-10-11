import 'dart:io';

import 'package:dio/dio.dart';

class UploadImagesModel {
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

  @override
  String toString() => 'UploadImagesModel(File: $file, Filename: $fileName, Extension: $fileExtension,'
      'ServerUrl; $serverUrl, ServerFullUrl: $serverFullUrl, ServerName: $serverName,ServerBaseName: $serverBaseName,'
      'ServerID: $serverID, Uploaded $uploaded)';
}

extension ConvertToMultipartFile on UploadImagesModel {
  MultipartFile toMultipartFile() => MultipartFile.fromFileSync(
        file.path,
        filename: fileName,
      );
}
