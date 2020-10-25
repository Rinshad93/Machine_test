import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_test/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _user;

final _codeController = TextEditingController();
GoogleSignIn _googleSignIn = new GoogleSignIn();
bool isSignIn = false;

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    print("log---------${isSignIn}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 150),
              child: Image.asset(
                'assets/img/firebase.png',
              ),
              height: 120,
              width: 120,
            ),
          ),
          InkWell(
            onTap: () {
              handleSignIn();
            },
            child: Container(
                height: 60,
                margin: EdgeInsets.only(top: 80, left: 30, right: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue[400], Colors.blueAccent],
                      begin: const FractionalOffset(0.01, 0.0),
                      end: const FractionalOffset(1.99, 0.0),
                      stops: [0.0, 2.0],
                      tileMode: TileMode.clamp),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Center(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(
                        'Google',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(3),
                      height: 25,
                      width: 25,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/img/gsignin.png',
                      ),
                    ),
                  ),
                )

//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//
//          children: <Widget>[
//          Icon(Icons.call),SizedBox(width: 20,)
//
//            ,Text("Google",style: TextStyle(color: Colors.white),),
//          ],
//        )
                ),
          ),
          InkWell(
            onTap: () {
              handleSignIn();
//              signInWithGoogle().then((result) {
//                if (result != null) {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (context) {
//                        return HomePage();
//                      },
//                    ),
//                  );
//                }
//              });
            },
            child: Container(
                height: 60,
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.yellow, Colors.green],
                      begin: const FractionalOffset(1.99, 0.0),
                      end: const FractionalOffset(0.01, 0.0),
                      stops: [0.0, 2.0],
                      tileMode: TileMode.clamp),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Center(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(
                        'Phone',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    leading: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));

    _user = result.user;

    setState(() {
      print("user det--- ${_user.uid}");
      saveUser(
          _user.displayName.toString(), _user.photoUrl.toString(), isSignIn);
      isSignIn = true;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    });
  }

  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignIn = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AuthenticationPage();
            },
          ),
        );
      });
    });
  }
}

getUser() {}

Future saveUser(String name, String image, bool isLogin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("name", name);
  prefs.setString("image", image);
  prefs.setBool("isLogin", isLogin);
}

Future isLogged(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogin = prefs.getBool('isLogin');
  if (isLogin == true) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }
}
