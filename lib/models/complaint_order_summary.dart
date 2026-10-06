class ComplaintOrderSummary {
  final String orderId;
  final String pickup;
  final String destination;
  final String? dateTimeLabel;

  const ComplaintOrderSummary({
    required this.orderId,
    required this.pickup,
    required this.destination,
    this.dateTimeLabel,
  });
}
