import 'package:cloud_firestore/cloud_firestore.dart';


// Expense model class to store expense data and convert to/from Firestore, SQLite and JSON format
class ExpensModel {
  String? id; // Document ID in Firestore (optional)
  String name;
  String token;
  String userId; // The user who submitted the expense
  String title;
  String description;
  double amount;
  String receiptImage; // URL or path to the uploaded receipt image
  String status; // expense status (e.g., "pending", "approved", "rejected")
  int createdAt; // The timestamp when the expense was created
  bool isSynced; // Flag to check if the expense is synced with Firestore

  ExpensModel({
    this.id,
    required this.name,
    required this.token,
    required this.userId,
    required this.title,
    required this.description,
    required this.amount,
    required this.receiptImage,
    required this.status,
    required this.createdAt,
    this.isSynced = false, // Default value is false
  });

  // Convert Expense object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'token': token,
      'title': title,
      'description': description,
      'amount': amount,
      'receiptImage': receiptImage,
      'status': status,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(
          createdAt), // Store as Timestamp,
      'isSynced': isSynced,
    };
  }

  // Convert Firestore data to Expense object
  factory ExpensModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ExpensModel(
      id: doc.id, // Assign Firestore document ID
      name: data['name'] ?? '',
      token: data['token'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : data['amount'] ?? 0.0,
      receiptImage: data['receiptImage'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).millisecondsSinceEpoch
          : DateTime.now()
              .millisecondsSinceEpoch, // Default to current time if missing, // Convert Timestamp to int (milliseconds)
      isSynced: data['isSynced'] ?? false,
    );
  }

  // Convert SQLite map to Expense object
  factory ExpensModel.fromMap(Map<String, dynamic> map) {
    return ExpensModel(
      id: map['id'], // Assuming SQLite stores the ID as 'id'
      name: map['name'] ?? '',
      token: map['token'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : map['amount'] ?? 0.0,
      receiptImage: map['receiptImage'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] ?? 0,
      isSynced: map['isSynced'] ==
          1, // Handle isSynced for SQLite (1 means true, 0 means false)
    );
  }

  // Convert Timestamp to DateTime for Firestore
  Timestamp get timestampCreatedAt =>
      Timestamp.fromMillisecondsSinceEpoch(createdAt);
}
