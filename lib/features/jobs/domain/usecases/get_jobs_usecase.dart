import '../../../../core/usecases/usecase.dart';
import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetJobsUseCase implements UseCase<List<Job>, JobFilterParams?> {
  final JobRepository repository;

  GetJobsUseCase(this.repository);

  @override
  Future<List<Job>> call(JobFilterParams? params) async {
    return await repository.getJobs(filterParams: params);
  }
}
