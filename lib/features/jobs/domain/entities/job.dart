import 'package:equatable/equatable.dart';

enum JobType { fullTime, partTime, contract, internship }
enum LocationType { remote, hybrid, onsite }
enum ExperienceLevel { entry, mid, senior, lead, executive }

class Job extends Equatable {
  final String id;
  final String title;
  final String companyName;
  final String? companyLogoUrl;
  final String companyBadgeBg;
  final String companyBadgeColor;
  final String location;
  final LocationType locationType;
  final double salaryMin;
  final double salaryMax;
  final String salaryCurrency;
  final JobType jobType;
  final ExperienceLevel experienceLevel;
  final DateTime postedAt;
  final String department;
  final String description;
  final String companyOverview;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> benefits;
  final bool isFeatured;
  final bool isSaved;
  final int applicantsCount;

  const Job({
    required this.id,
    required this.title,
    required this.companyName,
    this.companyLogoUrl,
    required this.companyBadgeBg,
    required this.companyBadgeColor,
    required this.location,
    required this.locationType,
    required this.salaryMin,
    required this.salaryMax,
    required this.salaryCurrency,
    required this.jobType,
    required this.experienceLevel,
    required this.postedAt,
    required this.department,
    required this.description,
    required this.companyOverview,
    required this.responsibilities,
    required this.requirements,
    required this.benefits,
    this.isFeatured = false,
    this.isSaved = false,
    this.applicantsCount = 0,
  });

  String get salaryFormatted {
    final minK = (salaryMin / 1000).toStringAsFixed(0);
    final maxK = (salaryMax / 1000).toStringAsFixed(0);
    return '$\${minK}k - $\${maxK}k/yr';
  }

  String get jobTypeLabel {
    switch (jobType) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
    }
  }

  String get locationTypeLabel {
    switch (locationType) {
      case LocationType.remote:
        return 'Remote';
      case LocationType.hybrid:
        return 'Hybrid';
      case LocationType.onsite:
        return 'On-site';
    }
  }

  String get relativeTime {
    final difference = DateTime.now().difference(postedAt);
    if (difference.inHours < 1) {
      return '\${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '\${difference.inHours}h ago';
    } else {
      return '\${difference.inDays}d ago';
    }
  }

  Job copyWith({
    String? id,
    String? title,
    String? companyName,
    String? companyLogoUrl,
    String? companyBadgeBg,
    String? companyBadgeColor,
    String? location,
    LocationType? locationType,
    double? salaryMin,
    double? salaryMax,
    String? salaryCurrency,
    JobType? jobType,
    ExperienceLevel? experienceLevel,
    DateTime? postedAt,
    String? department,
    String? description,
    String? companyOverview,
    List<String>? responsibilities,
    List<String>? requirements,
    List<String>? benefits,
    bool? isFeatured,
    bool? isSaved,
    int? applicantsCount,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      companyBadgeBg: companyBadgeBg ?? this.companyBadgeBg,
      companyBadgeColor: companyBadgeColor ?? this.companyBadgeColor,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      postedAt: postedAt ?? this.postedAt,
      department: department ?? this.department,
      description: description ?? this.description,
      companyOverview: companyOverview ?? this.companyOverview,
      responsibilities: responsibilities ?? this.responsibilities,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      isFeatured: isFeatured ?? this.isFeatured,
      isSaved: isSaved ?? this.isSaved,
      applicantsCount: applicantsCount ?? this.applicantsCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        location,
        locationType,
        salaryMin,
        salaryMax,
        jobType,
        isFeatured,
        isSaved,
      ];
}
