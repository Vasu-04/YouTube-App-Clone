//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_application/miniProvider.dart';
import 'package:youtube_application/screens.dart/accounts.dart';
import 'package:youtube_application/screens.dart/player.dart';
import 'package:youtube_application/screens.dart/post.dart';
import 'package:youtube_application/screens.dart/searchScreen.dart';
import 'package:youtube_application/services/homeScreenService.dart';
import 'package:youtube_application/services/playerService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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

  List<String> bottomAppBar = [
    "All",
    'Auditions',
    'Comedy Nights with Kapil',
    'Music',
    'Sitcoms',
    'Live',
    'APIs',
    'Test',
    'Filmi',
    'Recently Uploaded',
    'Posts',
    'New to You',
  ];
  List<String> labels = [
    "Trending",
    "Shopping",
    "Music",
    "Movies",
    "Live",
    "Gaming",
    "News",
    "Sports",
    "Courses",
    "Fashion & Beauty",
    "Podcasts",
    "YouTube Premium",
    "YouTube Studio",
    "YouTube Music",
    "YouTube Kids"
  ];
  dynamic icons = [
    Icons.local_fire_department,
    Icons.shopping_bag_outlined,
    Icons.music_note_outlined,
    Icons.movie_filter_sharp,
    Icons.sensors_sharp,
    Icons.sports_esports_sharp,
    Icons.newspaper_sharp,
    Icons.sports_volleyball_sharp,
    Icons.lightbulb_outline_sharp,
    Icons.checkroom_sharp,
    Icons.podcasts_sharp,
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_4N37TIgWC_QLpspNwGddZH8DhzljeYMFnA&s",
    "https://static.wikia.nocookie.net/google/images/a/a4/YouTube_Studio_Icon_2021.png/revision/latest/scale-to-width-down/250?cb=20221123213524",
    "https://yt3.googleusercontent.com/ytc/AIdro_mO56fqbdXClEhesKEWoY4TpH3uei7wSv50LGzPaX5DuTs=s900-c-k-c0x00ffffff-no-rj",
    "https://play-lh.googleusercontent.com/iMc1P4fc7bMSVvQaztKcoQ5MS1J7OLu0bOkz2kVnXZTYkiJ_k3AluzkvOAntYCthgOXQ"
  ];
  bool _isExpanded = false;

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  List screens = [const Homescreen(), const Post(), const Accounts()];
  int currindex = 0;
  String v_id = "";
  Homescreenservice obj = Homescreenservice();
  var PlayerServiceObj = Playerservice();
  TextEditingController ctlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var miniPlayerObj = Provider.of<Miniprovider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leadingWidth: 130,
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: Image.network(
            "https://1000logos.net/wp-content/uploads/2017/05/Youtube-logo.jpg",
          ),
        ),
        actions: [
          AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isExpanded ? 200.0 : 110.0,
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? TextField(
                      controller: ctlr,
                      onSubmitted: (String Value) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Searchscreen(videoName: ctlr.text),
                          ),
                        );
                      },
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: 'Search...',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 16)
                          // border: OutlineInputBorder(

                          //   borderRadius: BorderRadius.circular(8.0),
                          // ),
                          ),
                    )
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.cast_sharp,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      ],
                    )),
          GestureDetector(
            onTap: _toggleSearch,
            child: const Icon(
              Icons.search,
              color: Colors.black,
              size: 35,
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: [
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(
                      Icons.explore_outlined,
                      size: 30,
                      color: Colors.black,
                    ),
                    //style: ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  );
                }),
                const SizedBox(
                  width: 20,
                ),
                ...bottomAppBar.map((element) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (element != "All") {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Searchscreen(
                                    videoName: element,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "$element",
                            style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ))
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 30,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        width: MediaQuery.sizeOf(context).width / 2 + 100,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Image.network(
                  "https://1000logos.net/wp-content/uploads/2017/05/Youtube-logo.jpg",
                  width: 150,
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton.icon(
                        onPressed: () {},
                        label: Text(
                          "${labels[index]}",
                          style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                        ),
                        icon: (index < 11)
                            ? Icon(
                                icons[index],
                                size: 30,
                                color: Colors.black,
                              )
                            : Image.network(
                                icons[index],
                                width: 30,
                                height: 30,
                              ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            side: const BorderSide(color: Colors.white),
                            shape: const ContinuousRectangleBorder(),
                            alignment: Alignment.centerLeft),
                      );
                    },
                  ),
                ),
              ),
              const BottomAppBar(
                color: Colors.white,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Privacy Policy ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black38,
                            fontWeight: FontWeight.w400)),
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.black38,
                    ),
                    Text(
                      " Terms of Service",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black38,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: obj.getInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Connection Lost!"));
              } else if (snapshot.hasData) {
                var data = snapshot.data;
                var items = data?["items"] ?? [];

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      shape: const ContinuousRectangleBorder(),
                      color: Colors.white,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (miniPlayerObj.isMiniPlayerVisible == true)
                                miniPlayerObj.toggleMiniPlayer();
                              miniPlayerObj.initState(items[index]["id"]);
                              v_id = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YoutubeVideoPlayer(
                                    videoId: items[index]["id"],
                                  ),
                                ),
                              );
                              if (v_id.isNotEmpty) miniPlayerObj.setVideo(v_id);
                              setState(() {});
                            },
                            icon: Image.network(items[index]["snippet"]
                                    ["thumbnails"]["maxres"]?["url"] ??
                                items[index]["snippet"]["thumbnails"]["high"]
                                    ["url"]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<Map<String, dynamic>?>(
                                  future: obj.getChannelLogo(
                                      items[index]["snippet"]["channelId"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: Text("Connection Lost!"));
                                    } else if (snapshot.hasData) {
                                      return CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot
                                                        .data?["items"][0]
                                                    ["snippet"]["thumbnails"]
                                                ["default"]["url"] ??
                                            ''),
                                        radius: 25,
                                      );
                                    } else {
                                      return const Center(
                                          child: Text("No Data Found"));
                                    }
                                  },
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(top: 0)),
                                    onPressed: () async {
                                      if (miniPlayerObj.isMiniPlayerVisible ==
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
                                          padding: const EdgeInsets.all(0),
                                          width: 330,
                                          height: 50,
                                          decoration: const ShapeDecoration(
                                              //color: Colors.yellow,
                                              shape:
                                                  ContinuousRectangleBorder()),
                                          child: Text(
                                            items[index]["snippet"]["title"],
                                            style: GoogleFonts.outfit(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: const ShapeDecoration(
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
                                                    color: Colors.black38),
                                              ),
                                              const Icon(
                                                Icons.circle,
                                                size: 3,
                                                color: Colors.black38,
                                              ),
                                              Text(
                                                " " +
                                                    simplifyNumber(int.parse(
                                                        items[index]
                                                                ["statistics"]
                                                            ["viewCount"])) +
                                                    " views" +
                                                    " ",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black38),
                                              ),
                                              const Icon(
                                                Icons.circle,
                                                size: 3,
                                                color: Colors.black38,
                                              ),
                                              Text(
                                                " " +
                                                    timeAgo(DateTime.parse(
                                                        items[index]["snippet"]
                                                            ["publishedAt"])) +
                                                    " ",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black38),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 0),
                                              itemCount: smbsicons.length,
                                              itemBuilder: (context, index) {
                                                return ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                    side: const BorderSide(
                                                        color: Colors.white),
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 0),
                                                    child: Text(
                                                      smbsoptions[index],
                                                      style: GoogleFonts.outfit(
                                                        textStyle:
                                                            const TextStyle(
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
                    );
                  },
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
          Consumer<Miniprovider>(
            builder: (context, miniPlayerObj, child) {
              return miniPlayerObj.isMiniPlayerVisible
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                color: Colors.black38,
                              ))),
                          height: 58,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              miniPlayerObj.controller != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        width: 150,
                                        child: YoutubePlayer(
                                          aspectRatio: 30 / 20,
                                          controller: miniPlayerObj.controller!,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: const CircularProgressIndicator(
                                        color: Colors.black38,
                                      ),
                                    ),
                              Expanded(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder<Map<String, dynamic>?>(
                                        future:
                                            PlayerServiceObj.getVideoInfo(v_id),
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
                                            var data = snapshot.data;
                                            var items = data?["items"] ?? [];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 130,
                                                  child: Text(
                                                    items[0]["snippet"]
                                                        ["title"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.outfit(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        //fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    items[0]["snippet"]
                                                        ["channelTitle"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black38),
                                                    )),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: Text("No Data Found"),
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        alignment: Alignment.topCenter,
                                        icon: Icon(
                                          size: 38,
                                          miniPlayerObj
                                                  .controller!.value.isPlaying
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          miniPlayerObj
                                                  .controller!.value.isPlaying
                                              ? miniPlayerObj.controller!
                                                  .pause()
                                              : miniPlayerObj.controller!
                                                  .play();
                                          setState(() {});
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          size: 38,
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          miniPlayerObj.toggleMiniPlayer();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    miniPlayerObj.toggleMiniPlayer();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => YoutubeVideoPlayer(
                                              videoId: v_id)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
