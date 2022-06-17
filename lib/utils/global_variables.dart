import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_project/screens/add_post_screen.dart';
import 'package:se_project/screens/home_screen.dart';
import 'package:se_project/screens/profile_screen.dart';
import 'package:se_project/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const HomeScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
