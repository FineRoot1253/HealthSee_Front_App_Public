class ExerciseList {
  String name;
  String ko_name;
  int reviewCount;
  String reviewAvg;

  ExerciseList({this.name, this.ko_name, this.reviewCount, this.reviewAvg});

  ExerciseList.fromJson(Map<String, dynamic> json) {
    name = json['EX_Name'];
    ko_name = json['EX_KO_Name'];
    reviewCount = json['Review_Count'];
    reviewAvg = json['Review_AVG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EX_Name'] = this.name;
    data['EX_KO_Name'] = this.ko_name;
    data['Review_Count'] = this.reviewCount;
    data['Review_AVG'] = this.reviewAvg;
    return data;
  }
}
