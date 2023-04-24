import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/global.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'blogHome.dart';

class NewBlogPage extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        backgroundColor: Colors.black,
        centerTitle: true,
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
                'Create New Blog',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Text(
              'BLOG TITLE :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: "Blog title",
              ),
              controller: titleController,
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'CONTENT :',
              style: TextStyle(
                letterSpacing: 2.0,
              ),
            ),
            TextField(
              maxLines: 10,
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                border: InputBorder.none,
                hintText: 'Blog Content',
              ),
              controller: contentController,
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  String title = titleController.text;
                  String content = contentController.text;
                  Future<bool> res = postBlog(title, content);
                  if (await res) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BlogHome()));
                  }
                },
                child: Text(
                  'Create',
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

  Future<bool> postBlog(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final String? users_id = prefs.getString('user_id');
    var response = await http.post(Uri.parse(globals.ngrok_uri + "/blogs"),
        body: {"title": title, "content": content, "users_id": users_id});
    if (response.statusCode == 200) {
      return true;
    } else {
      print("error da");
      return false;
    }
  }
}
