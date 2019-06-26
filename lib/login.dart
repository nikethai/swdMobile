import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/home.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(title: 'Flutter Login'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
  );

  final _formKey = new GlobalKey<FormState>();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover),
          ),
        ),
        new SingleChildScrollView(
          child: Center(
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: loginForm(),
                  )),
            ),
          ),
        )
      ],
    ));
  }

  Widget loginForm() {
    RegExp userNameCheck = RegExp(r'^[A-Za-z0-9_.]+$');

    final nameField = TextFormField(
      validator: (value) {
        if (value.isEmpty)
          return 'Cannot Be Empty';
        else if (!userNameCheck.hasMatch(value))
          return 'Only Character and Number allowed';
        else
          return null;
      },
      style: style,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 10.0, 15.0),
        hintText: "Username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final passwordField = TextFormField(
      validator: (value) => value.isEmpty ? 'Cannot Be Empty':null,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 10.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffffffff),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => MyHome()));
          }

          // return showDialog(
          //   context: context,
          //   builder: (context){
          //     return AlertDialog(
          //       content: Text('Walnut'),
          //     );
          //   }
          // );
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.blue[300], fontWeight: FontWeight.bold)),
      ),
    );
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 155.0,
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 45.0),
        nameField,
        SizedBox(height: 25.0),
        passwordField,
        SizedBox(
          height: 175.0,
        ),
        loginButon,
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
