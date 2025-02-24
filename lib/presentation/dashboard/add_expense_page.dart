import 'dart:developer';
import 'dart:io';

import 'package:bhawani_tech_task/custom_widgets/custom_buttons.dart';
import 'package:bhawani_tech_task/custom_widgets/custom_text_feild.dart';
import 'package:bhawani_tech_task/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:bhawani_tech_task/presentation/dashboard/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocProvider;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  XFile? _receiptImage;

  final ImagePicker _picker = ImagePicker();

  // Method to select image from gallery or camera
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _receiptImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Add Expense"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offAll(() => const HomePage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title field
                CustomTextFeild(
                    text: 'Expense Title',
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      log(value.toString());
                    }),

                // Amount field
                CustomTextFeild(
                    text: 'Amount',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      log(value.toString());
                    }),
                // Description field
                CustomTextFeild(
                    maxLines: 3,
                    text: 'Description',
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      log(value.toString());
                    }),

                // Receipt image upload
                SizedBox(height: 10),
                _receiptImage == null
                    ? Text("No receipt selected")
                    : Image.file(
                        File(
                          _receiptImage!.path,
                        ),
                        height: Get.height * 0.4,
                      ),
                CustomButton(
                  buttonText: 'Upload Recipt Image',
                  onTap: _pickImage,
                ),

                // Submit button
                SizedBox(height: 10),

                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return const CircularProgressIndicator();
                    }
                    return CustomButton(
                      buttonText: 'Submit',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _receiptImage == null
                              ? Fluttertoast.showToast(
                                  msg: 'Please select a receipt image',
                                  backgroundColor: Colors.orange,
                                )
                              : BlocProvider.of<DashboardBloc>(context).add(
                                  AddReciptButtonPressed(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    amount:
                                        double.parse(_amountController.text),
                                    image: File(_receiptImage!.path),
                                  ),
                                );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
