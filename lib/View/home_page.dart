import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:quantum_it/Model/news_moedl.dart';
import 'package:quantum_it/Services/api_services.dart';

import 'Auth/auth_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> news = [];
  List<Article> searchNews = [];
  void initState() {
    super.initState();
    fetchNews();

    searchNews = news;
  }

  void search(String searchKeyword) {
    List<Article> results = [];
    if (searchKeyword.isEmpty) {
      results = news;
    } else {
      results = news.where((s_news) {
        return s_news.title!.toLowerCase().contains(
              searchKeyword.toLowerCase(),
            );
      }).toList();
    }
    setState(() {
      searchNews = results;
    });
  }

  Future<void> fetchNews() async {
    print('....Fechnes function running....');
    final response = await getNews();
    setState(() {
      news = response;
      searchNews = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Wanna LogOut 👋 ",
                  titleStyle: TextStyle(color: Colors.red),
                  backgroundColor: Colors.grey.shade600,
                  content: Text(
                    'After logout you can login through email Id and Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('No')),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.to(AuthPage());
                        },
                        child: Text('Yes')),
                  ]);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 70,
              child: Center(
                child: TextField(
                  onChanged: (value) => search(value),
                  decoration: InputDecoration(
                    labelText: 'Search News',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchNews.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 25,
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    GetTimeAgo.parse(
                                      DateTime.parse(
                                          '${searchNews[index].publishedAt}'),
                                    ),
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    '   ${searchNews[index].source.name}',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          "${searchNews[index].title}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          "${searchNews[index].description}",
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 95,
                                    width: 95,
                                    child: Image.network(
                                      searchNews[index].urlToImage == null
                                          ? "https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg"
                                          : '${searchNews[index].urlToImage}',
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
