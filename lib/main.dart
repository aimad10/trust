import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/HomeScreen.dart';
import 'screens/SignUpScreen.dart';
import 'package:flutter/services.dart';
//Here we import libraries and other things that we created 


void main() => runApp(App()); //the main function is just to run App()

class App extends StatefulWidget //Our main app is extending Stateful because 
{
  @override
  _App createState() => new _App(); //The state it's creating is _app, private _app
}



class _App extends State<App>
{
  bool _seen; //declare a boolean to see if the welcome page has been seen first. 

  //set bar color
  @override
  void initState() 
  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle( //sets the top bar of android to be white, and sets the brightnesses
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark, 
    ));
    _checkFirstTime();
    super.initState(); //calls the constructor, in this case state<app> which is stateful class. Not neccesary in new flutter. 
  }



  _checkFirstTime() async //async function that checks if first time setup is true
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();  //load the local storage and wait to finish getting it before setting the state
    setState( () //notify flutter to schedule a rebuild (don't show splash screen) if true
    {
      _seen = (prefs.getBool('seen') ?? false); // if in local storage seen does not have a value, set it to false so it correctly renders
    });
  }  

  _updateFirstTime() async //if they've seen splash screen, then update the fact that it's been seen 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    _seen = true;
    prefs.setBool('seen', true);
  }
  Widget build(BuildContext context) //finally, build the screen 
  {
    
    if (_seen == null) return Container(); //if it's null, which would only happen over first time
    if (_seen == false) {_updateFirstTime();} //if it's been seen, update the fact it's been seen 

    bool seen = _seen;  
    return MaterialApp( 
      debugShowCheckedModeBanner: false, 
      home: seen ? HomeScreen() : SignUpScreen(), //either show signup screen or home screen based on _seen (homescreen is splash)
    );
  } 
}
