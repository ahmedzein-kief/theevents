import 'package:flutter/cupertino.dart';

class DigitalLinksModel {
  bool isSaved;
  String fileName;
  String fileLink;
  String size;
  String unit;

  TextEditingController fileNameController;
  TextEditingController fileLinkController;
  TextEditingController sizeController;

  DigitalLinksModel({
    bool? isSaved,
    String? fileName,
    String? fileLink,
    String? size,
    String? unit,
  })  : isSaved = isSaved ?? false,
        fileName = fileName ?? '',
        fileLink = fileLink ?? '',
        size = size ?? '',
        fileNameController = TextEditingController(text: fileName),
        fileLinkController = TextEditingController(text: fileLink),
        sizeController = TextEditingController(text: size),
        unit = unit ?? '';

  @override
  String toString() {
    return 'DigitalLinksModel{isSaved: $isSaved, fileName: $fileName, fileLink: $fileLink, size: $size, unit: $unit, fileNameController: $fileNameController, fileLinkController: $fileLinkController, sizeController: $sizeController}';
  }
}

extension DigitalLinksModelExtension on DigitalLinksModel {
  Map<String, dynamic> toJson() => {
        'name': fileName,
        'link': fileLink,
        'size': size,
        'unit': unit,
      };
}
