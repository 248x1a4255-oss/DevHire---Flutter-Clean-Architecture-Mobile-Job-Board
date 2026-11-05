import '../../domain/entities/job.dart';

class JobModel extends Job {
  const JobModel({
    required super.id,
    required super.title,
    required super.companyName,
    super.companyLogoUrl,
    required super.companyBadgeBg,
    required super.companyBadgeColor,
    required super.location,
    required super.locationType,
    required super.salaryMin,
    required super.salaryMax,
    required super.salaryCurrency,
    required super.jobType,
    required super.experienceLevel,
    required super.postedAt,
    required super.department,
    required super.description,
    required super.companyOverview,
    required super.responsibilities,
    required super.requirements,
    required super.benefits,
    super.isFeatured = false,
    super.isSaved = false,
    super.applicantsCount = 0,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      companyName: json['companyName'] as String,
      companyLogoUrl: json['companyLogoUrl'] as String?,
      companyBadgeBg: json['companyBadgeBg'] as String? ?? '#0F172A',
      companyBadgeColor: json['companyBadgeColor'] as String? ?? '#FFFFFF',
      location: json['location'] as String,
      locationType: _parseLocationType(json['locationType'] as String),
      salaryMin: (json['salaryMin'] as num).toDouble(),
      salaryMax: (json['salaryMax'] as num).toDouble(),
      salaryCurrency: json['salaryCurrency'] as String? ?? '$',
      jobType: _parseJobType(json['jobType'] as String),
      experienceLevel: _parseExperienceLevel(json['experienceLevel'] as String? ?? 'Mid'),
      postedAt: DateTime.parse(json['postedAt'] as String),
      department: json['department'] as String? ?? 'Engineering',
      description: json['description'] as String,
      companyOverview: json['companyOverview'] as String? ?? '',
      responsibilities: List<String>.from(json['responsibilities'] as List? ?? []),
      requirements: List<String>.from(json['requirements'] as List? ?? []),
      benefits: List<String>.from(json['benefits'] as List? ?? []),
      isFeatured: json['isFeatured'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      applicantsCount: json['applicantsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'companyLogoUrl': companyLogoUrl,
      'companyBadgeBg': companyBadgeBg,
      'companyBadgeColor': companyBadgeColor,
      'location': location,
      'locationType': locationTypeLabel,
      'salaryMin': salaryMin,
      'salaryMax': salaryMax,
      'salaryCurrency': salaryCurrency,
      'jobType': jobTypeLabel,
      'experienceLevel': experienceLevel.name,
      'postedAt': postedAt.toIso8601String(),
      'department': department,
      'description': description,
      'companyOverview': companyOverview,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'benefits': benefits,
      'isFeatured': isFeatured,
      'isSaved': isSaved,
      'applicantsCount': applicantsCount,
    };
  }

  static JobType _parseJobType(String raw) {
    switch (raw.toLowerCase()) {
      case 'part-time':
        return JobType.partTime;
      case 'contract':
        return JobType.contract;
      case 'internship':
        return JobType.internship;
      default:
        return JobType.fullTime;
    }
  }

  static LocationType _parseLocationType(String raw) {
    switch (raw.toLowerCase()) {
      case 'remote':
        return LocationType.remote;
      case 'hybrid':
        return LocationType.hybrid;
      default:
        return LocationType.onsite;
    }
  }

  static ExperienceLevel _parseExperienceLevel(String raw) {
    switch (raw.toLowerCase()) {
      case 'entry':
        return ExperienceLevel.entry;
      case 'senior':
        return ExperienceLevel.senior;
      case 'lead':
        return ExperienceLevel.lead;
      case 'executive':
        return ExperienceLevel.executive;
      default:
        return ExperienceLevel.mid;
    }
  }
}
