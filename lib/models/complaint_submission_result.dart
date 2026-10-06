import 'complaint_order_summary.dart';

class ComplaintSubmissionResult {
  final String complaintNumber;
  final ComplaintOrderSummary order;
  final String category;
  final String description;
  final String? photoPath;
  final String status;

  const ComplaintSubmissionResult({
    required this.complaintNumber,
    required this.order,
    required this.category,
    required this.description,
    required this.status,
    this.photoPath,
  });
}
