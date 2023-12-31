import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meetly/showgroups.dart';

import 'chat_room.dart';
import 'creategroup.dart';

class CareTeamChatHomeWidget extends StatefulWidget {
  const CareTeamChatHomeWidget({super.key});

  @override
  CareTeamChatHomeWidgetState createState() => CareTeamChatHomeWidgetState();
}

class CareTeamChatHomeWidgetState extends State<CareTeamChatHomeWidget> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allUsers = [];

  @override
  void initState() {
    super.initState();
    setStatus("Online");
    fetchAllUsers();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      var querySnapshot = await _firestore.collection('users').get();
      setState(() {
        allUsers = querySnapshot.docs.map((doc) {
          Map<String, dynamic> userData = doc.data();
          userData['uid'] = doc.id;
          return userData;
        }).toList();
      });

      for (var user in allUsers) {
        if (user.containsKey('profilePictures')) {
          String downloadURL = await FirebaseStorage.instance
              .ref(user['profilePictures'])
              .getDownloadURL();
          user['profilePictureURL'] = downloadURL;
        }
      }
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    String searchText = _search.text.trim();
    if (searchText.isNotEmpty) {
      try {
        var querySnapshot = await _firestore
            .collection('users')
            .where("name", isEqualTo: searchText)
            .get();

        setState(() {
          if (querySnapshot.docs.isNotEmpty) {
            userMap = querySnapshot.docs[0].data();
          } else {
            userMap = null;
          }
          isLoading = false;
        });
      } catch (error) {
        setState(() {
          userMap = null;
          isLoading = false;
        });
        print("Error searching user: $error");
      }
    } else {
      setState(() {
        userMap = null;
        isLoading = false;
      });
    }
  }

  void createGroup() {
    // Navigate to the GroupCreateScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupCreateScreen(allUsers: allUsers),
      ),
    );
  }

  void showgroups() {
    // Navigate to the GroupCreateScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height / 20),
                  ElevatedButton(
                    onPressed: createGroup,
                    child: Text("Create Group"),
                  ),
                  ElevatedButton(
                    onPressed: showgroups,
                    child: Text("show Group"),
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width,
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: size.height / 14,
                      width: size.width / 1.15,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _search,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: onSearch,
                            icon: const Icon(Icons.search),
                          ),
                          hintText: "Search...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 50),
                  SizedBox(height: size.height / 30),
                  userMap != null
                      ? ListTile(
                          onTap: () {
                            String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['name'],
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: roomId,
                                  userMap: userMap!,
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 1),
                            ),
                            child: userMap!['profilePictureUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      userMap!['profilePictureUrl'],
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                          ),
                          title: Text(
                            userMap!['name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(userMap!['email']),
                          trailing: const Icon(
                            Icons.mobile_friendly,
                            color: Colors.black,
                          ),
                        )
                      : const Center(
                          child: Text("User not found"),
                        ),
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> userData = allUsers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: ListTile(
                              onTap: () {
                                String roomId = chatRoomId(
                                  _auth.currentUser!.uid!,
                                  userData['uid'],
                                );

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                      chatRoomId: roomId,
                                      userMap: userData,
                                    ),
                                  ),
                                );
                              },
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 1),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors
                                      .blue, // Change the background color as desired
                                  child: Text(
                                    userData['name'][
                                        0], // Display the first character of the user's name
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Change the text color as desired
                                      fontSize:
                                          24, // Adjust the font size as desired
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                userData['name'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(userData['email']),
                              trailing: const Icon(
                                CupertinoIcons.right_chevron,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}
