// lib/models/review.dart
class Review {
  final String userName;
  final int rating;
  final String comment;
  final String date;
  final String? serviceUsed;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.serviceUsed,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['userName'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      serviceUsed: json['serviceUsed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'serviceUsed': serviceUsed,
    };
  }
}