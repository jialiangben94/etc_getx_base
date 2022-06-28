import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:{{project_route}}/app/model/api/base_response.dart';
import 'package:{{project_route}}/app/ui/global/global_controller.dart';
import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/services/base/exceptions.dart';
import 'package:{{project_route}}/app/utils/custom_getx.dart';
import 'package:{{project_route}}/app/utils/share_pref.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

// enum HttpMethod { get, post, put, patch, delete, multipart }
enum HeaderType { none, standard, authorized }
typedef OnSuccess = void Function(String message);
typedef OnFail = bool Function(int code, String message, dynamic data);

class BaseService {
  static final BaseService _baseService = BaseService._();
  factory BaseService() => _baseService;
  BaseService._();

  final timeoutDuration = const Duration(seconds: 60);
  static const connectErr = 'You may be experiencing connection issue';

  _response(BaseResponse response, int statusCode) {
    switch (statusCode) {
      case 200:
        return;
      case 400:
        throw InvalidRequestException(errorMessage: response.message);
      case 500:
        throw InternalServerErrorException(errorMessage: response.message);
      case 401:
        getController(GlobalController()).popUpSessionExpired(
            'Access token has expired, please proceed to login');
        throw UnauthorizedException();
      case 404:
        throw NotFoundException(errorMessage: response.message);
      case 426:
        getController(GlobalController()).popUpForceUpdate();
        throw ForceUpdateException();
      default:
        throw RequestException(statusCode, response.message);
    }
  }

  Map<String, String> _getHeader(
      HeaderType headerType, Map<String, String> additionalHeaders) {
    Map<String, String> headers = {};

    if (headerType != HeaderType.none) {
      headers.addAll({"Content-Type": "application/json"});
      headers.addAll({"App-Version": AppConstant().version});
      if (headerType == HeaderType.authorized) {
        var token = SharePref.sharePref.accessToken ?? "";
        headers.addAll({"Authorization": "Bearer $token"});
      }
    }
    if (additionalHeaders != null) {
      additionalHeaders.forEach((key, value) {
        headers.addAll({key: value});
      });
    }
    return headers;
  }

  String _getUrl(String endpoint, Map<String, String> queryParam) {
    var url = AppConstant().baseUrl + endpoint;
    if ((queryParam ?? {}).isNotEmpty) {
      var query = "";
      queryParam.forEach((key, value) {
        if (query.isEmpty) {
          query = "$key=$value";
        } else {
          query = query + "&$key=$value";
        }
      });
      url = url + "?" + query;
    }
    return url;
  }

  Future<BaseResponse<T>> getApi<T>(String endpoint, HeaderType headerType,
      {Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");

    try {
      final result = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });
      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      log("ERROR HERE");
      throw NoConnectionException();
    }
  }

  Future<BaseResponse<T>> postApi<T>(
      String endpoint, Map<String, dynamic> body, HeaderType headerType,
      {Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Request Body: ${body.toString()}");

    try {
      final result = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });

      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      throw InternalServerErrorException();
    }
  }

  Future<BaseResponse<T>> patchApi<T>(
      String endpoint, Map<String, dynamic> body, HeaderType headerType,
      {Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Request Body: ${body.toString()}");

    try {
      final result = await http
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });

      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      throw InternalServerErrorException();
    }
  }

  Future<BaseResponse<T>> putApi<T>(
      String endpoint, Map<String, dynamic> body, HeaderType headerType,
      {Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Request Body: ${body.toString()}");

    try {
      final result = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });

      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      throw InternalServerErrorException();
    }
  }

  Future<BaseResponse<T>> deleteApi<T>(
      String endpoint, Map<String, dynamic> body, HeaderType headerType,
      {Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Request Body: ${body.toString()}");
    try {
      final result = await http
          .delete(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });

      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      throw InternalServerErrorException();
    }
  }

  Future<BaseResponse<T>> multipartApi<T>(
      String endpoint, Map<String, dynamic> body, HeaderType headerType,
      {List<File> files,
      bool forceFileArray = false,
      String fileField,
      Map<String, String> additionalHeaders,
      Map<String, String> queryParam,
      Function(Map<String, dynamic>) create,
      Function(Map<String, dynamic>) createList}) async {
    String url = _getUrl(endpoint, queryParam);
    var headers = _getHeader(headerType, additionalHeaders);

    log("[Api Web] Url: $url");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Headers: ${headers.toString()}");
    log("[Api Web] Request Body: ${body.toString()}");
    log("[Api Web] Number of Files: ${files?.length?.toString() ?? "0"}");
    try {
      final multipartRequest = http.MultipartRequest('POST', Uri.parse(url));
      multipartRequest.headers.addAll(headers);
      multipartRequest.fields.addAll(body);

      if ((files?.length ?? 0) > 0) {
        if (files.length > 1 || forceFileArray) {
          for (int i = 0; i < files.length; i++) {
            File file = files[i];
            int length = await file.length();
            multipartRequest.files.add(http.MultipartFile(
              fileField + '[$i]',
              file.openRead(),
              length,
              filename: path.basename(file.path),
            ));
          }
        } else {
          File file = files[0];
          int length = await file.length();
          multipartRequest.files.add(http.MultipartFile(
            fileField,
            file.openRead(),
            length,
            filename: path.basename(file.path),
          ));
        }
      }

      var result = await http.Response.fromStream(await multipartRequest.send())
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeOutException();
      });

      log("[Api Web] Response Status Code: ${result.statusCode.toString()}");
      log("[Api Web] Response: ${jsonDecode(result.body).toString()}");

      var response =
          BaseResponse<T>.fromJson(result.body, create, createList: createList);

      _response(response, result.statusCode);

      return response;
    } on SocketException {
      throw InternalServerErrorException();
    }
  }
}
