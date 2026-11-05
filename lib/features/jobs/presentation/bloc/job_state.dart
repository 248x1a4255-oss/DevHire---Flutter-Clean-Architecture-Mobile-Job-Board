import 'package:equatable/equatable.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/job_application.dart';
import '../../domain/repositories/job_repository.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobsInitial extends JobState {
  const JobsInitial();
}

class JobsLoading extends JobState {
  final String? loadingMessage;

  const JobsLoading({this.loadingMessage});

  @override
  List<Object?> get props => [loadingMessage];
}

class JobsLoaded extends JobState {
  final List<Job> allJobs;
  final List<Job> featuredJobs;
  final List<Job> recentJobs;
  final JobFilterParams? activeFilters;
  final bool isOffline;
  final JobApplication? lastSubmittedApplication;

  const JobsLoaded({
    required this.allJobs,
    required this.featuredJobs,
    required this.recentJobs,
    this.activeFilters,
    this.isOffline = false,
    this.lastSubmittedApplication,
  });

  JobsLoaded copyWith({
    List<Job>? allJobs,
    List<Job>? featuredJobs,
    List<Job>? recentJobs,
    JobFilterParams? activeFilters,
    bool? isOffline,
    JobApplication? lastSubmittedApplication,
  }) {
    return JobsLoaded(
      allJobs: allJobs ?? this.allJobs,
      featuredJobs: featuredJobs ?? this.featuredJobs,
      recentJobs: recentJobs ?? this.recentJobs,
      activeFilters: activeFilters ?? this.activeFilters,
      isOffline: isOffline ?? this.isOffline,
      lastSubmittedApplication: lastSubmittedApplication ?? this.lastSubmittedApplication,
    );
  }

  @override
  List<Object?> get props => [
        allJobs,
        featuredJobs,
        recentJobs,
        activeFilters,
        isOffline,
        lastSubmittedApplication,
      ];
}

class JobsError extends JobState {
  final String message;
  final int? statusCode;

  const JobsError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
