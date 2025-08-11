class BookingModel {
  final String id;
  final String itemId;
  final String borrowerId;
  final String lenderId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // requested, approved, declined, completed

  BookingModel({
    required this.id,
    required this.itemId,
    required this.borrowerId,
    required this.lenderId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'borrowerId': borrowerId,
      'lenderId': lenderId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      itemId: map['itemId'] ?? '',
      borrowerId: map['borrowerId'] ?? '',
      lenderId: map['lenderId'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      status: map['status'] ?? 'requested',
    );
  }
}
