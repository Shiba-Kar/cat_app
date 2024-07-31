import 'package:cat_app/data.dart';

class Res {
  String? version;
  bool? isSuccess;
  String? message;
  Data? data;
  int? statusCode;

  Res({
    this.version,
    this.isSuccess,
    this.message,
    this.data,
    this.statusCode,
  });

  factory Res.fromJson(Map<String, dynamic> json) => Res(
        version: json["Version"],
        isSuccess: json["IsSuccess"],
        data: json["Result"] == null ? null : Data.fromJson(json["Result"]),
        message: json["Message"],
        statusCode: json["StatusCode"],
      );
}
