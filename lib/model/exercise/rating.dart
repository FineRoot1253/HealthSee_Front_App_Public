class Rating {
  int reviewCount;
  String reviewAvg;
  int oneCount;
  int twoCount;
  int threeCount;
  int fourCount;
  int fiveCount;

  Rating(
      {this.reviewCount,
      this.reviewAvg,
      this.oneCount,
      this.twoCount,
      this.threeCount,
      this.fourCount,
      this.fiveCount});

  Rating.fromJson(Map<String, dynamic> json) {
    reviewCount = json['Review_Count'];
    reviewAvg = json['Review_AVG'];
    oneCount = json['One_Count'];
    twoCount = json['Two_Count'];
    threeCount = json['Three_Count'];
    fourCount = json['Four_Count'];
    fiveCount = json['Five_Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Review_Count'] = this.reviewCount;
    data['Review_AVG'] = this.reviewAvg;
    data['One_Count'] = this.oneCount;
    data['Two_Count'] = this.twoCount;
    data['Three_Count'] = this.threeCount;
    data['Four_Count'] = this.fourCount;
    data['Five_Count'] = this.fiveCount;
    return data;
  }
}
