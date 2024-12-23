class NotificationModel {
  final String title;
  final String description;
  bool isEnabled;

  NotificationModel({
    required this.title,
    required this.description,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isEnabled': isEnabled,
    };
  }

  // From Firestore document data
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      description: map['description'],
      isEnabled: map['isEnabled'] ?? true,
    );
  }
}
