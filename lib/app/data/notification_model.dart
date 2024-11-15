class NotificationModel {
  final String id;

  final String body;

  NotificationModel({
    required this.id,
    required this.body,
  });

  factory NotificationModel.fromDocument(Map<String, dynamic> doc) {
    return NotificationModel(
      id: doc['id'],
      body: doc['data'],
    );
  }
}
