

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Pages/TodaysTasks.dart';
import 'package:productivity_metrics/Pages/home.dart';
import 'package:productivity_metrics/Pages/loading_screen.dart';


/// Class name says it all
/// works with google signin
/// logic implemented in the user class
/// Login With Email isn't fully implemented at the moment
//TODO verification + login with email + create account + forgot password
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  ///key for the main form used when validationg
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  ///key for scaffold used to display snach bars
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email;
  String _password;

  ///Shows snack bar on the main login screen
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          //background picture
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/backgroundLogin.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.orangeAccent.withOpacity(0.4), //cover over picture
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                      child: Text(
                    "LOGO",
                    style: Theme.of(context).textTheme.title,
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        autovalidate: false,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  icon: Icon(Icons.email),
                                ),
                                obscureText: false,
                                validator: emailValidator,
                                onSaved: (val) => _email = val,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  icon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                validator: passwordValidator,
                                onSaved: (val) => _password =
                                    val, //storing this in a string might not be a good idea
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Text("Login"),
                                    onPressed: _emailLogin,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/glogo.png",
                                          height: 18.0,
                                          width: 18.0,
                                        ),
                                        SizedBox(width: 16.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                              "Sign in with Google"
                                          ),
                                        ),
                                      ],),
                                    onPressed: _googleLogin,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FlatButton(
                                      child: Text("Create Account."),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new TodaysTasks()));
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FlatButton(
                                    child: Text("Reset Password."),
                                    onPressed: _googleLogin,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String emailValidator(String s) {
    if (s.isEmpty) {
      return "Email field Can't be empty";
    } else if (!s.contains("@") || !s.contains(".")) {
      ///should be using regex but im sure this'll work just as fine
      return "Not a valid Email ";
    } else {
      return null;
    }
  }

  void _emailLogin() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      User.getInstance().signInEmail(email: _email, password: _password).then(
          (onValue) {
        if (onValue) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }, onError: (onError) {
        print(onError.message);
      }).catchError((PlatformException onError) {});
    }
  }

  /// handle login using google

  void _googleLogin() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoadingScreen()));


    try {
        //try login non-silently
        await User.getInstance().signInGoogle();
      } catch (e) {
      Navigator.pop(context); //pop loading screen
      showInSnackBar("Something whent wrong:" + e.message);

      }


    if (User.getInstance().isLoggedin()) {
      Navigator.pop(context); //pop loading screen
      Navigator.pushReplacement(
          //go to home
          context,
          MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pop(context);
    }
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password field can't be left empty";
    } else if (value.length <= 6) {
      return "Password too short";
    } else {
      return null;
    }
  }
}
