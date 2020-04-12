import 'dart:convert';
import 'package:de/models/blog_post.dart';
import 'package:de/services/blog_post_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BlogPostService _blogPostService = BlogPostService();

  Future<List<BlogPost>> _getAllBlogPosts() async {
    var result = await _blogPostService.getAllBlogPosts();
    List<BlogPost> _list = List<BlogPost>();
    if (result != null) {
      print(result.body);
      var blogPosts = json.decode(result.body);
      blogPosts.forEach((blogPost) {
        var model = BlogPost();
        model.title = blogPost['title'];
        model.details = blogPost['details'];
        model.featuredImgeUrl = blogPost['featured_image_url'];
        setState(() {
          _list.add(model);
        });
      });
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
      ),
      body: FutureBuilder<List<BlogPost>>(
        future: _getAllBlogPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BlogPost>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.network(
                                snapshot.data[index].featuredImgeUrl),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              snapshot.data[index].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Container(
              child: Text('Loading ...'),
            );
          }
        },
      ),
    );
  }
}
