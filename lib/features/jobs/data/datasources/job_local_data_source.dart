import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/job_model.dart';
import '../../domain/repositories/job_repository.dart';

abstract class JobLocalDataSource {
  Future<List<JobModel>> getCachedJobs({JobFilterParams? filterParams});
  Future<void> cacheJobs(List<JobModel> jobs);
  Future<bool> toggleSavedJob(String jobId);
  Future<List<String>> getSavedJobIds();
  Future<void> saveApplication(Map<String, dynamic> applicationData);
  Future<List<Map<String, dynamic>>> getSavedApplications();
}

class JobLocalDataSourceImpl implements JobLocalDataSource {
  final SharedPreferences sharedPreferences;

  JobLocalDataSourceImpl({required this.sharedPreferences});

  static const String CACHED_JOBS_KEY = 'CACHED_JOBS_KEY';
  static const String SAVED_BOOKMARKS_KEY = 'SAVED_BOOKMARKS_KEY';
  static const String SUBMITTED_APPS_KEY = 'SUBMITTED_APPS_KEY';

  @override
  Future<List<JobModel>> getCachedJobs({JobFilterParams? filterParams}) async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_JOBS_KEY);
      List<JobModel> allJobs;

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
        allJobs = decoded.map((item) => JobModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        // Fallback to richly populated embedded dataset
        allJobs = _generateProductionMockDataset();
        await cacheJobs(allJobs);
      }

      // Sync saved bookmarks status
      final savedIds = await getSavedJobIds();
      allJobs = allJobs.map((j) {
        if (savedIds.contains(j.id)) {
          return j.copyWith(isSaved: true) as JobModel;
        }
        return j.copyWith(isSaved: false) as JobModel;
      }).toList();

      // Apply in-memory filtering if requested
      if (filterParams != null) {
        if (filterParams.searchQuery != null && filterParams.searchQuery!.isNotEmpty) {
          final q = filterParams.searchQuery!.toLowerCase();
          allJobs = allJobs
              .where((j) =>
                  j.title.toLowerCase().contains(q) ||
                  j.companyName.toLowerCase().contains(q) ||
                  j.location.toLowerCase().contains(q) ||
                  j.department.toLowerCase().contains(q))
              .toList();
        }

        if (filterParams.jobTypes != null && filterParams.jobTypes!.isNotEmpty) {
          allJobs = allJobs.where((j) => filterParams.jobTypes!.contains(j.jobType)).toList();
        }

        if (filterParams.locationTypes != null && filterParams.locationTypes!.isNotEmpty) {
          allJobs = allJobs.where((j) => filterParams.locationTypes!.contains(j.locationType)).toList();
        }

        if (filterParams.minSalary != null) {
          allJobs = allJobs.where((j) => j.salaryMax >= filterParams.minSalary!).toList();
        }
      }

      return allJobs;
    } catch (e) {
      throw CacheException(message: 'Failed to read from local storage.');
    }
  }

  @override
  Future<void> cacheJobs(List<JobModel> jobs) async {
    final list = jobs.map((j) => j.toJson()).toList();
    await sharedPreferences.setString(CACHED_JOBS_KEY, json.encode(list));
  }

  @override
  Future<bool> toggleSavedJob(String jobId) async {
    final savedIds = await getSavedJobIds();
    bool newState;
    if (savedIds.contains(jobId)) {
      savedIds.remove(jobId);
      newState = false;
    } else {
      savedIds.add(jobId);
      newState = true;
    }
    await sharedPreferences.setStringList(SAVED_BOOKMARKS_KEY, savedIds);
    return newState;
  }

  @override
  Future<List<String>> getSavedJobIds() async {
    return sharedPreferences.getStringList(SAVED_BOOKMARKS_KEY) ?? [];
  }

  @override
  Future<void> saveApplication(Map<String, dynamic> applicationData) async {
    final existingJson = sharedPreferences.getString(SUBMITTED_APPS_KEY);
    List<dynamic> list = [];
    if (existingJson != null) {
      list = json.decode(existingJson) as List<dynamic>;
    }
    list.insert(0, applicationData);
    await sharedPreferences.setString(SUBMITTED_APPS_KEY, json.encode(list));
  }

  @override
  Future<List<Map<String, dynamic>>> getSavedApplications() async {
    final existingJson = sharedPreferences.getString(SUBMITTED_APPS_KEY);
    if (existingJson != null) {
      final List<dynamic> list = json.decode(existingJson) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  List<JobModel> _generateProductionMockDataset() {
    return [
      JobModel(
        id: 'job-1',
        title: 'Principal Flutter & Dart Architect',
        companyName: 'Spotify',
        companyBadgeBg: '#1DB954',
        companyBadgeColor: '#000000',
        location: 'Stockholm, Sweden',
        locationType: LocationType.hybrid,
        salaryMin: 145000,
        salaryMax: 195000,
        salaryCurrency: '$',
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.lead,
        postedAt: DateTime.now().subtract(const Duration(hours: 2)),
        department: 'Mobile Core Platform',
        isFeatured: true,
        isSaved: false,
        applicantsCount: 38,
        companyOverview:
            'Spotify is the world’s most popular audio streaming subscription service with 600M+ users. Our mobile engineering teams pioneer next-generation audio playback, lyrics synchronization, and cross-platform infrastructure.',
        description:
            'We are seeking a high-caliber Principal Flutter Architect to spearhead cross-platform mobile infrastructure, developer ergonomics, and micro-frontend design across client applications.\n\nYou will partner with engineering leadership to enforce Clean Architecture boundaries and optimize low-latency rendering across 120Hz displays.',
        responsibilities: const [
          'Architect resilient Clean Architecture pipelines separating presentation, business logic (BLoC), domain use cases, and remote/offline data layers.',
          'Profile rendering performance and eliminate frame drops using Dart DevTools and custom memory profilers.',
          'Develop platform channels for native C++ DSP audio rendering and establish robust mock repositories.',
          'Enforce strict static analysis, unit test coverage (>90%), and golden screenshot tests.'
        ],
        requirements: const [
          '7+ years professional mobile engineering with at least 4+ years specializing in production Flutter & Dart codebases.',
          'Exemplary mastery of Clean Architecture, BLoC, dependency injection (GetIt), and value equality (Equatable).',
          'Proven track record scaling apps to 1M+ active users with offline-first synchronization.',
          'Deep fluency with platform channels, Swift/Objective-C interop, and Dart FFI.'
        ],
        benefits: const [
          'Extensive equity package (RSUs) with flexible vesting schedules.',
          'Flexible hybrid work model with home office stipend ($2,500).',
          'Comprehensive global health, dental, and vision insurance coverage.',
          'Annual learning and conference budget ($4,000) + wellness allowance.'
        ],
      ),
      JobModel(
        id: 'job-2',
        title: 'Staff Mobile Engineer (Fintech)',
        companyName: 'Stripe',
        companyBadgeBg: '#635BFF',
        companyBadgeColor: '#FFFFFF',
        location: 'San Francisco, CA',
        locationType: LocationType.remote,
        salaryMin: 180000,
        salaryMax: 240000,
        salaryCurrency: '$',
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        postedAt: DateTime.now().subtract(const Duration(hours: 5)),
        department: 'Terminal & Point of Sale',
        isFeatured: true,
        isSaved: false,
        applicantsCount: 64,
        companyOverview:
            'Stripe builds economic infrastructure for the internet. Millions of companies use Stripe to accept payments, send payouts, and manage their business online.',
        description:
            'As a Staff Mobile Engineer on the Stripe Terminal team, you will engineer secure hardware payment flows, BLE reader integrations, and resilient offline transaction queues used by hundreds of thousands of merchants worldwide.',
        responsibilities: const [
          'Design fault-tolerant payment flows capable of operating in zero-connectivity retail environments.',
          'Partner with security architects to maintain PCI-DSS compliance across all mobile transaction states.',
          'Develop modular client SDKs consumed by third-party enterprise developers with zero breaking changes.'
        ],
        requirements: const [
          '6+ years developing high-scale mobile applications in production environments.',
          'Deep expertise in offline-first data synchronization, encryption-at-rest, and queue processing.',
          'Solid understanding of hardware protocols (Bluetooth LE, USB serial) and background process management.'
        ],
        benefits: const [
          'Top-of-market compensation with liquid public equity.',
          '100% remote flexibility with co-working access worldwide.',
          'Comprehensive parental leave (24 weeks fully paid).',
          '401(k) matching up to 5% with immediate vesting.'
        ],
      ),
      JobModel(
        id: 'job-3',
        title: 'Senior Flutter UI/UX Engineer',
        companyName: 'Airbnb',
        companyBadgeBg: '#FF5A5F',
        companyBadgeColor: '#FFFFFF',
        location: 'New York, NY',
        locationType: LocationType.hybrid,
        salaryMin: 155000,
        salaryMax: 205000,
        salaryCurrency: '$',
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        department: 'Guest Experience & Search',
        isFeatured: true,
        isSaved: true,
        applicantsCount: 92,
        companyOverview:
            'Airbnb creates a world where anyone can belong anywhere. We deliver end-to-end travel experiences, including homes and unique stays.',
        description:
            'Join our Guest Experience team to craft tactile, fluid, and delightful discovery interfaces. You will turn intricate motion designs into performant 60fps Flutter widgets with CustomPainters, sliver architectures, and physics-based interactions.',
        responsibilities: const [
          'Craft complex CustomScrollView and nested Sliver components with seamless collapsing headers.',
          'Implement custom gesture handlers, fluid spring physics, and shared-element transitions.',
          'Ensure strict WCAG AA accessibility compliance across screen readers and dynamic font scaling.'
        ],
        requirements: const [
          '5+ years building consumer-facing mobile products with remarkable visual polish.',
          'Mastery of Flutter CustomPainter, RenderObject customization, and animation controllers.',
          'Strong eye for typography, spatial padding, hierarchy, and tactile animation curves.'
        ],
        benefits: const [
          'Annual $2,000 travel coupon to explore Airbnb stays worldwide.',
          'Annual performance bonus and comprehensive equity refreshers.',
          'Catered meals, health and wellness stipends, and ergonomic equipment.'
        ],
      ),
      JobModel(
        id: 'job-4',
        title: 'Staff Dart & Cloud Platform Lead',
        companyName: 'Google Cloud',
        companyBadgeBg: '#4285F4',
        companyBadgeColor: '#FFFFFF',
        location: 'Mountain View, CA',
        locationType: LocationType.hybrid,
        salaryMin: 190000,
        salaryMax: 260000,
        salaryCurrency: '$',
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.lead,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        department: 'Developer Experience',
        isFeatured: false,
        isSaved: false,
        applicantsCount: 45,
        companyOverview:
            'Google Cloud accelerates organizations’ ability to digitally transform their business with best-in-class infrastructure and developer platforms.',
        description:
            'We are looking for a Staff Dart Specialist to lead cloud-native tooling, Dart server runtime optimizations, and cross-platform client SDKs.',
        responsibilities: const [
          'Optimize Dart ahead-of-time (AOT) and JIT runtime performance for containerized microservices.',
          'Author idiomatic client libraries for Cloud Pub/Sub, Firestore, and Vertex AI with zero bloat.',
          'Drive architecture reviews across multiple product teams adopting Dart as a full-stack language.'
        ],
        requirements: const [
          '8+ years in systems or application architecture with deep Dart/C++ proficiency.',
          'Demonstrated leadership guiding high-stakes architecture migrations in distributed teams.',
          'Expertise in network protocols (HTTP/3, gRPC, WebSockets) and binary serialization formats.'
        ],
        benefits: const [
          'Google-standard retirement matching, medical, dental, and vision.',
          'Onsite wellness centers, gourmet cafeterias, and commuter shuttles.',
          'Substantial relocation assistance and continuing education sponsorships.'
        ],
      ),
      JobModel(
        id: 'job-5',
        title: 'Mobile Systems & Security Specialist',
        companyName: 'Datadog',
        companyBadgeBg: '#632CA6',
        companyBadgeColor: '#FFFFFF',
        location: 'Boston, MA',
        locationType: LocationType.remote,
        salaryMin: 140000,
        salaryMax: 185000,
        salaryCurrency: '$',
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
        department: 'Real User Monitoring (RUM)',
        isFeatured: false,
        isSaved: false,
        applicantsCount: 29,
        companyOverview:
            'Datadog is an essential monitoring and security platform for cloud applications, bringing together end-to-end traces, metrics, and logs.',
        description:
            'Join the Mobile Real User Monitoring squad to build lightweight, non-intrusive observability SDKs. You will instrument crash reporting, ANR detection, and network telemetry.',
        responsibilities: const [
          'Develop zero-overhead telemetry collectors for Dart isolates, network clients, and gesture tracking.',
          'Implement native signal capture (Mach exceptions on iOS, SigQuit on Android) bridged safely into Flutter.',
          'Optimize data serialization and batch compression before transmitting events over cellular networks.'
        ],
        requirements: const [
          '4+ years specializing in mobile systems internals, APM, or security auditing.',
          'Hands-on expertise with low-level Dart VM profilers, memory dumps, and native symbolication.',
          'Strong knowledge of concurrency, thread safety, and isolate messaging in Dart.'
        ],
        benefits: const [
          'Competitive salary + equity package + annual performance bonus.',
          'Flexible remote stipend ($1,200/year for tech & ergonomics).',
          'Unlimited Paid Time Off (PTO) with mandated minimums.'
        ],
      ),
      JobModel(
        id: 'job-6',
        title: 'Cross-Platform Mobile Developer',
        companyName: 'Figma',
        companyBadgeBg: '#0ACF83',
        companyBadgeColor: '#000000',
        location: 'San Francisco, CA',
        locationType: LocationType.remote,
        salaryMin: 130000,
        salaryMax: 175000,
        salaryCurrency: '$',
        jobType: JobType.contract,
        experienceLevel: ExperienceLevel.mid,
        postedAt: DateTime.now().subtract(const Duration(days: 4)),
        department: 'Mobile Mirror & Review',
        isFeatured: false,
        isSaved: false,
        applicantsCount: 51,
        companyOverview:
            'Figma is where teams design, prototype, and build together. Our collaborative interface design tool enables teams to brainstorm and deliver better products.',
        description:
            'We are looking for an inventive Cross-Platform Mobile Engineer to refine our mobile companion app for live frame mirroring, design critique commenting, and multi-user cursor tracking.',
        responsibilities: const [
          'Deliver fluid vector rendering and pinch-to-zoom viewports using hardware accelerated canvas pipelines.',
          'Implement real-time WebSocket comment synchronizations with optimistic local caching.',
          'Build responsive layouts that gracefully adapt between smartphone and tablet canvas orientations.'
        ],
        requirements: const [
          '3+ years professional Flutter mobile experience.',
          'Solid command of state management (BLoC / Riverpod) and reactive stream programming.',
          'Experience with WebSocket protocols and canvas drawing.'
        ],
        benefits: const [
          'Premium hourly/monthly contract rate with overtime compensation.',
          'Direct mentorship from principal engineers and design visionaries.',
          'Latest hardware provided (M3 Max MacBook Pro + test devices).'
        ],
      ),
    ];
  }
}
