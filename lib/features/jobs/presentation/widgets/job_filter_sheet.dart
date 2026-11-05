import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';

class JobFilterSheet extends StatefulWidget {
  const JobFilterSheet({super.key});

  @override
  State<JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<JobFilterSheet> {
  final Set<JobType> _selectedJobTypes = {};
  final Set<LocationType> _selectedLocations = {};
  double _minSalary = 100000;
  final TextEditingController _locationQueryController = TextEditingController();

  void _clearFilters() {
    setState(() {
      _selectedJobTypes.clear();
      _selectedLocations.clear();
      _minSalary = 80000;
      _locationQueryController.clear();
    });
    context.read<JobBloc>().add(const LoadJobsEvent());
    Navigator.pop(context);
  }

  void _applyFilters() {
    final params = JobFilterParams(
      jobTypes: _selectedJobTypes.toList(),
      locationTypes: _selectedLocations.toList(),
      minSalary: _minSalary,
      locationQuery: _locationQueryController.text.trim(),
    );
    context.read<JobBloc>().add(FilterJobsEvent(params));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Jobs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear All', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('Workplace Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: LocationType.values.map((loc) {
              final isSelected = _selectedLocations.contains(loc);
              return FilterChip(
                label: Text(loc.name.toUpperCase()),
                selected: isSelected,
                selectedColor: const Color(0xFF0F172A),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: const Color(0xFFF1F5F9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide.none,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedLocations.add(loc);
                    } else {
                      _selectedLocations.remove(loc);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Employment Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: JobType.values.map((type) {
              final isSelected = _selectedJobTypes.contains(type);
              return FilterChip(
                label: Text(type.name.toUpperCase()),
                selected: isSelected,
                selectedColor: const Color(0xFF0F172A),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: const Color(0xFFF1F5F9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide.none,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedJobTypes.add(type);
                    } else {
                      _selectedJobTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Minimum Annual Base', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text('$\${(_minSalary / 1000).toInt()}k/yr',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            ],
          ),
          Slider(
            value: _minSalary,
            min: 80000,
            max: 250000,
            divisions: 17,
            activeColor: const Color(0xFF0F172A),
            inactiveColor: const Color(0xFFE2E8F0),
            onChanged: (val) => setState(() => _minSalary = val),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Apply Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
