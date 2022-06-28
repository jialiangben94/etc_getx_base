import 'dart:convert';

class Label {
  final String key;
  final String enValue;
  final String bmValue;
  final String cnValue;

  Label({this.key, this.enValue, this.bmValue, this.cnValue});

  factory Label.fromMap(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Label(
      key: json['key'],
      enValue: json['en'],
      bmValue: json['bm'],
      cnValue: json['cn'],
    );
  }

  static List<Label> listFromJson(List json) {
    if (json == null) return null;
    List<Label> list = [];
    for (var item in json) {
      list.add(Label.fromJson(item));
    }
    return list;
  }

  @override
  String toString() {
    return 'Label(key: $key, enValue: $enValue, bmValue: $bmValue, cnValue: $cnValue)';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'en': enValue});
    result.addAll({'bm': bmValue});
    result.addAll({'cn': cnValue});

    return result;
  }

  String toJson() => json.encode(toMap());

  factory Label.fromJson(String source) => Label.fromMap(json.decode(source));
}
