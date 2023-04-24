import 'package:blog_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:blog_app/global.dart' as globals;

class SignUpPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController npasswordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
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
                'User Registration',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Text(
              'NAME :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: "Enter your Name",
              ),
              controller: nameController,
            ),
            SizedBox(
              height: 40.0,
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
                hintText: 'Enter your Email address',
              ),
              controller: emailController,
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'NEW PASSWORD :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: 'create a new password',
              ),
              controller: npasswordController,
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'CONFIRM PASSWORD :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: 'Confirm your new password',
              ),
              controller: cpasswordController,
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Already an User?    ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                      text: 'Login here',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }),
                ]),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  String name = nameController.text;
                  String email = emailController.text;
                  String npassword = npasswordController.text;
                  String cpassword = cpasswordController.text;
                  await postData(name, email, npassword, cpassword);
                },
                child: Text(
                  'Register',
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

  Future<dynamic> postData(
      String name, String email, String npassword, String cpassword) async {
    if (npassword == cpassword) {
      var response = await http.post(Uri.parse(globals.ngrok_uri + "/users"),
          body: {"name": name, "email": email, "password": cpassword});
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print("damn");
      }
    } else {
      print("password do not match");
    }
  }
}
