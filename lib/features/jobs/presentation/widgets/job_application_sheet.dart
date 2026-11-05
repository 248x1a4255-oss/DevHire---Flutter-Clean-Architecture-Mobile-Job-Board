import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/job_application.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';

class JobApplicationSheet extends StatefulWidget {
  final Job job;

  const JobApplicationSheet({super.key, required this.job});

  @override
  State<JobApplicationSheet> createState() => _JobApplicationSheetState();
}

class _JobApplicationSheetState extends State<JobApplicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _coverLetterController = TextEditingController();

  String? _resumeFileName = 'Jane_Doe_Staff_Engineer_Resume.pdf';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate realistic API transport delay
      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      final application = JobApplication(
        id: 'app-\${DateTime.now().millisecondsSinceEpoch}',
        jobId: widget.job.id,
        jobTitle: widget.job.title,
        companyName: widget.job.companyName,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        portfolioLink: _portfolioController.text.trim(),
        coverLetter: _coverLetterController.text.trim(),
        resumeFileName: _resumeFileName ?? 'Resume.pdf',
        appliedAt: DateTime.now(),
      );

      context.read<JobBloc>().add(ApplyToJobEvent(application));

      setState(() => _isSubmitting = false);
      Navigator.pop(context);

      // Show gorgeous success feedback dialog
      _showSuccessDialog(context, application);
    }
  }

  void _showSuccessDialog(BuildContext context, JobApplication application) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 48, color: Color(0xFF10B981)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your application for \${widget.job.title} at \${widget.job.companyName} was submitted successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Listings'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Apply for \${widget.job.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
            ),
            Text(
              widget.job.companyName,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Full name is required.';
                      if (val.trim().length < 3) return 'Full name must be at least 3 characters.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Email Address
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Email address is required.';
                      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!regex.hasMatch(val.trim())) return 'Please enter a valid email address.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Phone number is required.';
                      final phoneRegex = RegExp(r'^[0-9+()\-\s]{7,20}$');
                      if (!phoneRegex.hasMatch(val.trim())) return 'Enter a valid numeric phone number.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Portfolio Link
                  TextFormField(
                    controller: _portfolioController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Portfolio / GitHub Link',
                      prefixIcon: Icon(Icons.link_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Resume Upload Box
                  const Text('Resume (PDF / DOCX) *',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _resumeFileName ?? 'No resume uploaded',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              const Text('2.4 MB · Ready for submission',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _resumeFileName = 'Updated_Candidate_CV.pdf';
                            });
                          },
                          child: const Text('Replace', style: TextStyle(fontSize: 12, color: Color(0xFF4F46E5))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit Application', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
