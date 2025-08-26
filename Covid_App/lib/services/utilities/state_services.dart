import 'dart:convert';

import 'package:covid_app/models/All_model.dart';
import 'package:covid_app/models/Countries_model.dart';
import 'package:covid_app/services/utilities/Api_Url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class state_services{
  Future<AllApi> getworldApi() async{
    final response = await http.get(Uri.parse(UrlApi.WorldStateApi));
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      return AllApi.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }
  List<CountriesModel> Countrylist = [];
  Future<List<CountriesModel>> getCountryApi() async{
    final response = await http.get(Uri.parse(UrlApi.CountriesApi));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      for(Map i in data){
        Countrylist.add(CountriesModel.fromJson(i));
      }
      return Countrylist;

    }else{
      throw Exception('Error');
    }
  }
}

