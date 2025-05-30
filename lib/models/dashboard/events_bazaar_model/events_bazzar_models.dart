class EventsBazaarModels {
  bool? error;
  Data? data;
  Null message;

  EventsBazaarModels({this.error, this.data, this.message});

  EventsBazaarModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<EventList>? list;
  bool? isMulti;

  Data({this.list, this.isMulti});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <EventList>[];
      json['list'].forEach((v) {
        list!.add(new EventList.fromJson(v));
      });
    }
    isMulti = json['is_multi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['is_multi'] = this.isMulti;
    return data;
  }
}

class EventList {
  String? label;
  String? value;
  String? title;

  EventList({this.label, this.value, this.title});

  EventList.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['title'] = this.title;
    return data;
  }
}
