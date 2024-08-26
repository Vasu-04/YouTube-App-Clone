import 'package:dio/dio.dart';
class Homescreenservice{
  String Videolink = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics%2Cplayer&chart=mostPopular&maxResults=10&regionCode=IN&key=";
  //String Videolink = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics%2Cplayer&chart=mostPopular&maxResults=20&regionCode=IN&key=";
  String ChannelLogo = "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=";
  String key = "AIzaSyCv50vuOlIws-Gw2DDTqwkG5IlFMvuXZiw";
  Future<Map<String,dynamic>?> getInfo() async{
    final obj = Dio();
    final response = await obj.get(Videolink+key);
    return(response.data);
  }
  Future<Map<String,dynamic>?> getChannelLogo(String c_id) async{
    final obj = Dio();
    final response1 = await obj.get("$ChannelLogo$c_id&key=$key");
    
    return response1.data;
  }
}