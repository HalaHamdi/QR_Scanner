import 'package:flutter/material.dart';
import 'package:register/models/scan_data.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;
class ScanController{
  final void Function(String) callback;
  static const String URL="https://script.google.com/macros/s/AKfycbx-X4ulluL92CdkDUguPUYNjchlH5jB11HGKK3Je_9XvwMAAGU_4EhsDgCU-MfkllHR/exec";
  static const STATUS_SUCCESS="SUCCESS";

  ScanController(this.callback);

  Future AddPerson(ScanData scanData) async{
    print("Inside controller");
    try {
    await http.get(URL+scanData.toParams()).then((response){
      callback(convert.jsonDecode(response.body)['status']);
    });
    }catch(e){
      print(e);
      print("inside error in controller");
    }
  }
}