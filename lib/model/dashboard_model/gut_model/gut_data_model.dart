class GutDataModel {
  String? data;
  String? value;

  GutDataModel({this.data, this.value});

  GutDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    value = json['value'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['value'] = this.value;
    return data;
  }
}