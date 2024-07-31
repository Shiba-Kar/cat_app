import 'dart:convert';

import 'package:cat_app/const.dart';
import 'package:cat_app/data.dart';
import 'package:cat_app/res.dart';
import 'package:http/http.dart' as http;

class CatService {
  static Future<Data?> getData() async {
    try {
      var resRaw = await http.get(Uri.parse(apiUrl));
      final raw = jsonDecode(resRaw.body);
      var res = Res.fromJson(raw);
      if (res.isSuccess ?? false) {
        return res.data;
      }
      return Future.error("Failed to fetch data !!");
    } catch (e) {
      return Future.error(e);
    }
  }
}
