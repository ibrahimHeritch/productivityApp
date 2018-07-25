//C3:32:1E:79:21:CE:06:5A:DC:56:C0:24:15:4C:08:EE:A0:26:BE:0C

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_metrics/Widgets/TodaysTasks.dart';
import 'package:productivity_metrics/Widgets/loading_screen.dart';
import 'package:productivity_metrics/main.dart';


 /// Class name says it all
 /// works with google signin
 /// logic implemented in the user class
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
        child: Container(//background picture
          height: MediaQuery.of(context).size.height,//TODO FIX this
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/backgroundLogin.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.orangeAccent.withOpacity(0.4),//cover over picture
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
                                validator: (string) => "test",
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
                                validator: (string) => "test",
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
                                    child: Text("Login With Google"),//todo add google icon
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

  void _emailLogin() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      user.verifyUser(email: null, password: null).then((onValue) {
        if (onValue == "Login Successfull")
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => new TodaysTasks()));
        else
          showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

 /// handle login using google

  void _googleLogin() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoadingScreen()));

    try {
      //try to login silently
      await user.signInGoogleSilently();
    } catch (e) {
      try {
        //try login non-silently
        await user.signInGoogle();
      } catch (e) {
        print("error");//TODO handle error
      }
    }

    if (user.isLoggedin()) {
      Navigator.pop(context);//pop loading screen
      Navigator.pushReplacement(//go to home
          context, MaterialPageRoute(builder: (context) => new TodaysTasks()));
    } else {
      Navigator.pop(context);
    }
  }
}
