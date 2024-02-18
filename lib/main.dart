import 'dart:math';
import 'package:flutter/material.dart';

void main(){
  runApp( MyApp() );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  var keys = ["A", "B", "C", "D", "E", "F", "G", "A♭", "B♭", "D♭", "E♭", "G♭", "C♯"];
  var qualities = ["major", "minor"];
  var quotes = ["You can do this!", "Live, laugh, love.", "Your teacher will be proud.",
    "Good luck!", "Nothing is impossible.", "No, this is Patrick!"];
  String quote = '';
  String scale = '';
  
  @override
  void initState() {
    super.initState();
    onPressed();
  }

  void onPressed() {
    print('pressed');
    Random random = Random();
    int randomNumber;
    int randomQuality;
    int randQuote;
    String previousQuote = '';
    String previousScale = '';
    
    do {
      randomNumber = random.nextInt(keys.length);
      randomQuality = random.nextInt(qualities.length);
    } while ("${keys[randomNumber]} ${qualities[randomQuality]}" == previousScale);
    scale = "${keys[randomNumber]} ${qualities[randomQuality]}";

    do {
      randQuote = random.nextInt(quotes.length);
    } while (quotes[randQuote] == previousQuote);
    quote = quotes[randQuote];

    setState(() {
      scale;
      previousScale = scale;
      previousQuote = quote;
    });
    }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onTap: onPressed,
          child: Center(
            child: Text(
              scale,
              style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            child: Text(
              textAlign: TextAlign.center, 
              style: const TextStyle(
                color: Colors.grey,
              ),
              quote,
            )
          )
        ),
      ),
    );
  }
}