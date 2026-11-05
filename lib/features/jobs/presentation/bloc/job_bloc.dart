import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/apply_job_usecase.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/usecases/toggle_save_job_usecase.dart';
import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobsUseCase getJobsUseCase;
  final ToggleSaveJobUseCase toggleSaveJobUseCase;
  final ApplyJobUseCase applyJobUseCase;

  JobBloc({
    required this.getJobsUseCase,
    required this.toggleSaveJobUseCase,
    required this.applyJobUseCase,
  }) : super(const JobsInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<RefreshJobsEvent>(_onRefreshJobs);
    on<FilterJobsEvent>(_onFilterJobs);
    on<ToggleSaveJobEvent>(_onToggleSaveJob);
    on<ApplyToJobEvent>(_onApplyToJob);
  }

  Future<void> _onLoadJobs(LoadJobsEvent event, Emitter<JobState> emit) async {
    emit(const JobsLoading(loadingMessage: 'Loading career opportunities...'));
    try {
      final jobs = await getJobsUseCase(event.filterParams);
      final featured = jobs.where((j) => j.isFeatured).toList();
      final recent = jobs.where((j) => !j.isFeatured).toList();

      emit(JobsLoaded(
        allJobs: jobs,
        featuredJobs: featured.isNotEmpty ? featured : jobs.take(3).toList(),
        recentJobs: recent.isNotEmpty ? recent : jobs.skip(3).toList(),
        activeFilters: event.filterParams,
      ));
    } catch (e) {
      emit(JobsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshJobs(RefreshJobsEvent event, Emitter<JobState> emit) async {
    if (state is JobsLoaded) {
      final currentFilters = (state as JobsLoaded).activeFilters;
      try {
        final jobs = await getJobsUseCase(currentFilters);
        final featured = jobs.where((j) => j.isFeatured).toList();
        final recent = jobs.where((j) => !j.isFeatured).toList();

        emit(JobsLoaded(
          allJobs: jobs,
          featuredJobs: featured.isNotEmpty ? featured : jobs.take(3).toList(),
          recentJobs: recent.isNotEmpty ? recent : jobs.skip(3).toList(),
          activeFilters: currentFilters,
        ));
      } catch (e) {
        emit(JobsError(message: 'Pull to refresh failed: \${e.toString()}'));
      }
    } else {
      add(const LoadJobsEvent());
    }
  }

  Future<void> _onFilterJobs(FilterJobsEvent event, Emitter<JobState> emit) async {
    emit(const JobsLoading(loadingMessage: 'Applying search filters...'));
    try {
      final jobs = await getJobsUseCase(event.filterParams);
      final featured = jobs.where((j) => j.isFeatured).toList();
      final recent = jobs.where((j) => !j.isFeatured).toList();

      emit(JobsLoaded(
        allJobs: jobs,
        featuredJobs: featured,
        recentJobs: recent,
        activeFilters: event.filterParams,
      ));
    } catch (e) {
      emit(JobsError(message: 'Filter application failed.'));
    }
  }

  Future<void> _onToggleSaveJob(ToggleSaveJobEvent event, Emitter<JobState> emit) async {
    if (state is JobsLoaded) {
      final currentState = state as JobsLoaded;
      try {
        final newSavedStatus = await toggleSaveJobUseCase(event.jobId);
        
        final updatedAll = currentState.allJobs.map((j) {
          if (j.id == event.jobId) {
            return j.copyWith(isSaved: newSavedStatus);
          }
          return j;
        }).toList();

        emit(currentState.copyWith(
          allJobs: updatedAll,
          featuredJobs: updatedAll.where((j) => j.isFeatured).toList(),
          recentJobs: updatedAll.where((j) => !j.isFeatured).toList(),
        ));
      } catch (_) {
        // Maintain UI consistency
      }
    }
  }

  Future<void> _onApplyToJob(ApplyToJobEvent event, Emitter<JobState> emit) async {
    if (state is JobsLoaded) {
      final currentState = state as JobsLoaded;
      try {
        final submittedApp = await applyJobUseCase(event.application);
        emit(currentState.copyWith(lastSubmittedApplication: submittedApp));
      } catch (e) {
        emit(JobsError(message: e.toString()));
      }
    }
  }
}
