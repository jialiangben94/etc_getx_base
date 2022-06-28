import 'package:{{project_route}}/app/utils/constants.dart';

class RequestException implements Exception {
  final int code;
  final String errorMessage;

  RequestException(this.code, this.errorMessage);
}

/// Status Code is 400 will throw InvalidRequestException.
/// - message from server is not empty will throw error message
/// - else if message from server  is empty will not throw error message
class InvalidRequestException extends RequestException {
  InvalidRequestException({String errorMessage})
      : super(
            InvalidRequest,
            errorMessage ??
                'Something have went wrong, please try again later');
}

/// Status Code is 500
/// will throw InternalServerErrorException
class InternalServerErrorException extends RequestException {
  InternalServerErrorException({String errorMessage})
      : super(
            ServerError,
            errorMessage ??
                'Something have went wrong, please try again later');
}

/// Status Code is 401
/// will throw UnauthorizedException
class UnauthorizedException extends RequestException {
  UnauthorizedException({String errorMessage})
      : super(
            TokenExpired,
            errorMessage ??
                'Access token has expired, please proceed to login');
}

/// Status Code is 404
/// will throw NotFoundException
class NotFoundException extends RequestException {
  NotFoundException({String errorMessage})
      : super(NotFound,
            errorMessage ?? 'The requested information could not be found');
}

/// Status Code is other than status code not listed
/// will throw NoConnectionException
class NoConnectionException extends RequestException {
  NoConnectionException({String errorMessage})
      : super(
            TimeOut,
            errorMessage ??
                'No internet connection detected, please try again later.');
}

class ForceUpdateException extends RequestException {
  ForceUpdateException({String errorMessage})
      : super(
            ForceUpdate,
            errorMessage ??
                'No internet connection detected, please try again later.');
}

/// Status Code is DioErrorType sendTimeout / connectTimeout / receiveTimeout
/// will throw TimeOutException
class TimeOutException extends RequestException {
  TimeOutException({String errorMessage})
      : super(
            TimeOut,
            errorMessage ??
                'The connection has timed out, please try again later.');
}
