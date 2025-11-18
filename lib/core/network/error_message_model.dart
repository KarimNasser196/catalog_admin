import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final int status;
  final String errorMessage;
  final Map<String, List<String>>? validationErrors;

  const ErrorMessageModel({
    required this.status,
    required this.errorMessage,
    this.validationErrors,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    String errorMsg = 'An error occurred';
    Map<String, List<String>>? validationErrors;

    try {
      // Laravel validation errors format: {"message": "...", "errors": {...}}
      if (json['errors'] != null && json['errors'] is Map) {
        final errors = json['errors'] as Map<String, dynamic>;
        validationErrors = {};

        // Parse each field's errors
        errors.forEach((key, value) {
          if (value is List) {
            validationErrors![key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            validationErrors![key] = [value];
          }
        });

        // Build a comprehensive error message
        if (validationErrors.isNotEmpty) {
          List<String> allErrors = [];

          validationErrors.forEach((field, messages) {
            for (var message in messages) {
              allErrors.add(message);
            }
          });

          if (allErrors.isNotEmpty) {
            errorMsg = allErrors.join('\n');
          }
        }

        // Use the main message if available
        if (json['message'] != null && json['message'].toString().isNotEmpty) {
          final mainMessage = json['message'].toString();
          // If main message doesn't contain "and X more errors", use it as is
          if (!mainMessage.contains('and') &&
              !mainMessage.contains('more errors')) {
            errorMsg = mainMessage;
          }
        }
      }
      // Simple message format: {"message": "..."}
      else if (json['message'] != null) {
        errorMsg = json['message'].toString();
      }
      // If there's just an error field
      else if (json['error'] != null) {
        errorMsg = json['error'].toString();
      }
    } catch (e) {
      errorMsg = json['message']?.toString() ?? 'An unexpected error occurred';
    }

    return ErrorMessageModel(
      status: json['statusCode'] ?? json['status'] ?? -1,
      errorMessage: errorMsg,
      validationErrors: validationErrors,
    );
  }

  /// Get formatted error message for display
  String getDisplayMessage() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      List<String> formattedErrors = [];

      validationErrors!.forEach((field, messages) {
        for (var message in messages) {
          // Clean up field name for display
          // String fieldName = field
          //     .replaceAll('_', ' ')
          //     .replaceAll('user name', 'username')
          //     .trim();

          // Format with emoji based on field type
          String emoji = _getEmojiForField(field);
          formattedErrors.add('$emoji $message');
        }
      });

      return formattedErrors.join('\n');
    }

    return errorMessage;
  }

  /// Get appropriate emoji for field type
  String _getEmojiForField(String field) {
    if (field.contains('email')) return '📧';
    if (field.contains('phone')) return '📱';
    if (field.contains('password')) return '🔐';
    if (field.contains('user') || field.contains('name')) return '👤';
    if (field.contains('date') || field.contains('birth')) return '📅';
    return '⚠️';
  }

  /// Check if this is a "already taken" error
  bool get isAlreadyTakenError {
    return errorMessage.toLowerCase().contains('already been taken');
  }

  /// Check if this is a validation error
  bool get isValidationError {
    return validationErrors != null && validationErrors!.isNotEmpty;
  }

  @override
  List<Object?> get props => [status, errorMessage, validationErrors];
}
