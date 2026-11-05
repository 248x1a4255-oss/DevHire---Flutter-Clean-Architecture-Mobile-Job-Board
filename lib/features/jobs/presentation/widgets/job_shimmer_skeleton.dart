import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class JobShimmerSkeleton extends StatelessWidget {
  const JobShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar Skeleton
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 24),
          // Featured Header Skeleton
          Container(height: 18, width: 140, color: Colors.white),
          const SizedBox(height: 12),
          // Featured Cards Skeleton
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, __) => Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // List Header Skeleton
          Container(height: 18, width: 120, color: Colors.white),
          const SizedBox(height: 12),
          // Recent Job Cards Skeleton
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
