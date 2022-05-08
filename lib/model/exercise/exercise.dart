import 'package:intl/intl.dart';

class Exercise {
  String name;
  String ko_name;
  String detail;
  String creationDate;
  String updateDate;

  Exercise(
      {this.name,
      this.ko_name,
      this.detail,
      this.creationDate,
      this.updateDate});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['EX_Name'];
    ko_name = json['EX_KO_Name'];
    detail = json['EX_Description'];
    creationDate = DateFormat("yyyy-MM-dd HH:mm").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(json['EX_Creation_Date'] as String)
            .toLocal());
    updateDate = DateFormat("yyyy-MM-dd HH:mm").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parseUTC(json['EX_Update_Date'] as String)
            .toLocal());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EX_Name'] = this.name;
    data['EX_KO_Name'] = this.ko_name;
    data['EX_Description'] = this.detail;
    data['EX_Creation_Date'] = this.creationDate;
    data['EX_Update_Date'] = this.updateDate;
    return data;
  }
}
