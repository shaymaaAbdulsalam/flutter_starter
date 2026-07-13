import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_starter/core/helpers/paginated_result.dart';
import 'package:flutter_starter/core/helpers/result.dart';
import 'package:flutter_starter/data/dio_factory.dart';
import 'package:flutter_starter/data/dto/dto.dart';

class BaseRepo {
  final DioFactory dioFactory;
  BaseRepo({required this.dioFactory});

  static final shouldLogout = BehaviorSubject<bool>.seeded(false);

  void onInvalidToken() => shouldLogout.add(true);

  Result<T> handleResponse<T>(dynamic result) {
    try {
      if (result == null) {
        return const Result.failure('Something went wrong');
      }
      if (result?.status != true) {
        return handleErrorResponse<T>(result);
      }
      if (T == bool) {
        return Result.success(true as T);
      }
      return Result.success(result?.data as T);
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return const Result.failure('Something went wrong');
    }
  }

  Result<T> handleMappedResponse<T, D extends Dto<T>>(
    dynamic result,
    D Function(Map<String, dynamic> json) fromJson,
  ) {
    try {
      if (result == null) {
        return const Result.failure('Something went wrong');
      }
      if (result?.status != true) {
        return handleErrorResponse<T>(result);
      }
      final json = result?.data;
      if (json == null) {
        return const Result.failure('Something went wrong');
      }
      return Result.success(fromJson(json as Map<String, dynamic>).toModel());
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return const Result.failure('Something went wrong');
    }
  }

  Result<List<T>> handleMappedListResponse<T, D extends Dto<T>>(
    dynamic result,
    D Function(Map<String, dynamic> json) fromJson,
  ) {
    try {
      if (result == null) {
        return const Result.failure('Something went wrong');
      }
      if (result?.status != true) {
        return handleErrorResponse(result);
      }
      final json = (result?.data as List).cast<Map<String, dynamic>>();
      return Result.success(
        json.map(fromJson).map((dto) => dto.toModel()).toList(),
      );
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return const Result.failure('Something went wrong');
    }
  }

  PaginatedResult<T> handleMappedPaginatedResult<T, D extends Dto<T>>(
    dynamic result,
    D Function(Map<String, dynamic> json) fromJson,
  ) {
    try {
      if (result == null) {
        return const PaginatedResult.failure('Something went wrong');
      }

      if (result?.status != true) {
        if (result?.error != null) {
          return PaginatedResult.failure(result?.error?.message);
        }
        return const PaginatedResult.failure('Something went wrong');
      }
      final json = (result?.data as List).cast<Map<String, dynamic>>();
      final items = json.map(fromJson).map((dto) => dto.toModel()).toList();
      return PaginatedResult.success(items, result?.total ?? 0);
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return const PaginatedResult.failure('Something went wrong');
    }
  }

  Result<T> handleErrorResponse<T>(dynamic result) {
    try {
      if (result?.error != null) {
        return Result.failure(result?.error?.message);
      }
    } catch (e) {
      return const Result.failure('Something went wrong');
    }
    return const Result.failure('Something went wrong');
  }
}
