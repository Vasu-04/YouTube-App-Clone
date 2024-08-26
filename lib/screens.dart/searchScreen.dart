import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_application/miniProvider.dart';
import 'package:youtube_application/screens.dart/player.dart';
import 'package:youtube_application/services/filterSearchService.dart';
import 'package:youtube_application/services/homeScreenService.dart';
import 'package:youtube_application/services/playerService.dart';


class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key, required this.videoName});
  final String videoName;
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController ctlr = TextEditingController();
  int currindex =0;

  List<String> smbsoptions = [
    'Play next in queue',
    'Save to Watch Later',
    'Save to playlist',
    'Download Video',
    'Share',
    'Not Interested',
    'Don\'t Recommend Channel',
    'Report',
  ];

  var smbsicons = [
    Icons.queue_outlined,
    Icons.watch_later_outlined,
    Icons.bookmark_border_outlined,
    Icons.download_outlined,
    Icons.screen_share_outlined,
    Icons.block_outlined,
    Icons.recommend_outlined,
    Icons.flag_outlined
  ];

  String simplifyNumber(int number) {
    if (number >= 1000000000) {
      return (number / 1000000000).toStringAsFixed(1) + 'B';
    } else if (number >= 1000000) {
      return (number / 1000000).toStringAsFixed(1) + 'M';
    } else if (number >= 1000) {
      return (number / 1000).toStringAsFixed(1) + 'k';
    } else {
      return number.toString();
    }
  }

  String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String v_id = "";
  Playerservice obj = Playerservice();
  Filtersearchservice filterSearchServiceObj = Filtersearchservice();
  Homescreenservice homeScreenServiceObj = Homescreenservice();

  @override
  Widget build(BuildContext context) {
    var miniPlayerObj = Provider.of<Miniprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        actions: [
          IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: Colors.black,
          ),
        ),
          Expanded(
            child: TextField(
              onSubmitted: (String Value) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Searchscreen(videoName: ctlr.text),
                          ),
                        );
                      },
              controller: ctlr,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: widget.videoName,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.mic,
              size: 35,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.cast,
              size: 35,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: 35,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: Colors.black,
                size: 24,
              ),
              label: "Post"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              label: "Account"),
        ],
        backgroundColor: Colors.white,
        currentIndex: currindex,
        onTap: (value) {
          setState(() {
            currindex = value;
          });
        },
      ),
      body: Container(
        child: FutureBuilder<Map<String, dynamic>?>(
                future: filterSearchServiceObj.getFilteredData(widget.videoName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else if (snapshot.hasError)
                    return Center(
                      child: Text("Connection Lost"),
                    );
                  else if (snapshot.hasData) {
                    var data = snapshot.data;
                    var items = data?["items"] ?? [];
                    return ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: ContinuousRectangleBorder(),
                          color: Colors.white,
                          elevation: 0,
                          child: Container(
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    miniPlayerObj.initState(
                                        items[index]["id"]["videoId"]??"");
                                    //  miniPlayerObj.setVideo(items[index]["id"]["videoId"]);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            YoutubeVideoPlayer(
                                          videoId: items[index]["id"]
                                              ["videoId"]??"",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Image.network(
                                    items[index]["snippet"]["thumbnails"]
                                        ["high"]["url"]??"",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 3, left: 4),
                                  child: Row(
                                    children: [
                                      FutureBuilder<Map<String, dynamic>?>(
                                          future: homeScreenServiceObj
                                              .getChannelLogo(items[index]
                                                  ["snippet"]["channelId"]??""),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            else if (snapshot.hasError)
                                              return Center(
                                                child: Text("Connection Lost"),
                                              );
                                            else if (snapshot.hasData) {
                                              var items =
                                                  snapshot.data?["items"] ?? [];
                                              return CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                    items[0]["snippet"]
                                                            ["thumbnails"]
                                                        ["high"]["url"]??""),
                                              );
                                            } else {
                                              return const Center(
                                                child: Text("No Data Found!"),
                                              );
                                            }
                                          }),
                                      Expanded(
                                        child: TextButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.only(top: 0)),
                                          onPressed: () async {
                                            if (miniPlayerObj
                                                    .isMiniPlayerVisible ==
                                                true)
                                              miniPlayerObj.toggleMiniPlayer();
                                            miniPlayerObj
                                                .initState(items[index]["id"]??"");
                                            v_id = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    YoutubeVideoPlayer(
                                                  videoId: items[index]["id"]??"",
                                                ),
                                              ),
                                            );
                                            if (v_id.isNotEmpty)
                                              miniPlayerObj.setVideo(v_id);
                                            setState(() {});
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                width: 330,
                                                height: 50,
                                                decoration:
                                                    const ShapeDecoration(
                                                        //color: Colors.yellow,
                                                        shape:
                                                            ContinuousRectangleBorder()),
                                                child: Text(
                                                  items[index]['snippet']
                                                      ["title"]??"",
                                                  style: GoogleFonts.outfit(
                                                    textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration:
                                                    const ShapeDecoration(
                                                        //color: Colors.yellow,
                                                        shape:
                                                            ContinuousRectangleBorder()),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      items[index]["snippet"]
                                                              ["channelTitle"] ??"" +
                                                          " ",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black38),
                                                    ),
                                                    const Icon(
                                                      Icons.circle,
                                                      size: 3,
                                                      color: Colors.black38,
                                                    ),
                                                    FutureBuilder<
                                                            Map<String,
                                                                dynamic>?>(
                                                        future: obj
                                                            .getVideoInfo(items[
                                                                    index]["id"]
                                                                ["videoId"]??""),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting)
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          else if (snapshot
                                                              .hasError)
                                                            return Center(
                                                              child: Text(
                                                                  "Connection Lost"),
                                                            );
                                                          else if (snapshot
                                                              .hasData) {
                                                            var items = snapshot
                                                                        .data?[
                                                                    "items"] ??
                                                                [];
                                                            return Text(
                                                              " " +
                                                                  simplifyNumber(
                                                                      int.parse(items[0]
                                                                              [
                                                                              "statistics"]
                                                                          [
                                                                          "viewCount"] ??"")) +
                                                                  " views" +
                                                                  " ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                            );
                                                          } else {
                                                            return const Center(
                                                              child: Text(
                                                                  "No Data Found!"),
                                                            );
                                                          }
                                                        }),
                                                    const Icon(
                                                      Icons.circle,
                                                      size: 3,
                                                      color: Colors.black38,
                                                    ),
                                                    Text(
                                                      " " +
                                                          timeAgo(DateTime
                                                              .parse(items[
                                                                          index]
                                                                      [
                                                                      "snippet"]
                                                                  [
                                                                  "publishTime"])) +
                                                          " ",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black38),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              showDragHandle: true,
                                              useSafeArea: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: ListView.builder(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 0),
                                                    itemCount: smbsicons.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ElevatedButton
                                                          .icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 20,
                                                                  horizontal:
                                                                      20),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          shape:
                                                              const ContinuousRectangleBorder(),
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          smbsicons[index],
                                                          size: 35,
                                                          color: Colors.black,
                                                        ),
                                                        label: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 0),
                                                          child: Text(
                                                            smbsoptions[index],
                                                            style: GoogleFonts
                                                                .outfit(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 25,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  }
                },
              ),
      ),
    );
  }
}
