import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../UI.dart';
import 'package:trust/utils/TaskDatabase.dart';
import 'dart:math';
import '../models/Task.dart';

class CreateScreen extends StatefulWidget
{
  final Task task; //create a task variable that the create screen is going to edit
  CreateScreen({this.task});
  
  State<StatefulWidget> createState()
  {
    return _CreateScreen(this.task);
  }
}
class _CreateScreen extends State<CreateScreen> 
{
  String title;
  Task task;
  _CreateScreen(this.task);

  @override
  Widget build (BuildContext context) 
  {
    return new Scaffold( //draws the header and the body defined below
      backgroundColor: Colors.white, 
      body: Column(
        children: <Widget>[
          CreateHeader(),
          CreateBody(),
        ]
      )
    );
  }
}

class CreateHeader extends StatefulWidget
{
  @override
  _CreateHeader createState() => _CreateHeader();
}
class _CreateHeader extends State<CreateHeader>
{
  String topText = 'CREATE A NEW';
  String bottomText = 'TASK';

  void changeText(String text)
  {
    setState(() {
      topText = "hello";
    });
  }

  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h * .18,
      child: Padding(
        padding: EdgeInsets.only(top: 30,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              child: Text(
                topText,
                style: (TextStyle(color: Color(0xFF212121), fontSize: 34, fontFamily: 'Roboto-Bold', height: 1)),
              ),
            ),
            Align(
              child: Text(
                bottomText,
                style: (TextStyle(color: Color(0xFF212121), fontSize: 34, fontFamily: 'Roboto-Medium', height: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBody extends StatefulWidget
{
  @override
  _CreateBody createState() => _CreateBody();
}
class _CreateBody extends State<CreateBody>
{
  bool taskname = true; bool taskdisc = true; bool taskammt = true;
  double pLn = 20; double pRn = 20; double pRa = 20; double pLa = 20; //padding values
  String date; String time;

  final nameController = TextEditingController(); //controllers for editing the different input fields
  final discController = TextEditingController();
  final ammtController = TextEditingController();

  void updateDate(String _date) {setState(() {date = _date; /* print(_date); */});} //set the time and date it chooses to date and time
  void updateTime(String _time) {setState(() {time = _time; /* print(_time); */});}
  void createTask()
  {
    String name = nameController.text;
    String disc = discController.text;
    String ammt = ammtController.text;

    String dateTime = checkDate(date, time);
    bool check = checkInputs(name, disc, ammt);

    print(disc is String);
    if (check) Navigator.pop(context, [true, name, int.parse(ammt), dateTime, disc]); //if ithas all the fields, then destroy the screen and pass the array 
  }  
  String checkDate(String date, String time) //formats the date and time
  {
    final DateTime _dateTime = DateTime.now();
    date = date ?? _dateTime.toString().split(" ")[0];
    time = time ?? _dateTime.toString().split(" ")[1];
    return date + " " + time;
  }
  bool checkInputs(String name, String disc, String ammt)
  {
    void shakeName(int i) //shake the name field if empty
    {
      Future.delayed(Duration(milliseconds: 20)).then((_) 
      {
        if (i % 2 == 0) setState(() {pLn = 0; pRn = 4;});
        else            setState(() {pLn = 4; pRn = 0;});
        if (i != 5) shakeName(++i);
      });
    }

    void shakeAmmt(int i) //shake amount field if empty
    {
      Future.delayed(Duration(milliseconds: 20)).then((_) 
      {
        if (i % 2 == 0) setState(() {pLa = 0; pRa = 4;});
        else            setState(() {pLa = 4; pRa = 0;});
        if (i != 5) shakeAmmt(++i);
      });
    }

    bool check = true; bool ammtS = (int.parse(ammt) is! int); //if name or amnt is empty, make it so it shakes and makes the check false
    if (name == '') {setState(() {taskname = false;}); shakeName(0); setState(() {pRn = 20; pLn = 20;}); check = false;}
    if (ammt == '') {setState(() {taskammt = false;}); shakeAmmt(0); setState(() {pRa = 20; pLa = 20;}); check = false;}
    else if (ammtS) {setState(() {taskammt = false;}); shakeAmmt(0); setState(() {pRa = 20; pLa = 20;}); check = false;}
    return check;
  }

  @override
  void dispose() //unload the controllers after creating the task
  {
    nameController.dispose(); 
    discController.dispose();
    ammtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) //actually build the page  
  {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment(0, 1),
      child: Container(      
        height: h * .82, 
        width: w,  
        decoration: new BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(52),
            topRight: const Radius.circular(52),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(height: h * .05,), //spacer
            InputContainer.taskName(inputState: taskname, controller: nameController, paddingL: pLn, paddingR: pRn,),
            InputContainer.taskDisc(inputState: taskdisc, controller: discController, paddingL: 20,  paddingR: 20, ),
            InputContainer.taskAmmt(inputState: taskammt, controller: ammtController, paddingL: pLa, paddingR: pRa,),
            Container(
              width: w * .8,
              margin: EdgeInsets.only(bottom: 28),
              child: DatePicker
                      (onDateChanged: (String _date) {updateDate(_date);}, 
                      onTimeChanged: (String _time) {updateTime(_time);}),
            ),
            Button.create(clicked: () //custom button in ui.dart
              {
                createTask();
              },
            ),
            Button.back(clicked: () {Navigator.pop(context, [false]);},),
          ],
        ), 
      ),
    );
  }
}

class InputContainer extends StatefulWidget
{
  TextEditingController controller;
  bool inputState = true;
  String text;double width;
  int lines;
  TextInputType type;
  double paddingL;
  double paddingR;

  InputContainer.taskName({this.controller, this.inputState, this.paddingL, this.paddingR})  //define the namefield
  {text = "Task Name"; lines = 1; width = 1; type = TextInputType.text;}

  InputContainer.taskDisc({this.controller, this.inputState, this.paddingL, this.paddingR})
   {text = "Description"; lines = 3; width = 1; type = TextInputType.text;}

  InputContainer.taskAmmt({this.controller, this.inputState, this.paddingL, this.paddingR}) //define the amnt field and how it's only a number
  {text = "Pledge Amount"; lines = 1; width = .64; type = TextInputType.number;}

  InputContainer({this.controller, this.inputState, this.text, this.type, this.paddingL, this.paddingR});

  _InputContainer createState() => _InputContainer();
}
class _InputContainer extends State<InputContainer> //draw how each of them has an outline and the font style
{
  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * .8 * widget.width,
      margin: EdgeInsets.only(bottom: h * .02),
      child: Padding(  
        padding: EdgeInsets.only(), 
        child: TextField(
          keyboardType: widget.type,
          maxLines: widget.lines,
          controller: widget.controller,
          obscureText: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: widget.paddingL, right: widget.paddingR, top: 20, bottom: 20),
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(18.0),),
            ),
            hintText: widget.text,
            hintStyle: TextStyle(color: (widget.inputState ? Color(0xFF323639) : Colors.red),),
          ), 
          style: TextStyle(
            fontSize: 19,
            height: .95
          ),
        ),        
      ),
    );
  }
}