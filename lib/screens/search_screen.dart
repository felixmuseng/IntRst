import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:se_project/utils/colors.dart';
import 'profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShow = false;
  bool showUser = true;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for a user',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShow = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShow
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        border: showUser
                            ? const Border(
                                bottom:
                                    BorderSide(width: 1.0, color: primaryColor),
                              )
                            : const Border(
                                bottom: BorderSide(
                                    width: 1.0, color: secondaryColor),
                              ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showUser = true;
                          });
                        },
                        icon: const Icon(
                          Icons.group,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Ink(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        border: !showUser
                            ? const Border(
                                bottom:
                                    BorderSide(width: 1.0, color: primaryColor),
                              )
                            : const Border(
                                bottom: BorderSide(
                                    width: 1.0, color: secondaryColor),
                              ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showUser = false;
                          });
                        },
                        icon: const Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                !showUser
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('username',
                                isGreaterThanOrEqualTo: searchController.text)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['photoUrl'],
                                    ),
                                  ),
                                  title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    // : Container(
                    //     alignment: Alignment.topLeft,
                    //     margin: const new EdgeInsets.only(left: 20, top: 20),
                    //     child: const Text(
                    //       'Music',
                    //       style: TextStyle(fontSize: 16),
                    //     ),
                    //   )
                    : Column(children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          child: const Text(
                            'Music',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          child: const Text(
                            'Basketball',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          child: const Text(
                            'Sports',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ])
              ],
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl']),
                );
              },
            ),
    );
  }
}
