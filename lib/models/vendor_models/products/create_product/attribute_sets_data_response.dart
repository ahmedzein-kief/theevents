import 'dart:convert';

AttributeSetsDataResponse attributeSetsDataResponseFromJson(String str) => AttributeSetsDataResponse.fromJson(json.decode(str));

class AttributeSetsDataResponse {
  AttributeSetsDataResponse({
    required this.data,
    required this.error,
  });

  List<AttributeSetsData> data;
  bool error;

  factory AttributeSetsDataResponse.fromJson(Map<dynamic, dynamic> json) => AttributeSetsDataResponse(
        data: List<AttributeSetsData>.from(json["data"].map((x) => AttributeSetsData.fromJson(x))),
        error: json["error"],
      );
}

class AttributeSetsData {
  AttributeSetsData({
    required this.attributes,
    required this.id,
    required this.title,
  });

  List<Attribute> attributes;
  int id;
  String title;

  factory AttributeSetsData.fromJson(Map<dynamic, dynamic> json) => AttributeSetsData(
        attributes: List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
        id: json["id"],
        title: json["title"],
      );
}

class Attribute {
  Attribute({
    required this.attributeSetId,
    required this.id,
    required this.title,
    required this.slug,
  });

  int attributeSetId;
  int id;
  String title;
  String slug;

  factory Attribute.fromJson(Map<dynamic, dynamic> json) => Attribute(
        attributeSetId: json["attribute_set_id"],
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
      );
}
