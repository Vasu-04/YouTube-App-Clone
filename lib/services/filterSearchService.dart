import 'package:dio/dio.dart';

class Filtersearchservice{
  String filterLink = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=";
  Future<Map<String,dynamic>?> getFilteredData(String videoTitle) async{
    final obj = Dio();
    final response  = await obj.get(filterLink + replaceWhiteSpaces(videoTitle) + "&key=AIzaSyCv50vuOlIws-Gw2DDTqwkG5IlFMvuXZiw");
    print( "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"+ filterLink + replaceWhiteSpaces(videoTitle) + "&key=AIzaSyA_PsvbbdkHGf3OdZp78mt0uXCYlZrCcBw");
    return (response.data);
  }
  String replaceWhiteSpaces(String input){
    String result ="";
    for(int i=0;i < input.length;i++){
      if(input[i] == " "){
        result += "%20";
      }
      else{
        result += input[i];
      }
    }
    
    return result;
  }
}