import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  String? id;
  String userId;
  String name;
  String email;
  String message;
  String status;
  DateTime timestamp;
  String? adminResponse;

  FeedbackModel({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.message,
    this.status = 'pending',
    required this.timestamp,
    this.adminResponse,
  });

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return FeedbackModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Anonymous',
      email: data['email'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      adminResponse: data['adminResponse'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'message': message,
      'status': status,
      'timestamp': timestamp,
      'adminResponse': adminResponse,
    };
  }
}