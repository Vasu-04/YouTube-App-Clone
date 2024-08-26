import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Filteredscreen extends StatefulWidget {
  const Filteredscreen({super.key,required this.videoName});
  final String videoName;
  @override
  State<Filteredscreen> createState() => _FilteredscreenState();
}

class _FilteredscreenState extends State<Filteredscreen> {

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

  int currindex = 0;

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
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
                          onPressed: () {},
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
    )
    ;
  }
}