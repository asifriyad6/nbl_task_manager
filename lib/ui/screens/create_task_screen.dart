import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});
  static String name = '/create-task';

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final fireStore = FirebaseFirestore.instance;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _detailsTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _from = ['Chairman', 'Managing Director'];
  final List<String> _taskTo = [
    'DMD-1',
    'DMD-2',
    'DMD-3',
    'DMD-4',
    'BOD',
    'Logistics',
    'HR',
    'CRM(Corporate)',
    'CRM(Export)',
    'CRM(MSME)',
    'CRM(Retail)',
    'CRM(Agri)',
    'FAD',
    'ID',
    'Treasury',
    'RMD',
    'CAD',
    'SAMD',
    'Legal',
    'ICCD',
    'Card',
    'Audit',
  ];
  String? selectedFrom;
  String? selectedTo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: 'Task Title'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'From',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedFrom,
                  items: _from.map((fruit) {
                    return DropdownMenuItem<String>(
                      value: fruit,
                      child: Text(fruit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFrom = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select from';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'To',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: selectedTo,
                  items: _taskTo.map((fruit) {
                    return DropdownMenuItem<String>(
                      value: fruit,
                      child: Text(fruit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTo = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _detailsTEController,
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: 'Details of the Task'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter task details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Select date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // important
                  onTap: () => _pickDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please pick a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapAddTask,
                  child: Text('Add New Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleTEController.dispose();
    _detailsTEController.dispose();
    super.dispose();
  }

  void _onTapAddTask() {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      fireStore
          .collection('tasks')
          .add({
            'title': _titleTEController.text,
            'from': selectedFrom,
            'to': selectedTo,
            'details': _detailsTEController.text,
            'date': _dateController.text,
            'status': 'Processing',
            'createdAt': DateTime.now(),
          })
          .then((value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Task added successfully')));
            Navigator.pop(context);
          })
          .catchError((error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add task: $error')),
            );
          });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select a date', // Optional
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent closing
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
