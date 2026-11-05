import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/jobs/data/datasources/job_local_data_source.dart';
import 'features/jobs/data/datasources/job_remote_data_source.dart';
import 'features/jobs/data/repositories/job_repository_impl.dart';
import 'features/jobs/domain/usecases/apply_job_usecase.dart';
import 'features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'features/jobs/domain/usecases/toggle_save_job_usecase.dart';
import 'features/jobs/presentation/bloc/job_bloc.dart';
import 'features/jobs/presentation/bloc/job_event.dart';
import 'features/jobs/presentation/pages/job_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Dio Network Client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.devhire.io',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Initialize Data Sources
  final localDataSource = JobLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final remoteDataSource = JobRemoteDataSourceImpl(dio: dio);

  // Initialize Repository (Dual-Datasource)
  final jobRepository = JobRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // Initialize Use Cases
  final getJobsUseCase = GetJobsUseCase(jobRepository);
  final toggleSaveJobUseCase = ToggleSaveJobUseCase(jobRepository);
  final applyJobUseCase = ApplyJobUseCase(jobRepository);

  runApp(
    DevHireApp(
      getJobsUseCase: getJobsUseCase,
      toggleSaveJobUseCase: toggleSaveJobUseCase,
      applyJobUseCase: applyJobUseCase,
    ),
  );
}

class DevHireApp extends StatelessWidget {
  final GetJobsUseCase getJobsUseCase;
  final ToggleSaveJobUseCase toggleSaveJobUseCase;
  final ApplyJobUseCase applyJobUseCase;

  const DevHireApp({
    super.key,
    required this.getJobsUseCase,
    required this.toggleSaveJobUseCase,
    required this.applyJobUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobBloc>(
      create: (context) => JobBloc(
        getJobsUseCase: getJobsUseCase,
        toggleSaveJobUseCase: toggleSaveJobUseCase,
        applyJobUseCase: applyJobUseCase,
      )..add(const LoadJobsEvent()),
      child: MaterialApp(
        title: 'DevHire Job Board',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const JobFeedPage(),
      ),
    );
  }
}
