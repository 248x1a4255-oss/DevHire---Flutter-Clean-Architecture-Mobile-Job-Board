import '../../../../core/usecases/usecase.dart';
import '../repositories/job_repository.dart';

class ToggleSaveJobUseCase implements UseCase<bool, String> {
  final JobRepository repository;

  ToggleSaveJobUseCase(this.repository);

  @override
  Future<bool> call(String jobId) async {
    return await repository.toggleSaveJob(jobId);
  }
}
