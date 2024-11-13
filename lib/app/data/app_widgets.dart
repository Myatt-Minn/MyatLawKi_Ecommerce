import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidgets {
  static TextStyle boldTextFieldStyle() => const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Poppins");
  static TextStyle headlineTextFieldStyle() => const TextStyle(
      fontSize: 23, fontWeight: FontWeight.bold, fontFamily: "Poppins");
  static TextStyle lightTextFieldStyle() => TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
      color: Colors.white);
  static TextStyle littlelightTextFieldStyle() => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
      color: Colors.white);
  static TextStyle smallboldlineTextFieldStyle() => const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      color: Colors.white);
}

Future<void> cloneDocument(String sourceCollection, String sourceDocId,
    String targetCollection, String targetDocId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the document from the source collection
  DocumentSnapshot docSnapshot =
      await firestore.collection(sourceCollection).doc(sourceDocId).get();

  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // Write the document to the target collection with the new document ID
    await firestore.collection(targetCollection).doc(targetDocId).set(data);
  } else {
    print("Document does not exist in the source collection.");
  }
}

//  await cloneCollection('source_collection_name', 'target_collection_name');

Future<void> cloneCollection(
    String sourceCollection, String targetCollection) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get all documents from the source collection
  QuerySnapshot querySnapshot =
      await firestore.collection(sourceCollection).get();

  // Iterate over each document
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Write to the target collection using the same document ID
    await firestore.collection(targetCollection).doc(doc.id).set(data);
  }
}

// await cloneDocument(
//     'shirts', '4665UmO1aPjzbYdQUHq9', 'new_arrivals', 'y9Cq3hm0OhTEIidWB4jl');

Widget buildMenuItem(BuildContext context, IconData icon, String title,
    Color iconColor, Function onPressed) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(title),
    onTap: () {
      onPressed(); // Invoke the passed function
    },
  );
}
