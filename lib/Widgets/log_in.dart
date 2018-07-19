//C3:32:1E:79:21:CE:06:5A:DC:56:C0:24:15:4C:08:EE:A0:26:BE:0C

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/TodaysTasks.dart';
import 'package:productivity_metrics/Widgets/loading_screen.dart';
import 'package:productivity_metrics/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

            height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/backgroundLogin.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
            color: Colors.orangeAccent.withOpacity(0.4),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child:Text("LOGO",style: Theme.of(context).textTheme.title,)
                  ),
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
                                validator: (String) => "test",
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
                                validator: (String) => "test",
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
                                    onPressed: _handleSubmitted,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Text("Login With Google"),
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

  void _handleSubmitted() {
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

  void _googleLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoadingScreen()));
    user.signInGoogle().then((onValue) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => new TodaysTasks()));
    }).catchError((PlatformException onError) {
      showInSnackBar(onError.message);
    });
  }
}
