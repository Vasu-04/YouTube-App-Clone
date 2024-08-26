import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_application/miniProvider.dart';
import 'package:youtube_application/screens.dart/homeScreen.dart';

import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => Miniprovider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Homescreen(),
        )),
  );
}