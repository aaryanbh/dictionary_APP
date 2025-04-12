import 'dart:convert';

import 'package:dictionary/dictionary_model.dart';

import 'package:http/http.dart' as http;
class APIservices{
 static String baseURL="https://api.dictionaryapi.dev/api/v2/entries/en/";

  static Future<DictionaryModel?>fetchData(String word)async{ //static means the method belongs to the class itself not to anything elsae
Uri url=Uri.parse("$baseURL$word");
final response=await http.get(url);

try{
  if(response.statusCode==200){
    final data =json.decode(response.body);
    return DictionaryModel.fromJson(data[0]);
  }else{
    throw Exception("Failiure to load meaning ");

  }
}catch(e){
    print(e.toString());}
  }
}