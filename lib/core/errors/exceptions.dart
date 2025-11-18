import 'dart:developer';
import 'package:catalog_admin/core/network/error_message_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorMessageModel errorMessageModel;
  ServerException({required this.errorMessageModel});
}

class LocalDatabaseException implements Exception {
  final String message;
  LocalDatabaseException(this.message);
}

Never handleDioExceptions(DioException e) {
  log("DioException caught: ${e.type}, message: ${e.message}");

  ErrorMessageModel buildErrorModel(Response? response, {String? fallback}) {
    if (response?.data != null) {
      try {
        // If response data is already a Map
        if (response!.data is Map<String, dynamic>) {
          return ErrorMessageModel.fromJson(response.data);
        }
        // If response data is a String (sometimes happens), try to parse it
        else if (response.data is String) {
          log("Response data is String: ${response.data}");
          return ErrorMessageModel(
            status: response.statusCode ?? -1,
            errorMessage: response.data.toString(),
          );
        }
      } catch (parseError) {
        log("Error parsing response: $parseError");
        return ErrorMessageModel(
          status: response?.statusCode ?? -1,
          errorMessage: fallback ?? "Failed to parse error response",
        );
      }
    }

    return ErrorMessageModel(
      status: response?.statusCode ?? -1,
      errorMessage: fallback ?? "Unexpected error occurred",
    );
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback:
              "Connection timeout. Please check your internet connection.",
        ),
      );
    case DioExceptionType.sendTimeout:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Send timeout. Please try again.",
        ),
      );
    case DioExceptionType.receiveTimeout:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Receive timeout. Please try again.",
        ),
      );
    case DioExceptionType.badCertificate:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Bad certificate. Please contact support.",
        ),
      );
    case DioExceptionType.cancel:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Request cancelled.",
        ),
      );
    case DioExceptionType.connectionError:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Connection error. Please check your internet connection.",
        ),
      );
    case DioExceptionType.unknown:
      throw ServerException(
        errorMessageModel: buildErrorModel(
          e.response,
          fallback: "Unknown error. Please try again.",
        ),
      );
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Bad request. Please check your input.",
            ),
          );
        case 401:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Unauthorized. Please login again.",
            ),
          );
        case 403:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Forbidden. You don't have permission.",
            ),
          );
        case 404:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Not found. Please try again.",
            ),
          );
        case 409:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Conflict. Data already exists.",
            ),
          );
        case 422:
          // Laravel validation errors
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Validation failed. Please check your input.",
            ),
          );
        case 500:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Server error. Please try again later.",
            ),
          );
        case 504:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback: "Gateway timeout. Please try again.",
            ),
          );
        default:
          throw ServerException(
            errorMessageModel: buildErrorModel(
              e.response,
              fallback:
                  "Error ${e.response?.statusCode ?? 'unknown'}. Please try again.",
            ),
          );
      }
  }
}
