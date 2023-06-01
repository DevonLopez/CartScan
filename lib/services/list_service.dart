import 'package:cart_scan/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cart_scan/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class ListService {
  static Future<void> createList(
      BuildContext context, ShoppingList shoppingList) async {
    final listDoc = FirebaseFirestore.instance.collection('lists').doc();
    final userProvider =
        Provider.of<UserProvider>(context, listen: false).currentUser!.lists!;
    print(shoppingList);
    print(userProvider);
    bool existe = false;
    userProvider.forEach((element) {
      print(element.name);
      if (element.name == shoppingList.name) {
        existe = true;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Esta lista ya existe'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
        print('lista ya existe ');
      }
    });
    if (!existe) {
      print('lista insertada ');
      print(shoppingList.toString());
      shoppingList.userId = _auth.currentUser!.uid;
      await listDoc.set(shoppingList.toMap());
    }
    existe = false;
  }
}

Future<void> removeListWithItems(String listId) async {
  final listDoc = db.collection('lists').doc(listId);

  listDoc.delete();

  db.runTransaction((transaction) async {
    CollectionReference itemsRef = db.collection('items');

    // Realizar una consulta para obtener los documentos que tienen el mismo listId
    QuerySnapshot querySnapshot =
        await itemsRef.where('listId', isEqualTo: listId).get();

    // Eliminar los documentos encontrados
    for (DocumentSnapshot document in querySnapshot.docs) {
      transaction.delete(document.reference);
    }
  }).then((value) {
    print('Documentos eliminados exitosamente.');
  }).catchError((error) {
    print('Error al eliminar documentos: $error');
  });
}

Future<void> addItemToSelectedList(Item newItem) async {
  print('addItem');
  final itemDoc = db.collection('items');

  await itemDoc.add(newItem.toMap());
}

Future<UserModel> getUserData() async {
  print('userData');
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
    final listMap = doc.data();
    final listId = doc.id;
    final listName = listMap['name'];

    // Obtener los elementos de la lista
    final itemDocs =
        await db.collection('items').where('listId', isEqualTo: listId).get();
    final items = <Item>[];

    for (final itemDoc in itemDocs.docs) {
      final itemMap = itemDoc.data();
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

Future<void> addUserToCollection(String name) async {
  print('addUser');
  final userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid);

  await userDoc.set({
    'name': name,
  });
}
