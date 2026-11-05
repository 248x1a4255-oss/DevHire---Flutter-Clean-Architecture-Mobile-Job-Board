import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';
import '../widgets/featured_job_card.dart';
import '../widgets/job_card.dart';
import '../widgets/job_filter_sheet.dart';
import '../widgets/job_shimmer_skeleton.dart';
import 'job_detail_page.dart';

class JobFeedPage extends StatefulWidget {
  const JobFeedPage({super.key});

  @override
  State<JobFeedPage> createState() => _JobFeedPageState();
}

class _JobFeedPageState extends State<JobFeedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<JobBloc>(),
        child: const JobFilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DevHire',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Find your next high-impact engineering role',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter jobs',
            onPressed: () => _openFilterSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<JobBloc>().add(const RefreshJobsEvent());
        },
        child: BlocBuilder<JobBloc, JobState>(
          builder: (context, state) {
            if (state is JobsLoading) {
              return const JobShimmerSkeleton();
            }

            if (state is JobsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 56, color: Color(0xFFEF4444)),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to load job listings',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<JobBloc>().add(const LoadJobsEvent());
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry Connection'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is JobsLoaded) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Prominent Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          // Trigger reactive debounced filter
                          context.read<JobBloc>().add(FilterJobsEvent(
                            JobFilterParams(searchQuery: query),
                          ));
                        },
                        decoration: InputDecoration(
                          hintText: 'Search roles, skills, or companies...',
                          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<JobBloc>().add(const LoadJobsEvent());
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF4F46E5)),
                                  onPressed: () => _openFilterSheet(context),
                                ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Featured Jobs Section
                  if (state.featuredJobs.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Opportunities',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\${state.featuredJobs.length} roles',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.featuredJobs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final job = state.featuredJobs[index];
                          return FeaturedJobCard(
                            job: job,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<JobBloc>(),
                                    child: JobDetailPage(job: job),
                                  ),
                                ),
                              );
                            },
                            onSaveToggle: () {
                              context.read<JobBloc>().add(ToggleSaveJobEvent(job.id));
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Recent Openings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Openings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\${state.allJobs.length} active positions',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Openings List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.allJobs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final job = state.allJobs[index];
                        return JobCard(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<JobBloc>(),
                                  child: JobDetailPage(job: job),
                                ),
                              ),
                            );
                          },
                          onSaveToggle: () {
                            context.read<JobBloc>().add(ToggleSaveJobEvent(job.id));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
