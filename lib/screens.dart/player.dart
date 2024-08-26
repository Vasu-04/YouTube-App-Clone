import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_application/miniProvider.dart';
import 'package:youtube_application/services/filterSearchService.dart';
import 'package:youtube_application/services/homeScreenService.dart';
import 'package:youtube_application/services/playerService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({super.key, required this.videoId});
  final String videoId;
  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()}yr${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()}month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}hr ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} m${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

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

  var options = ['Share', 'Remix', 'Stop Ads', 'Save', 'Report'];
  var icons = [
    Icons.send,
    Icons.playlist_add,
    Icons.block,
    Icons.content_cut_outlined,
    Icons.bookmark_border_outlined,
    Icons.flag_outlined
  ];

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

  String likeChoice = "";
  String v_id = "";
  String videoName = "";

  Playerservice obj = Playerservice();
  Homescreenservice homeScreenServiceObj = Homescreenservice();
  Filtersearchservice filterSearchServiceObj = Filtersearchservice();

  @override
  Widget build(BuildContext context) {
    var miniPlayerObj = Provider.of<Miniprovider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(255),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: miniPlayerObj.controller != null
                ? Column(
                    children: [
                      YoutubePlayer(
                        topActions: [
                          IconButton(
                            onPressed: () {
                              miniPlayerObj.toggleMiniPlayer();
                              Navigator.pop(context, widget.videoId);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 20,
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black,
                            ),
                          ),
                        ],
                        controller: miniPlayerObj.controller!,
                        showVideoProgressIndicator: true,
                      )
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: obj.getVideoInfo(widget.videoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else if (snapshot.hasError)
                  return Center(
                    child: Text("Connection Lost !"),
                  );
                else if (snapshot.hasData) {
                  var items = snapshot.data?["items"] ?? [];
                  videoName = items[0]["snippet"]['title'];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              shape: const ContinuousRectangleBorder()),
                          onPressed: () {},
                          child: Container(
                            decoration: const ShapeDecoration(
                                shape: ContinuousRectangleBorder()),
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.sizeOf(context).width - 20,
                            //decoration: BoxDecoration(color: Colors.amber),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[0]["snippet"]["title"],
                                  maxLines: 2,
                                  style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width / 2,
                                  //decoration: BoxDecoration(color: Colors.blue),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    items[0]["statistics"]["viewCount"] +
                                        " views  " +
                                        timeAgo(
                                          DateTime.parse(
                                            items[0]["snippet"]["publishedAt"],
                                          ),
                                        ) +
                                        " #" +
                                        (items[0]["snippet"]
                                                    .containsKey("tags") &&
                                                items[0]["snippet"]["tags"]
                                                    .isNotEmpty
                                            ? " #" +
                                                items[0]["snippet"]["tags"][0]
                                            : "") +
                                        " #" +
                                        (items[0]["snippet"]
                                                    .containsKey("tags") &&
                                                items[0]["snippet"]["tags"]
                                                        .length >
                                                    1
                                            ? " #" +
                                                items[0]["snippet"]["tags"][1]
                                            : ""),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color:
                                            const Color.fromARGB(80, 0, 0, 0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width - 30,
                                child: FutureBuilder<Map<String, dynamic>?>(
                                  future: homeScreenServiceObj.getChannelLogo(
                                      items[0]["snippet"]["channelId"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    else if (snapshot.hasError)
                                      return Center(
                                        child: Text("Connection Lost !"),
                                      );
                                    else if (snapshot.hasData) {
                                      var items1 =
                                          snapshot.data?["items"] ?? [];

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: items1
                                                                .isNotEmpty &&
                                                            items1[0]["snippet"]
                                                                            [
                                                                            "thumbnails"]
                                                                        [
                                                                        "default"]
                                                                    ["url"] !=
                                                                null
                                                        ? NetworkImage(
                                                            items1[0]["snippet"]
                                                                    [
                                                                    "thumbnails"]
                                                                [
                                                                "default"]["url"],
                                                          )
                                                        : null,
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    items1[0]["snippet"]
                                                            ["title"] +
                                                        " ",
                                                    style: GoogleFonts.outfit(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                  Text(
                                                      simplifyNumber(
                                                        int.parse(
                                                          items1[0]
                                                                  ["statistics"]
                                                              [
                                                              "subscriberCount"],
                                                        ),
                                                      ),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              80, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              alignment: Alignment.centerRight,
                                              backgroundColor: Colors.black,
                                              maximumSize:
                                                  const Size.fromWidth(130),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              "Subscribe",
                                              style: GoogleFonts.outfit(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const Center(
                                        child: Text("No Data Found !"),
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      //color: Colors.black38,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              fixedSize:
                                                  const Size.fromWidth(115),
                                              foregroundColor: Colors.blue,
                                              side: const BorderSide(
                                                  color: Colors.black38)),
                                          onPressed: () {
                                            if (likeChoice == "liked" ||
                                                likeChoice == "") {
                                              int value = int.parse(items[0]
                                                  ["statistics"]["likeCount"]);
                                              value++;
                                              items[0]["statistics"]
                                                      ["likeCount"] =
                                                  value.toString();
                                            }
                                            likeChoice = "liked";
                                          },
                                          icon: const Icon(
                                            Icons.thumb_up,
                                            color: Colors.blue,
                                          ),
                                          label: Text(
                                            simplifyNumber(
                                              int.parse(
                                                items[0]["statistics"]
                                                    ["likeCount"],
                                              ),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        const Text(
                                          "|",
                                          style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                fixedSize:
                                                    const Size.fromWidth(30),
                                                foregroundColor: Colors.red,
                                                side: const BorderSide(
                                                    color: Colors.black38)),
                                            onPressed: () {
                                              if (likeChoice == "liked" ||
                                                  likeChoice == "") {
                                                int value = int.parse(items[0]
                                                        ["statistics"]
                                                    ["likeCount"]);
                                                value--;
                                                items[0]["statistics"]
                                                        ["likeCount"] =
                                                    value.toString();
                                              }
                                              likeChoice = "unliked";
                                            },
                                            child: const Icon(
                                              Icons.thumb_down,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 200, top: 0),
                              height: 70, // Adjust the height as needed
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(),
                                scrollDirection: Axis.horizontal,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        maximumSize: const Size.fromWidth(150),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 0,
                                        ),
                                        elevation: 0),
                                    onPressed: () {
                                      // Handle button press
                                    },
                                    icon: Icon(
                                      icons[index],
                                      color: Colors.black,
                                    ),
                                    label: Text(
                                      options[index],
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              overlayColor: Colors.black),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: AppBar(
                                      title: const Text("Comments"),
                                      leading: const Text(""),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.black12),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Comments",
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      items[0]["statistics"]["commentCount"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      size: 35,
                                      color: Colors.purple,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.sizeOf(context).width -
                                          110,
                                      height: 30,
                                      decoration: ShapeDecoration(
                                          color: Colors.black12,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: const Text(
                                        "Add to Comment...",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Data Not Found"),
                  );
                }
              },
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: filterSearchServiceObj.getFilteredData(videoName),
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
                                        items[index]["id"]["videoId"]);
                                    //  miniPlayerObj.setVideo(items[index]["id"]["videoId"]);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            YoutubeVideoPlayer(
                                          videoId: items[index]["id"]
                                              ["videoId"],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Image.network(
                                    items[index]["snippet"]["thumbnails"]
                                        ["high"]["url"],
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
                                                  ["snippet"]["channelId"]),
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
                                                        ["high"]["url"]),
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
                                                .initState(items[index]["id"]);
                                            v_id = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    YoutubeVideoPlayer(
                                                  videoId: items[index]["id"],
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
                                                      ["title"],
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
                                                              ["channelTitle"] +
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
                                                                ["videoId"]),
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
                                                                          "viewCount"])) +
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
            )
          ],
        ),
      ),
    );
  }
}
