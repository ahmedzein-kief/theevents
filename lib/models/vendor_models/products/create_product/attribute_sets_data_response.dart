import 'dart:convert';

AttributeSetsDataResponse attributeSetsDataResponseFromJson(String str) =>
    AttributeSetsDataResponse.fromJson(json.decode(str));

class AttributeSetsDataResponse {
  AttributeSetsDataResponse({
    required this.data,
    required this.error,
  });

  factory AttributeSetsDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      AttributeSetsDataResponse(
        data: List<AttributeSetsData>.from(
            json['data'].map((x) => AttributeSetsData.fromJson(x))),
        error: json['error'],
      );

  List<AttributeSetsData> data;
  bool error;
}

class AttributeSetsData {
  AttributeSetsData({
    required this.attributes,
    required this.id,
    required this.title,
  });

  factory AttributeSetsData.fromJson(Map<dynamic, dynamic> json) =>
      AttributeSetsData(
        attributes: List<Attribute>.from(
            json['attributes'].map((x) => Attribute.fromJson(x))),
        id: json['id'],
        title: json['title'],
      );

  List<Attribute> attributes;
  int id;
  String title;
}

class Attribute {
  Attribute({
    required this.attributeSetId,
    required this.id,
    required this.title,
    required this.slug,
  });

  factory Attribute.fromJson(Map<dynamic, dynamic> json) => Attribute(
        attributeSetId: json['attribute_set_id'],
        id: json['id'],
        title: json['title'],
        slug: json['slug'],
      );

  int attributeSetId;
  int id;
  String title;
  String slug;
}
