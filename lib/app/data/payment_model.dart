class PaymentModel {
  int id;
  String payment_logo;
  String name;
  String number;
  String payment_type;

  PaymentModel({
    required this.id,
    required this.payment_logo,
    required this.name,
    required this.number,
    required this.payment_type,
  });

  // Factory method to create an instance from Firestore document snapshot
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      payment_logo: json['payment_logo'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      payment_type: json['payment_type'] ?? '',
    );
  }

  // Method to convert an instance to a Map for saving into Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_logo': payment_logo,
      'name': name,
      'number': number,
      'payment_type': payment_type,
    };
  }
}
