import 'package:flutter/material.dart';
import '../../domain/entities/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  final VoidCallback onSaveToggle;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stylized Company Logo
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      job.companyName.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.companyName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      job.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: job.isSaved ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
                      size: 22,
                    ),
                    onPressed: onSaveToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Unboxed metadata row with typographic separators
              Row(
                children: [
                  Text(
                    job.location,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('·', style: TextStyle(color: Color(0xFF94A3B8))),
                  ),
                  Text(
                    job.locationTypeLabel,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('·', style: TextStyle(color: Color(0xFF94A3B8))),
                  ),
                  Text(
                    job.jobTypeLabel,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const Spacer(),
                  Text(
                    job.relativeTime,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Salary Range
              Text(
                job.salaryFormatted,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
