import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Miniprovider extends ChangeNotifier {
  YoutubePlayerController? _controller;
  bool _isMiniPlayerVisible = false;
  YoutubePlayerController? get controller => _controller;
  bool get isMiniPlayerVisible => _isMiniPlayerVisible;

  void initState(String videoId) {
    _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(autoPlay: true, mute: false));
        notifyListeners();
  }

  void setVideo(String id){
    controller?.load(id);
    notifyListeners();
  }

  

  void toggleMiniPlayer(){
    _isMiniPlayerVisible = !_isMiniPlayerVisible;
  }

  void disposeController() {
    _controller?.dispose();
    _controller = null;
    notifyListeners();
  }
}
