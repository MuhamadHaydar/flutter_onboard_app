import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool onScreen;

// Here we have to add the future because we need to await for data comes back
// from shared preferences. We use the boolean data to decide to which screen to
// open.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create a shared preference to store data.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('get preference');
// Try reading data from the counter key. If it doesn't exist, return 0.
  onScreen =  prefs.getBool('onboard') ?? true;
  print(onScreen);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //make a status bar color transparent
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction Screen',
      debugShowCheckedModeBanner: false,
      home: onScreen ? OnBoardingPage() : HomePage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  //Store current page
  int _currentPage = 0;

  //Method is called at the end, When done button clicked.
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  //Method Creates the widget that represent image.
  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(
        'images/$assetName.png',
        width: 350,
        height: 300,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    //When user comes to onboarding Screen it must be false, because for the other time
    //User must not see this screen again.
    setPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //style for body.
    const bodyStyle = TextStyle(fontSize: 19.0);

    //Decoration of the background page.
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    //List of colors for indicator.
    List<Color> indecatorColors = [
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.green
    ];

    //Widget comes from the dependency. it's used to draw whole of views.
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Hi!",
          body:
              "I am Nasrin, I am here to help you for organising and managing your day usefully.",
          image: _buildImage('nasrin_intro'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Time!",
          body:
              "I care of your time sirously, here you can manipulate your time effeciently.",
          image: _buildImage('nasrin_time'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Tasks!",
          body:
              "Is it important? Yea of course, Therefore You can manage your tasks with me.",
          image: _buildImage('nasrin_order'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Points!",
          body:
              'You can be the best by collect whole of points through the week.',
          image: _buildImage('nasrin_point'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onChange: (int page) {
        print('Color Changed');
        setState(() {
          _currentPage = page;
          print(_currentPage);
        });
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      showNextButton: true,
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: indecatorColors[_currentPage],
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  // Set data to the preference.
  void setPreference() async {
    // obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // set value
    prefs.setBool('onboard', false);
    print('SetPreference Method');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
