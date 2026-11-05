import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/job_application.dart';
import '../repositories/job_repository.dart';

class ApplyJobUseCase implements UseCase<JobApplication, JobApplication> {
  final JobRepository repository;

  ApplyJobUseCase(this.repository);

  @override
  Future<JobApplication> call(JobApplication application) async {
    // Domain validation
    if (application.fullName.trim().length < 3) {
      throw const ValidationFailure(message: 'Full Name must be at least 3 characters.');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(application.email.trim())) {
      throw const ValidationFailure(message: 'Please provide a valid email address.');
    }
    if (application.resumeFileName.isEmpty) {
      throw const ValidationFailure(message: 'Please attach a resume before submitting.');
    }

    return await repository.submitApplication(application);
  }
}
