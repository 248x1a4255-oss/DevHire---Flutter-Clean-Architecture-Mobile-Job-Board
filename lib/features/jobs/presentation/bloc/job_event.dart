import 'package:equatable/equatable.dart';
import '../../domain/entities/job_application.dart';
import '../../domain/repositories/job_repository.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobsEvent extends JobEvent {
  final JobFilterParams? filterParams;

  const LoadJobsEvent({this.filterParams});

  @override
  List<Object?> get props => [filterParams];
}

class RefreshJobsEvent extends JobEvent {
  const RefreshJobsEvent();
}

class FilterJobsEvent extends JobEvent {
  final JobFilterParams filterParams;

  const FilterJobsEvent(this.filterParams);

  @override
  List<Object?> get props => [filterParams];
}

class ToggleSaveJobEvent extends JobEvent {
  final String jobId;

  const ToggleSaveJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class ApplyToJobEvent extends JobEvent {
  final JobApplication application;

  const ApplyToJobEvent(this.application);

  @override
  List<Object?> get props => [application];
}
