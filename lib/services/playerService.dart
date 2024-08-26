import 'package:dio/dio.dart';

class Playerservice{
  String videoInfoLink = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=";
  final obj = Dio();
  String key = "AIzaSyCv50vuOlIws-Gw2DDTqwkG5IlFMvuXZiw";
  Future<Map<String,dynamic>?> getVideoInfo(String videoId) async{
    final response = await obj.get(videoInfoLink + videoId + "&key=" + key);
    return response.data;
  }
}