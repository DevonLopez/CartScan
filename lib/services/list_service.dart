import 'package:cart_scan/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cart_scan/models/models.dart';
import 'package:provider/provider.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class ListService {
  static Future<void> createList(ShoppingList shoppingList) async {
    final listDoc = FirebaseFirestore.instance.collection('lists').doc();
    final user = _auth.currentUser;
    final userId = user!.uid;
    shoppingList.id = listDoc.id;
    print(
        "${shoppingList.id}  ${shoppingList.name} ${shoppingList.userId}  ${shoppingList.items}");
    final listado = Lists(name: shoppingList.name, userId: userId);
    await listDoc.set(listado.toMap());
  }
}

Future<UserModel> getUserData() async {
  final user = _auth.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  final userId = user.uid;
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final userData = await userDoc.get();
  if (!userData.exists) {
    throw Exception('User data not found');
  }
  final userMap = userData.data() as Map<String, dynamic>;
  final userModel = UserModel.fromMap(userMap);

  // Obtener las listas del usuario
  final listDocs =
      await db.collection('lists').where('userId', isEqualTo: userId).get();
  final lists = <ShoppingList>[];

  for (final doc in listDocs.docs) {
    final listMap = doc.data() as Map<String, dynamic>;
    final listId = doc.id;
    final listName = listMap['name'];

    // Obtener los elementos de la lista
    final itemDocs =
        await db.collection('items').where('listId', isEqualTo: listId).get();
    final items = <Item>[];

    for (final itemDoc in itemDocs.docs) {
      final itemMap = itemDoc.data() as Map<String, dynamic>;
      final itemId = itemDoc.id; // ID del documento autogenerado
      final item = Item(
        id: itemId,
        listId: listId,
        name: itemMap['name'],
        description: itemMap['description'],
        price: itemMap['price']?.toDouble(),
        discount: itemMap['discount']?.toDouble(),
        quality: itemMap['quality'],
        offer: itemMap['offer'],
      );
      items.add(item);
    }

    final shoppingList = ShoppingList(
      id: listId,
      name: listName,
      userId: userId,
      items: items,
    );
    lists.add(shoppingList);
  }

  userModel.lists = lists;

  return userModel;
}
