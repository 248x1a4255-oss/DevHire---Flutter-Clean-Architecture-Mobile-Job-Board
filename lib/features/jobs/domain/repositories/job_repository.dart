import '../entities/job.dart';
import '../entities/job_application.dart';

class JobFilterParams {
  final String? searchQuery;
  final List<JobType>? jobTypes;
  final List<LocationType>? locationTypes;
  final double? minSalary;
  final String? locationQuery;

  const JobFilterParams({
    this.searchQuery,
    this.jobTypes,
    this.locationTypes,
    this.minSalary,
    this.locationQuery,
  });
}

abstract class JobRepository {
  Future<List<Job>> getJobs({JobFilterParams? filterParams});
  Future<Job> getJobById(String id);
  Future<bool> toggleSaveJob(String id);
  Future<List<Job>> getSavedJobs();
  Future<JobApplication> submitApplication(JobApplication application);
  Future<List<JobApplication>> getSubmittedApplications();
}
