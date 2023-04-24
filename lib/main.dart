import 'package:blog_app/global.dart' as globals;
import 'package:blog_app/blogHome.dart';
import 'package:blog_app/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                'User Login',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Text(
              'EMAIL :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: "Enter your Email",
              ),
              controller: emailController,
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'PASSWORD :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[300],
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Enter Password',
                ),
                controller: passwordController),
            SizedBox(
              height: 35.0,
            ),
            Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'New to Blog App?   ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                      text: 'Register here',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        }),
                ]),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;
                  Future<bool> is_log = loginHandler(email, password);
                  if (await is_log) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BlogHome()));
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> loginHandler(String email, String password) async {
    var response = await http.post(Uri.parse(globals.ngrok_uri + "/login"),
        body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      print("++++++++++++++++++++++++" + response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', response.body);

      return true;
    } else {
      print("erroed out");
      return false;
    }
  }
}
