import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cart_scan/models/models.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
String? uid;

Future<List<UserModel>> getUsers() async {
  List<UserModel> users = [];

  CollectionReference collectionUsers = db.collection("users");

  QuerySnapshot queryUsers = await collectionUsers.get();

  queryUsers.docs.forEach((element) {
    users.add(UserModel.fromMap(element.data() as Map<String, dynamic>));
  });
  print(users.toString());
  return users;
}
