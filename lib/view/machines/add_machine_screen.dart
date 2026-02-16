import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/cnc_machine_model.dart';
import '../../viewmodel/cnc/cnc_cubit.dart';
import '../widgets/custom_snackbar.dart';

class AddMachineScreen extends StatefulWidget {
  const AddMachineScreen({super.key});

  @override
  State<AddMachineScreen> createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends State<AddMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _countryController = TextEditingController();
  final _priceController = TextEditingController();
  final _lifetimeController = TextEditingController();
  DateTime? _purchaseDate;

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _manufacturerController.dispose();
    _countryController.dispose();
    _priceController.dispose();
    _lifetimeController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final machine = CncMachine(
        id: '',
        name: _nameController.text.trim(),
        model: _modelController.text.trim().isEmpty
            ? null
            : _modelController.text.trim(),
        manufacturer: _manufacturerController.text.trim().isEmpty
            ? null
            : _manufacturerController.text.trim(),
        countryOfOrigin: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        purchaseDate: _purchaseDate,
        purchasePrice: _priceController.text.trim().isEmpty
            ? null
            : double.tryParse(_priceController.text.trim()),
        expectedLifetimeYears: _lifetimeController.text.trim().isEmpty
            ? null
            : int.tryParse(_lifetimeController.text.trim()),
        ownerId: '',
        createdAt: DateTime.now(),
      );

      await context.read<CncCubit>().addMachine(machine);

      if (mounted) {
        showCustomSnackbar(context, 'Machine added successfully');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text(
          'Add CNC Machine',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Machine Name *',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: _modelController, label: 'Model'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _manufacturerController,
                label: 'Manufacturer',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _countryController,
                label: 'Country of Origin',
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _purchaseDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF58A6FF),
                            surface: Color(0xFF161B22),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() => _purchaseDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF30363D)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _purchaseDate == null
                            ? 'Purchase Date'
                            : '${_purchaseDate!.year}-${_purchaseDate!.month.toString().padLeft(2, '0')}-${_purchaseDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _purchaseDate == null
                              ? const Color(0xFF8B949E)
                              : const Color(0xFFFFFFFF),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF8B949E),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Purchase Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lifetimeController,
                label: 'Expected Lifetime (years)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Machine',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
        filled: true,
        fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF58A6FF)),
        ),
      ),
      validator: validator,
    );
  }
}
