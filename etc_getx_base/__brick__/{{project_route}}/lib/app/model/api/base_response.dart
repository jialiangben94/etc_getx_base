import 'dart:convert';

class BaseResponse<T> {
  String message;
  T data;
  List<T> datas;
  BaseResponse({this.message, this.data, this.datas});

  BaseResponse<T> copyWith({String message, T data, List<T> datas}) {
    return BaseResponse<T>(
        message: message ?? this.message,
        data: data ?? this.data,
        datas: datas ?? this.datas);
  }

  Map<String, dynamic> toMap() {
    return {'message': message};
  }

  factory BaseResponse.fromMap(
      Map<String, dynamic> map,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList) {
    return BaseResponse<T>(
        message: map['message'] ?? '',
        data: (create != null && map['data'] != null)
            ? create(map['data'])
            : null,
        datas: (createList != null && map != null) ? createList(map) : []);
  }

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromJson(
          String source, Function(Map<String, dynamic>) create,
          {Function(Map<String, dynamic>) createList}) =>
      BaseResponse.fromMap(json.decode(source), create, createList);

  @override
  String toString() => 'BaseResponse(message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseResponse<T> &&
        other.message == message &&
        other.data == data &&
        other.datas == datas;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode ^ datas.hashCode;
}
