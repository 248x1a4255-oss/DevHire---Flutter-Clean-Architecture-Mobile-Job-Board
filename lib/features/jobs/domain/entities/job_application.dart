import 'package:equatable/equatable.dart';

enum ApplicationStatus { submitted, underReview, interviewScheduled, offerExtended }

class JobApplication extends Equatable {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String fullName;
  final String email;
  final String phone;
  final String? portfolioLink;
  final String? coverLetter;
  final String resumeFileName;
  final DateTime appliedAt;
  final ApplicationStatus status;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.fullName,
    required this.email,
    required this.phone,
    this.portfolioLink,
    this.coverLetter,
    required this.resumeFileName,
    required this.appliedAt,
    this.status = ApplicationStatus.submitted,
  });

  @override
  List<Object?> get props => [
        id,
        jobId,
        fullName,
        email,
        phone,
        resumeFileName,
        appliedAt,
        status,
      ];
}
