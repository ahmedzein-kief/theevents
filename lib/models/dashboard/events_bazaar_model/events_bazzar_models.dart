class EventsBazaarModels {
  EventsBazaarModels({this.error, this.data, this.message});

  EventsBazaarModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  Null message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.list, this.isMulti});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <EventList>[];
      json['list'].forEach((v) {
        list!.add(EventList.fromJson(v));
      });
    }
    isMulti = json['is_multi'];
  }
  List<EventList>? list;
  bool? isMulti;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['is_multi'] = isMulti;
    return data;
  }
}

class EventList {
  EventList({this.label, this.value, this.title});

  EventList.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    title = json['title'];
  }
  String? label;
  String? value;
  String? title;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    data['title'] = title;
    return data;
  }
}
