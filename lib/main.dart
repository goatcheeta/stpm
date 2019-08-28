//STPM 6/14/2019. 1.02
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
 
 // Set portrait orientation
SystemChrome.setPreferredOrientations([
   DeviceOrientation.portraitDown,
   DeviceOrientation.portraitUp,
]);
  
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new MyHomePage(),
    );
  }

  
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

      //Check internet here
@override
  void initState() {
    checkinternet();
    
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_sorts);
    _selectedSort = _dropDownMenuItems[0].value;
    this.makeRequest();
    super.initState();


    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  
     String _message ;

_firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> msg) {
  if (Theme.of(context).platform == TargetPlatform.iOS)
      _message = msg['aps']['alert'];
  else
      _message = msg['notification']['body'];
      _showAlert(context, _message);
  //print(_message);
},
onResume: (Map<String, dynamic> msg) {
  if (Theme.of(context).platform == TargetPlatform.iOS)
      _message = msg['aps']['alert'];
  else
      _message = msg['notification']['body'];
      _showAlert(context, _message);
//  print(_message);
},
onLaunch: (Map<String, dynamic> msg) {
  if (Theme.of(context).platform == TargetPlatform.iOS)
      _message = msg['aps']['alert'];
  else
      _message = msg['notification']['body'];
//  print(_message);
_showAlert(context, _message);
},
);

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      
    });
   
  }

  List _sorts = ["Date Descending", "Name Ascending", "Date Ascending", "Name Descending"];
  
          
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedSort;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List sorts) {
    List<DropdownMenuItem<String>> items = new List();
    for (String sort in sorts) {
      items.add(new DropdownMenuItem(value: sort, child: new Text(sort)));
    }
    return items;
  }

  
  Future<String> changedDropDownItem(String selectedSort) async {
      

      _selectedSort = selectedSort;

      switch (_selectedSort) {
        case "Name Ascending":
          {
            url = "https://churchsp.org/mob/sp_title_a.json";
          }
          break;

        case "Name Descending":
          {
            url = "https://churchsp.org/mob/sp_title_d.json";
           
          }
          break;
        case "Date Ascending":
          {
            url = "https://churchsp.org/mob/sp_date_a.json";
           
          }
          break;
        case "Date Descending":
          {
            url = "https://churchsp.org/mob/sp_date_d.json";
          }
          break;

        default:
          {
            //statements;
          }
          break;
     
      }   
   
     var response = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
     
      data = null;
      setState(() {
        
      var extractdata = json.decode(response.body);
      data = extractdata["results"];
     // print(data);
     });
      return Uri.encodeFull(url);
  
  }
    
  
  Future<String>checkinternet() async {
   String connectmessage ;
   var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      connectmessage="No Internet. You are not connected to a newwork"     ;
      _showAlert(context, connectmessage);
    } else if (result == ConnectivityResult.mobile) {
      //connectmessage="Internet. You are connected over mobile data"     ;
     // _showAlert(context, connectmessage);
      
    } else if (result == ConnectivityResult.wifi) {
      //connectmessage="Internet. You are connected over wifi"     ;
      //_showAlert(context, connectmessage);
     
    }
    return "" ;
  }

  
  void _showAlert(BuildContext context, $message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Notification"),
              content: Text($message),
            actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],

            ));
  }


  int _currentIndex = 0;
  List<int> _children = [0, 1, 2, 3];

  String url = 'https://churchsp.org/mob/sp_date_d.json';
  
  List data;
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["results"];
    });

    return Uri.encodeFull(url);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: new AppBar(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(25.0),
          child: new AppBar(
              backgroundColor: const Color(0xFF0099a9),
              centerTitle: true,
              title: Text("St. Peters Mobile"))),

      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _children[_currentIndex],
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.mail), title: Text('Day By Day')),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), title: Text('Daily Office')),
            BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('BCP')),
            BottomNavigationBarItem(
                icon: Icon(Icons.face), title: Text('Bible')),
            BottomNavigationBarItem(
               icon: Icon(Icons.announcement), title: Text('Privacy'))
          ]), //COMMA!

      body: Column(children: [
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          // var now = new DateTime.now();
          //var formatter = new DateFormat('yyyy-MM-dd');
          //String formatted = formatter.format(now);
          //   print(formatted); // something like 2013-04-20

          Text(
            currentdate(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        new Container(
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          //MediaQueryData queryData;
          //queryData = MediaQuery.of(context);
          height: MediaQuery.of(context).size.height / 3,
          //height:225,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    'assets/images/stpeters_1800px.jpg')), //Box decoration
          ), // DecorationImage
        ),
        new Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text("   Choose sort:     ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            new DropdownButton(
              value: _selectedSort,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ) ],
        ),
        Flexible(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, i) {
                  return new ListTile(
                      title: new Text(
                        data[i]["Title"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      //subtitle: new Text(data[i]["Description"]),
                      trailing: new Text(data[i]["Description"],
                          style: new TextStyle(
                              fontFamily: "Roboto", fontSize: 15.0)),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://www.churchsp.org/sites/default/files/images9/belfry_100px.jpg"),
                      ),
                      //backgroundColor: Colors.teal,
                      //child: Text('SP')),

                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new SecondPage(data[i])));
                      } //onTap
                      );
                }))
      ] //Children

          ),
    );
  }
} //Widget build
 

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text(data["Title"])),
      body: WebView(
          initialUrl: data["URL"],
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.clearCache();
          }));
}

String currentdate() {
  var now = new DateTime.now();
  var formatter = new DateFormat('EEEE MMMM dd, yyyy');
  String formatted = formatter.format(now);
  return formatted;
}

void onTabTapped(int index) {
  int _currentIndex = index;
  //print(_currentIndex);
  var url = '';
  switch (_currentIndex) {
    case 0:
      url = 'https://churchsp.org/mob/daybyday.html';
     // print(url);
      launch(url);
      break;

    case 1:
      url = 'https://churchsp.org/mob/dailyoffice.html';
      //print(url);
      launch(url);
      break;

    case 2:
      url = 'https://churchsp.org/mob/bcponline.html';
      //print(url);
      launch(url);
      break;

    case 3:
      url = 'https://churchsp.org/mob/bible.html';
      //print(url);
      launch(url);
      break;
    case 4:
      url = 'https://churchsp.org/mob/stpetersmobile_privacy_policy.html';
      //print(url);
      launch(url);
      break;
  } //Switch _currentIndex
}
