class SupportUsModel {
  final String name;
  final String email;
  final double amount;
  final String message;
  final DateTime donationDate;
  final String transferProofUrl; // Added field for transfer proof URL

  SupportUsModel({
    required this.name,
    required this.email,
    required this.amount,
    this.message = '',
    DateTime? donationDate,
    required this.transferProofUrl,
  }) : donationDate = donationDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'amount': amount,
      'message': message,
      'donationDate': donationDate.toIso8601String(),
      'transferProofUrl': transferProofUrl,
    };
  }

  factory SupportUsModel.fromJson(Map<String, dynamic> json) {
    return SupportUsModel(
      name: json['name'],
      email: json['email'],
      amount: json['amount'],
      message: json['message'] ?? '',
      donationDate: DateTime.parse(json['donationDate']),
      transferProofUrl: json['transferProofUrl'],
    );
  }
}
