import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'week_report.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Sarala'),
      home: Home(),
      routes: <String, WidgetBuilder>{
        '/MoodTracker': (BuildContext context) => MoodTracker(),
        '/Settings': (BuildContext context) => Settings(),
        '/SignIn': (BuildContext context) => SignIn(),
      },
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          backgroundColor: Color(0xFF003468),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/Settings');
                }),
          ],
          leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/SignIn');
              }),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('images/logo.png',
                      width: 300, height: 300, fit: BoxFit.fitWidth),
                  Container(
                    width: 330.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(bottom: 80.0),
                    child: Opacity(
                      opacity: 0.85,
                      child: FlatButton(
                        color: Color(0xFF003468),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('MY MOOD TRACKER',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/MoodTracker');
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 330.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(bottom: 80.0),
                    child: Opacity(
                      opacity: 0.85,
                      child: FlatButton(
                        color: Color(0xFF003468),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('CLASSIFIER DEMO',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Classifier()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  List<String> months = [
    'January 2020',
    'February 2020',
    'March 2020',
    'April 2020'
  ];
  List<WeekReport> april = [
    WeekReport(
        wB: '06/04', rating: 0.2, report: ['08/04 12:09:44', 'None', 'False']),
    WeekReport(
        wB: '13/04',
        rating: 0.9,
        report: ['14/04 08:12:31', '17/04 23:42:03', 'True']),
    WeekReport(
        wB: '20/04',
        rating: 0.6,
        report: ['26/04 09:23:37', '22/04 19:17:26', 'False']),
    WeekReport(
        wB: '27/04', rating: 0.3, report: ['27/04 16:11:54', 'None', 'False']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('Mood Tracker'),
        centerTitle: true,
        backgroundColor: Color(0xFF003468),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/Settings');
              }),
        ],
      ),
      body: ListView.builder(
          itemCount: april.length,
          itemBuilder: (context, index) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  child: ExpansionTile(
                      title: Text(months[index],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      children:
                          april.map((week) => WeekCard(week: week)).toList()),
                ));
          }),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String loginState = ' |  Sign in with Twitter';

  void _signInTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'UNsEOEtHtrJ6bePIt1dIXJqz8',
      consumerSecret: 'J13UIgk0j9IrTDfU2ZOdyQ1L2BdhblMqqMiCoj7Qicm9igK01e',
    );

    if (loginState == ' |  Sign out') {
      setState(() {
        loginState = ' |  Sign in with Twitter';
      });
      return await twitterLogin.logOut();
    }

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        setState(() {
          loginState = ' |  Sign out';
        });
        print(session.username);
        //_sendTokenAndSecretToServer(session.token, session.secret);
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('Cancelled by user');
        //_showCancelMessage();
        break;
      case TwitterLoginStatus.error:
        print(result.errorMessage);
        // _showErrorMessage(result.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
        backgroundColor: Color(0xFF003468),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: Opacity(
                    opacity: 0.85,
                    child: FlatButton(
                      color: Color(0xFF003468),
                      textColor: Colors.white,
                      onPressed: () {
                        _signInTwitter();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.twitter,
                              color: Colors.white, size: 30.0),
                          Text(loginState,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFF003468),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('See your trustee contact',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            Divider(thickness: 1.0),
            ListTile(
              title: Text('About MoodSmart',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            Divider(thickness: 1.0),
          ],
        ),
      ),
    );
  }
}

class WeekCard extends StatelessWidget {
  final WeekReport week;
  WeekCard({this.week});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: week.getColor(week.rating),
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 20.0, 5.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('W/B ${week.wB}', style: TextStyle(fontSize: 17.0)),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportPage(week: week)),
        );
      },
    );
  }
}

class ReportPage extends StatefulWidget {
  final WeekReport week; //Doesn't need 'final' keyword
  ReportPage({this.week});
  @override
  _ReportPageState createState() => _ReportPageState(week: week);
}

class _ReportPageState extends State<ReportPage> {
  WeekReport week; //Doesn't need 'final' keyword
  _ReportPageState({this.week});

  List<Color> toDoColor = [Colors.black, Colors.black, Colors.black];
  List<String> toDoState = ['MARK AS DONE', 'MARK AS DONE', 'MARK AS DONE'];

  changeState(int index) {
    setState(() {
      toDoColor[index] = Colors.grey;
      toDoState[index] = 'DONE';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('W/B ${week.wB}'),
        centerTitle: true,
        backgroundColor: Color(0xFF003468),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/Settings');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Your report',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              height: 300.0,
              width: 400.0,
              child: Card(
                color: week.getColor(week.rating),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Week\'s Highlight:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(week.report[0], style: TextStyle(fontSize: 18.0)),
                    Text('Points for concern:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(week.report[1], style: TextStyle(fontSize: 18.0)),
                    Text('Contacted Trustee:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(week.report[2], style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
              color: Color(0xFF003468),
              indent: 20.0,
              endIndent: 20.0,
            ),
            Text('Next Steps',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: week.getAdvice(week.rating).length - 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        color: Colors.blue[50],
                        child: Column(
                          children: <Widget>[
                            Text(
                              week.getAdvice(week.rating)[index + 1],
                              style: TextStyle(
                                  color: toDoColor[index], fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                              child: Text(toDoState[index]),
                              onPressed: () => changeState(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Classifier extends StatefulWidget {
  @override
  _ClassifierState createState() => _ClassifierState();
}

class _ClassifierState extends State<Classifier> {
  _makePostRequest() async {
    // set up POST request arguments
    String url = 'http://127.0.0.1:5000/predict';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"tweet": "Feeling really stressed out about the work piling up at the moment... :("}';
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    return body;
  }

  String value = 'data';
  changeState() {
    setState(() {
      String body = _makePostRequest().toString();
      value = body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('Machine Learning Model'),
        centerTitle: true,
        backgroundColor: Color(0xFF003468),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 12.0, 20.0),
            height: 250.0,
            width: 450.0,
            child: Card(
              color: Colors.blue[50],
              child: Column(
                children: <Widget>[
                  Text('Tweet',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text(
                      'Feeling really stressed out about the work piling up at the moment... :(',
                      style: TextStyle(fontSize: 18.0)),
                  Text('Probability',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text(value, style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          ),
          FlatButton(
              color: Color(0xFF003468),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: Text('SEND TO MODEL',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                changeState();
              }),
        ],
      ),
    );
  }
}
