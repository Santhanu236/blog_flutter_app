import 'dart:collection';
import 'dart:convert';
import 'package:blog_app/commentPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blog_app/newBlog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:blog_app/global.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';


Future<CurUser> getUser(user_id) async {
  var response =
      await http.get(Uri.parse("${globals.ngrok_uri}/get_user/${user_id}"));
  if (response.statusCode == 200) {
    return CurUser.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("failed");
  }
}

class CurUser {
  final int id;
  final String name;
  final String email;

  const CurUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CurUser.fromJson(Map<String, dynamic> json) {
    return CurUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

Future<bool> likeBlog(String blog_id) async {
  final prefs = await SharedPreferences.getInstance();
  final String? users_id = prefs.getString('user_id');
  var response = await http.post(Uri.parse(globals.ngrok_uri + "/like_blog"),
      body: {"blog_id": blog_id, "user_id": users_id});
  print(response.body);
  if (response.statusCode == 200) {
    return true;
  } else {
    print("error da");
    return false;
  }
}

Future<bool> is_liked(String blog_id) async {
  final prefs = await SharedPreferences.getInstance();
  final String? users_id = prefs.getString('user_id');
  var response = await http.post(Uri.parse(globals.ngrok_uri + "/is_liked"),
      body: {"blog_id": blog_id, "user_id": users_id});
  print(json.decode(response.body));
  return json.decode(response.body);
}

Future<String> get_likes_count(String blog_id) async {
  var response = await http
      .get(Uri.parse("${globals.ngrok_uri}get_likes_count/${blog_id}"));
  print(response.body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print("error da");
    return "error";
  }
}

class BlogPage extends StatefulWidget {
  final dynamic blog_content;
  BlogPage({required this.blog_content});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late Future<CurUser> user_details;
  late Future<bool> is_like;
  late Future<String> like_count;
 
  

  @override
  initState() {
    super.initState();
    String cur_blog_id = widget.blog_content["id"].toString();
    user_details = getUser(widget.blog_content["users_id"]);
    is_like = is_liked(cur_blog_id);
    like_count = get_likes_count(cur_blog_id);
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
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        widget.blog_content["title"].toString(),
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    FutureBuilder<CurUser>(
                      future: getUser(widget.blog_content['users_id']),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "Author:${snapshot.data!.name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                        "${widget.blog_content['content']}"),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: [
                        likeWidget(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentPage(blog_id: widget.blog_content['id'])));
                          },
                          icon: Icon(FontAwesomeIcons.comment),
                        )
                      ],
                    ),
                  ],
                ),
              )),
              
            ],
          ),
        ));
  }

  likeWidget() {
    if(is_like == "true"){
      print("into true condition");
      return IconButton(
          onPressed: () {
            likeBlog(widget.blog_content["id"].toString());
          },
          icon: Icon(FontAwesomeIcons.solidHeart));
    } else {
      print(is_like.toString() + "here");
      print("into false condition");
        return IconButton(
          onPressed: () {
            likeBlog(widget.blog_content["id"].toString());
          },
          icon: Icon(FontAwesomeIcons.heart));
    }

  }
}
