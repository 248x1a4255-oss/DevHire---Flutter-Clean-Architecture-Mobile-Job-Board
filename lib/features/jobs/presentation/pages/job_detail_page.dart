import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/job.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../widgets/job_application_sheet.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;

  const JobDetailPage({super.key, required this.job});

  void _openApplicationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<JobBloc>(),
        child: JobApplicationSheet(job: job),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible SliverAppBar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: Color(0xFF0F172A)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    job.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 20,
                    color: job.isSaved ? const Color(0xFF4F46E5) : const Color(0xFF0F172A),
                  ),
                ),
                onPressed: () {
                  context.read<JobBloc>().add(ToggleSaveJobEvent(job.id));
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            job.companyName.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.companyName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                job.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '\${job.location} · \${job.locationTypeLabel}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          job.salaryFormatted,
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // Job Content Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Quick Meta Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetaStat('Job Type', job.jobTypeLabel),
                      _buildDivider(),
                      _buildMetaStat('Experience', job.experienceLevel.name.toUpperCase()),
                      _buildDivider(),
                      _buildMetaStat('Applicants', '\${job.applicantsCount}'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Company Overview
                _buildSectionHeader('Company Overview'),
                const SizedBox(height: 8),
                Text(
                  job.companyOverview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF334155),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // Full Job Description
                _buildSectionHeader('Role Description'),
                const SizedBox(height: 8),
                Text(
                  job.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF334155),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // Responsibilities
                if (job.responsibilities.isNotEmpty) ...[
                  _buildSectionHeader('Key Responsibilities'),
                  const SizedBox(height: 10),
                  ...job.responsibilities.map((item) => _buildBulletPoint(item)),
                  const SizedBox(height: 24),
                ],

                // Requirements & Qualifications
                _buildSectionHeader('Requirements & Qualifications'),
                const SizedBox(height: 10),
                ...job.requirements.map((item) => _buildBulletPoint(item)),

                const SizedBox(height: 24),

                // Benefits
                _buildSectionHeader('Perks & Benefits'),
                const SizedBox(height: 10),
                ...job.benefits.map((item) => _buildCheckPoint(item)),

                const SizedBox(height: 100), // Bottom padding for sticky bar
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                job.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: job.isSaved ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                size: 26,
              ),
              onPressed: () {
                context.read<JobBloc>().add(ToggleSaveJobEvent(job.id));
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _openApplicationSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: const Color(0xFFE2E8F0));
  }

  Widget _buildMetaStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
