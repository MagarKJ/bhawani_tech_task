import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensModel {
  String? id; // Document ID in Firestore (optional)
  String name;
  String userId; // The user who submitted the expense
  String title;
  String description;
  double amount;
  String receiptImage; // URL or path to the uploaded receipt image
  String status; // expense status (e.g., "pending", "approved", "rejected")
  Timestamp createdAt; // The timestamp when the expense was created

  ExpensModel({
    this.id,
    required this.name,
    required this.userId,
    required this.title,
    required this.description,
    required this.amount,
    required this.receiptImage,
    required this.status,
    required this.createdAt,
  });

  // Convert Expense object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'receiptImage': receiptImage,
      'status': status,
      'createdAt': createdAt,
    };
  }

  // Convert Firestore data to Expense object
  factory ExpensModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ExpensModel(
      id: doc.id, // Assign Firestore document ID
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : data['amount'] ?? 0.0,
      receiptImage: data['receiptImage'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
