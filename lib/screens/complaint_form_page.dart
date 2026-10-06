import 'package:flutter/material.dart';

import '../models/complaint_order_summary.dart';
import '../theme/app_colors.dart';

class ComplaintFormPage extends StatefulWidget {
  final ComplaintOrderSummary order;

  const ComplaintFormPage({super.key, required this.order});

  @override
  State<ComplaintFormPage> createState() => _ComplaintFormPageState();
}

class _ComplaintFormPageState extends State<ComplaintFormPage> {
  static const _categories = ['Driver', 'Pesanan', 'Pembayaran', 'Aplikasi'];

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;

  bool get _hasStartedForm =>
      _selectedCategory != null ||
      _descriptionController.text.trim().isNotEmpty;

  int get _currentStep => _hasStartedForm ? 2 : 1;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Submission is intentionally deferred to the next implementation phase.
  }

  void _showNotReadyMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan ditambahkan pada tahap berikutnya.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOrderSummary(),
                        const SizedBox(height: 22),
                        _buildFieldLabel('Kategori Komplain', required: true),
                        const SizedBox(height: 8),
                        _buildCategoryField(),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Deskripsi Komplain', required: true),
                        const SizedBox(height: 8),
                        _buildDescriptionField(),
                        const SizedBox(height: 18),
                        _buildFieldLabel('Bukti Foto', optional: true),
                        const SizedBox(height: 8),
                        _buildPhotoPlaceholder(),
                        const SizedBox(height: 22),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 10,
        20,
        38,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF382044), AppColors.brandPurple, Color(0xFF30203F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                tooltip: 'Kembali',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildProgressIndicator()),
              const SizedBox(width: 10),
              Text(
                '$_currentStep dari 4',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Ajukan Komplain',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Sampaikan kendala yang kamu alami pada pesanan ini.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        final isComplete = index < _currentStep;
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
            decoration: BoxDecoration(
              color: isComplete
                  ? AppColors.primaryGradientStart
                  : AppColors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE8E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pesanan ${widget.order.orderId}',
            style: const TextStyle(
              color: AppColors.brandPurple,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.order.dateTimeLabel case final dateTimeLabel?) ...[
            const SizedBox(height: 3),
            Text(
              dateTimeLabel,
              style: const TextStyle(color: Color(0xFF85818A), fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          _buildLocationRow(
            color: AppColors.primaryGradientStart,
            location: widget.order.pickup,
          ),
          const SizedBox(height: 8),
          _buildLocationRow(
            color: const Color(0xFF9255E8),
            location: widget.order.destination,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({required Color color, required String location}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(
              color: Color(0xFF686372),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(
    String label, {
    bool required = false,
    bool optional = false,
  }) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.brandPurple,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.accent),
            ),
          if (optional)
            const TextSpan(
              text: ' (Opsional)',
              style: TextStyle(
                color: Color(0xFF85818A),
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.brandPurple),
      decoration: _inputDecoration(hintText: 'Pilih kategori komplain'),
      items: _categories
          .map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      validator: (value) {
        if (value == null) return 'Kategori komplain wajib dipilih';
        return null;
      },
      onChanged: (category) {
        setState(() => _selectedCategory = category);
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      minLines: 4,
      maxLines: 4,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      decoration:
          _inputDecoration(
            hintText: 'Jelaskan kendala yang kamu alami...',
            alignLabelWithHint: true,
          ).copyWith(
            counterStyle: const TextStyle(
              color: Color(0xFF85818A),
              fontSize: 11,
            ),
          ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Deskripsi komplain wajib diisi';
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF98939D), fontSize: 12),
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E0E2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryGradientStart,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCC4545)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCC4545), width: 1.4),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return OutlinedButton.icon(
      onPressed: () => _showNotReadyMessage('Fitur foto bukti'),
      icon: const Icon(Icons.camera_alt_outlined, size: 20),
      label: const Text('Tambah foto bukti (opsional)'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        alignment: Alignment.centerLeft,
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        side: const BorderSide(color: Color(0xFFE5E0E2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(13),
        ),
        child: FilledButton(
          onPressed: _submitForm,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kirim Komplain',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
