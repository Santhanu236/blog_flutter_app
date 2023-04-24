import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/global.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';


class CommentPage extends StatefulWidget {
  final dynamic blog_id;
  CommentPage({required this.blog_id});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();

  late Future<dynamic> comment_response;

  @override
  initState() {
    super.initState();
    comment_response = getComm();
  }

  Future<bool> postComment(String content) async {
    final prefs = await SharedPreferences.getInstance();
    final String? users_id = prefs.getString('user_id');
    var response = await http.post(Uri.parse(globals.ngrok_uri + "/new_comment"),
        body: {"content": content, "users_id": users_id, "blogs_id": widget.blog_id.toString()});
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
      return true;
    } else {
      print("error da");
      return false;
    }
  }
  Future<dynamic> getComm() async {
    var response = await http.get(Uri.parse("${globals.ngrok_uri}/get_comment/${widget.blog_id}"));
    return jsonDecode(response.body);
  }
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
            Expanded(
              child: commentWidget(),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // First child is enter comment text input
                  Expanded(
                    child: TextFormField(
                      autocorrect: false,
                      controller: commentController,
                      decoration: new InputDecoration(
                        labelText: "Comment",
                      ),
                    ),
                  ),
                  // Second child is button
                  IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 20.0,
                    onPressed: () {
                      String comment = commentController.text;
                      postComment(comment);
                    },
                  )
                ])),

          ],
        ),
      ),
    );
  }


  commentWidget() {
    return FutureBuilder<dynamic>(
      future: comment_response,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data[index]['content']),
                        trailing: TextButton(
                          onPressed: () {
                          },
                          child: Text(
                            'reply',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                        ),

                      )
                    ],
                  ),
                ),

              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
