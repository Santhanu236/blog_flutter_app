import 'dart:convert';

import 'package:blog_app/blogPage.dart';
import 'package:blog_app/newBlog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:blog_app/global.dart" as globals;

Future<dynamic> getBlogs() async {
  var response = await http.get(Uri.parse("${globals.ngrok_uri}/blogs"));
  return jsonDecode(response.body);
}

class BlogHome extends StatefulWidget {
  const BlogHome({super.key});

  @override
  State<BlogHome> createState() => _BlogHomeState();
}

class _BlogHomeState extends State<BlogHome> {
  late Future<dynamic> response;

  @override
  void initState() {
    response = getBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blog App"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewBlogPage()));
              },
              child: Text(
                'New Blog',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
            Expanded(child: myBlogWidget())
          ],
        ));
  }

  Future<String> delBlog(String id) async {
    var response =
        await http.delete(Uri.parse("${globals.ngrok_uri}del_blog/$id"));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
    print(response.body);
    return response.body;
  }

  myBlogWidget() {
    return FutureBuilder<dynamic>(
      future: response,
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
                        title: Text(snapshot.data[index]['title']),
                        trailing: TextButton(
                          onPressed: () async {
                            delBlog(snapshot.data[index]['id'].toString());
                          },
                          child: Text(
                            'X',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                        ),
                        subtitle: Text(snapshot.data[index]['content']),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlogPage(
                                blog_content: snapshot.data[index],
                              )));
                },
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
