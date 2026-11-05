import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/job_application.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_local_data_source.dart';
import '../datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final JobLocalDataSource localDataSource;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Job>> getJobs({JobFilterParams? filterParams}) async {
    try {
      // Dual-datasource strategy: Try remote API first
      final remoteJobs = await remoteDataSource.fetchJobs(filterParams: filterParams);
      // Cache latest records locally
      await localDataSource.cacheJobs(remoteJobs);
      // Re-read with bookmark states applied
      return await localDataSource.getCachedJobs(filterParams: filterParams);
    } on NetworkException {
      // Seamless offline fallback
      return await localDataSource.getCachedJobs(filterParams: filterParams);
    } on ServerException {
      // On backend fault, serve local cached copy
      return await localDataSource.getCachedJobs(filterParams: filterParams);
    } catch (e) {
      // In worst-case fallback, local cache ensures zero downtime
      try {
        return await localDataSource.getCachedJobs(filterParams: filterParams);
      } catch (cacheError) {
        throw const CacheFailure(message: 'Unable to access local offline storage.');
      }
    }
  }

  @override
  Future<Job> getJobById(String id) async {
    try {
      final cachedList = await localDataSource.getCachedJobs();
      final match = cachedList.firstWhere(
        (j) => j.id == id,
        orElse: () => throw CacheException(message: 'Job not found in local cache'),
      );
      return match;
    } catch (_) {
      try {
        return await remoteDataSource.fetchJobById(id);
      } catch (e) {
        throw ServerFailure(message: 'Job with ID $id could not be found.');
      }
    }
  }

  @override
  Future<bool> toggleSaveJob(String id) async {
    return await localDataSource.toggleSavedJob(id);
  }

  @override
  Future<List<Job>> getSavedJobs() async {
    final allJobs = await localDataSource.getCachedJobs();
    final savedIds = await localDataSource.getSavedJobIds();
    return allJobs.where((j) => savedIds.contains(j.id)).toList();
  }

  @override
  Future<JobApplication> submitApplication(JobApplication application) async {
    final payload = {
      'id': application.id,
      'jobId': application.jobId,
      'jobTitle': application.jobTitle,
      'companyName': application.companyName,
      'fullName': application.fullName,
      'email': application.email,
      'phone': application.phone,
      'portfolioLink': application.portfolioLink,
      'coverLetter': application.coverLetter,
      'resumeFileName': application.resumeFileName,
      'appliedAt': application.appliedAt.toIso8601String(),
      'status': application.status.name,
    };

    // Save locally immediately
    await localDataSource.saveApplication(payload);

    try {
      // Sync to remote API
      await remoteDataSource.submitApplicationRemote(payload);
    } catch (_) {
      // Queued locally for background sync
    }

    return application;
  }

  @override
  Future<List<JobApplication>> getSubmittedApplications() async {
    final list = await localDataSource.getSavedApplications();
    return list.map((json) {
      return JobApplication(
        id: json['id'] as String,
        jobId: json['jobId'] as String,
        jobTitle: json['jobTitle'] as String,
        companyName: json['companyName'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        portfolioLink: json['portfolioLink'] as String?,
        coverLetter: json['coverLetter'] as String?,
        resumeFileName: json['resumeFileName'] as String,
        appliedAt: DateTime.parse(json['appliedAt'] as String),
      );
    }).toList();
  }
}
