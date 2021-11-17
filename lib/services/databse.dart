import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getItems() async {
    return await FirebaseFirestore.instance.collection("item").get();
  }

  uploadNewItem(userInput) {
    FirebaseFirestore.instance.collection("item")
      .add(userInput);
  }
  
  updateItem(userInput, docs_id) {
    FirebaseFirestore.instance.collection("item")
      .doc(docs_id).update(userInput);
  }

  deleteItem(docs_id) {
    FirebaseFirestore.instance.collection("item")
      .doc(docs_id).delete();
  }

  updateItemCheckState(docs_id, Bool) {
    FirebaseFirestore.instance.collection("item")
      .doc(docs_id).update({"checked" : Bool});
  }
}