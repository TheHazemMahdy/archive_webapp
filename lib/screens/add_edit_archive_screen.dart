// AddEditArchiveScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/colors.dart';
import '../blocs/archive_bloc.dart';
import '../blocs/archive_event.dart';
import '../widgets/my_button.dart';
import '../../data/models/archive_model.dart';

class AddEditArchiveScreen extends StatefulWidget {
  final bool isEdit;
  final ArchiveModel? archive;

  const AddEditArchiveScreen({super.key, this.isEdit = false, this.archive});

  @override
  State<AddEditArchiveScreen> createState() => _AddEditArchiveScreenState();
}

class _AddEditArchiveScreenState extends State<AddEditArchiveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _capacityController = TextEditingController();
  final _notesController = TextEditingController();
  String _status = 'up_to_date';

  @override
  void initState() {
    super.initState();
    // Debug: show incoming values
    print(
      'PRINT: AddEdit.initState -> isEdit=${widget.isEdit}, archive=${widget.archive?.id ?? "null"}',
    );

    if (widget.isEdit && widget.archive != null) {
      final a = widget.archive!;
      // assign directly (non-nullable in model)
      _nameController.text = a.name;
      _dateController.text = a.lastUpdated;
      _capacityController.text = a.capacity;
      _notesController.text = a.notes ?? '';
      _status = a.status.toLowerCase().contains('need')
          ? 'needs_update'
          : 'up_to_date';
      print('PRINT: Prefilled fields with archive id=${a.id}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  ArchiveModel _buildModelFromForm() {
    // Preserve original id if editing, otherwise generate a new one
    final id =
        widget.archive?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final model = ArchiveModel(
      id: id,
      name: _nameController.text.trim(),
      lastUpdated: _dateController.text.trim(),
      capacity: _capacityController.text.trim(),
      notes: _notesController.text.trim(),
      status: _status == 'up_to_date' ? "Up to Date" : "Needs Update",
    );

    print(
      'PRINT: Built model -> id=${model.id} name=${model.name} status=${model.status}',
    );
    return model;
  }

  Future<void> _deleteArchive(ArchiveModel archive) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Delete Archive?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete this archive? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      print('PRINT: Deleting archive id=${archive.id}');
      context.read<ArchiveBloc>().add(DeleteArchive(archive));
      // return true to caller so they reload list if needed
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      "Back to Archives",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.accentPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.storage_rounded,
                                color: AppColors.accentPurple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEdit ? "Update Archive" : "Add New Archive",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isEdit
                                      ? "Modify existing archive details"
                                      : "Register a new hard drive",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _buildLabel("Archive Name *"),
                        _buildInput(
                          hint: "e.g., Wedding Photos 2024",
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel("Last Updated *"),
                        TextFormField(
                          controller: _dateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                            _StrictDateInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: "mm/dd/yyyy",
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required field'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel("Storage Capacity *"),
                        _buildInput(
                          hint: "e.g., 2TB, 4TB, 8TB",
                          controller: _capacityController,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel("Status *"),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'up_to_date',
                              groupValue: _status,
                              activeColor: AppColors.accentPurple,
                              onChanged: (v) => setState(() => _status = v!),
                            ),
                            const Text(
                              "Up to Date",
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            const SizedBox(width: 16),
                            Radio<String>(
                              value: 'needs_update',
                              groupValue: _status,
                              activeColor: AppColors.accentPurple,
                              onChanged: (v) => setState(() => _status = v!),
                            ),
                            const Text(
                              "Needs Update",
                              style: TextStyle(color: AppColors.textDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildLabel("Notes (Optional)"),
                        _buildInput(
                          hint: "Add any additional information...",
                          controller: _notesController,
                          maxLines: 3,
                          requiredField: false, // ✅ mark as optional
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.accentPurple,
                                      AppColors.accentBlue,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: MyButton(
                                  backgroundColor: Colors.transparent,
                                  text: isEdit
                                      ? "Update Archive"
                                      : "Save Archive",
                                  foregroundColor: Colors.white,
                                  isIcon: true,
                                  isEdit: isEdit,
                                  onPressed: () {
                                    if (_formKey.currentState == null ||
                                        !_formKey.currentState!.validate())
                                      return;
                                    final model = _buildModelFromForm();
                                    print(
                                      'PRINT: Save pressed -> isEdit=$isEdit modelId=${model.id}',
                                    );
                                    final bloc = context.read<ArchiveBloc>();
                                    if (isEdit) {
                                      bloc.add(UpdateArchive(model));
                                    } else {
                                      bloc.add(AddArchive(model));
                                    }
                                    // Return true to signal caller to refresh
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MyButton(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                                text: "Cancel",
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ),
                          ],
                        ),
                        if (isEdit && widget.archive != null) ...[
                          const SizedBox(height: 16),
                          MyButton(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            text: "Delete Archive",
                            onPressed: () => _deleteArchive(widget.archive!),
                          ),
                        ],
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
      fontSize: 15,
    ),
  );

  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool requiredField = true, // ✅ new optional flag
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) {
        if (!requiredField) return null; // ✅ skip validation if optional
        return (v == null || v.trim().isEmpty) ? 'Required field' : null;
      },
    );
  }

}

class _StrictDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll('/', '');
    if (digits.isEmpty) return newValue;
    if (digits.length > 8) digits = digits.substring(0, 8);

    String month = '';
    String day = '';
    String year = '';
    String newText = '';

    if (digits.length >= 1) {
      month = digits.substring(0, digits.length.clamp(0, 2));
      int m = int.tryParse(month) ?? 0;
      if (m > 12) return oldValue;
    }
    if (digits.length > 2) {
      day = digits.substring(2, digits.length.clamp(2, 4));
      int d = int.tryParse(day) ?? 0;
      if (d > 31) return oldValue;
    }
    if (digits.length > 4) {
      year = digits.substring(4);
    }

    if (month.isNotEmpty) newText += month;
    if (digits.length > 2) newText += '/$day';
    if (digits.length > 4) newText += '/$year';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
