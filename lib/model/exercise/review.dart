import 'package:intl/intl.dart';

class Reviews {
  List<Review> reviews;

  Reviews({this.reviews});

  Reviews.fromJson(Map<String, dynamic> json) {
    if (json['Reviews'] != null) {
      reviews = new List<Review>();
      json['Reviews'].forEach((v) {
        reviews.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviews != null) {
      data['Reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  int code;
  String nickname;
  String exercise;
  String content;
  int rating;
  String creationDate;

  Review(
      {this.code,
      this.nickname,
      this.exercise,
      this.content,
      this.rating,
      this.creationDate});

  Review.fromJson(Map<String, dynamic> json) {
    code = json['EEV_Code'];
    nickname = json['EEV_Writer_NickName'];
    exercise = json['Exercise_EX_Name'];
    content = json['EEV_Content'];
    rating = json['EEV_Rank'];
    creationDate = DateFormat("yyyy-MM-dd HH:mm").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(json['EEV_Creation_Date'] as String)
            .toLocal());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EEV_Code'] = this.code;
    data['EEV_Writer_NickName'] = this.nickname;
    data['Exercise_EX_Name'] = this.exercise;
    data['EEV_Content'] = this.content;
    data['EEV_Rank'] = this.rating;
    data['EEV_Creation_Date'] = this.creationDate;
    return data;
  }
}
