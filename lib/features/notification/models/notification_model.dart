class NotificationItemModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'system',
    this.isRead = false,
    this.createdAt,
    this.data,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      data: json['data'] != null && json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
    );
  }
}
