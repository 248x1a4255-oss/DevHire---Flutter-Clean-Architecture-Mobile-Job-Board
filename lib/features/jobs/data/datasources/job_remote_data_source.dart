import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/job_model.dart';
import '../../domain/repositories/job_repository.dart';

abstract class JobRemoteDataSource {
  Future<List<JobModel>> fetchJobs({JobFilterParams? filterParams});
  Future<JobModel> fetchJobById(String id);
  Future<Map<String, dynamic>> submitApplicationRemote(Map<String, dynamic> payload);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<JobModel>> fetchJobs({JobFilterParams? filterParams}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (filterParams?.searchQuery != null && filterParams!.searchQuery!.isNotEmpty) {
        queryParameters['q'] = filterParams.searchQuery;
      }
      if (filterParams?.minSalary != null) {
        queryParameters['min_salary'] = filterParams!.minSalary;
      }

      final response = await dio.get(
        '/api/v1/jobs',
        queryParameters: queryParameters,
        options: Options(
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data.map((json) => JobModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          message: 'Failed to retrieve jobs from remote server',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'Remote endpoint connection timed out.');
      }
      throw ServerException(
        message: e.message ?? 'Unknown server communication error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<JobModel> fetchJobById(String id) async {
    try {
      final response = await dio.get('/api/v1/jobs/$id');
      if (response.statusCode == 200) {
        return JobModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Job not found', statusCode: 404);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> submitApplicationRemote(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post('/api/v1/applications', data: payload);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(message: 'Application submission failed.');
    }
  }
}
