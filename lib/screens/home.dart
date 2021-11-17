import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shoppinglist/helper/constants.dart';
import 'package:shoppinglist/screens/addItem.dart';
import 'package:shoppinglist/screens/editItem.dart';
import 'package:shoppinglist/services/databse.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  late QuerySnapshot itemsFromDB;

  bool isDone = true;

  Future<String> callAsyncFetch() => Future.delayed(Duration(milliseconds: 175), () => "");

  getItemsFromDB() {
    databaseMethods.getItems().then((val) {
      setState(() {
        itemsFromDB = val;
        isDone = false;
      });            
    });
  }

  @override
  void initState() {
    getItemsFromDB();
    super.initState();
  }

  removeItem(index) async{
    List<String> iDs = [];
    var collection = FirebaseFirestore.instance.collection("item");
    var querySnapshot = await collection.get();
    for (var snapshot in querySnapshot.docs) {
      var documentID = snapshot.id;
      iDs.add(documentID);
    }
    databaseMethods.deleteItem(iDs[index]);
  }

  _deleteItem(index) async {
    await removeItem(index);
    setState(() {
      itemsFromDB.docs.removeAt(index+1);
    });
  }
  
  Widget itemsList() {
    return itemsFromDB != null ? Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: getColumnHeight()),
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            return await Future.delayed(Duration(seconds: 1));
          },
          child: ListView.builder(
            itemCount: itemsFromDB.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                direction: DismissDirection.startToEnd,
                resizeDuration: Duration(microseconds: 200),
                key: ObjectKey(itemsFromDB.docs.elementAt(index)),
                onDismissed: (direction) {
                  _deleteItem(index);
                },
                child: itemCard(
                  title: itemsFromDB.docs[index].get("title"),
                  info: itemsFromDB.docs[index].get("info"),
                  priority: itemsFromDB.docs[index].get("priority"),
                  color: itemsFromDB.docs[index].get("color"),
                  index: index,
                  checked: itemsFromDB.docs[index].get("checked"),
                ),
              );
            },
          ),
        ),
      ),      
    ) : Container();

  }

  

  double getColumnHeight() {
    return itemsFromDB.docs.length * 180 + 100;
  }

  updateItemCheckState(index) async {

    List<String> iDs = [];
    var collection = FirebaseFirestore.instance.collection("item");
    var querySnapshot = await collection.get();
    for (var snapshot in querySnapshot.docs) {
      var documentID = snapshot.id;
      iDs.add(documentID);
    }

    bool Bool = false;
    if(itemsFromDB.docs[index].get("checked")) {
      Bool = false;
    } else {
      Bool = true;
    }

    databaseMethods.updateItemCheckState(iDs[index], Bool);

    setState(() {
      itemCheckedLive = !itemCheckedLive;
    });

  }

  late bool itemCheckedLive;

  makeItemCheckedLive(itemChecked) {
    itemCheckedLive = itemChecked;
  }

  Widget itemCard({ 
    required String title,
    required String info,
    required String color,
    required bool priority,
    required int index,
    required bool checked,
  }) {
    bool itemChecked = checked;
    makeItemCheckedLive(itemChecked);
    return Container(
      padding: EdgeInsets.only(left: 25, top: 15, right: 25, bottom: index == itemsFromDB.docs.length-1 ? 75 : 15),
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(int.parse(color)),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1, 2),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(color: priority? Colors.red : Color(int.parse(color)), width: 3)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 250),
                    padding: EdgeInsets.only(left: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xF0FFFFFF),
                            fontFamily: 'Normal',
                            decoration: itemCheckedLive? TextDecoration.lineThrough : TextDecoration.underline,
                            decorationThickness: 2
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          info,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xF0FFFFFF),
                            fontFamily: 'Italic',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateItemCheckState(index);
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15, top: 15),
                        child: Icon(itemCheckedLive? Icons.check_circle_outlined : Icons.check_circle, color: itemCheckedLive? Colors.grey : Colors.green, size: 50,),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Color(0xffFF595B),
                            borderRadius: BorderRadius.circular(1000),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 6
                              ),
                            ]
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => EditItem(
                                  title: title,
                                  info: info,
                                  priority: priority,
                                  color: color,
                                  index: index,
                                )));
                            },
                            child: Icon(Icons.save, color: Color(0xF0FFFFFF), size: 30,)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return isDone? Center(child: CircularProgressIndicator(),) : Scaffold(
      backgroundColor: Color(0xf1Eaf4fc),
      body: FutureBuilder(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            return Column(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff2E83FF),
                        Color(0xff48C8FE),
                      ],
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2, 4),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 35),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Einkaufsliste",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white70,
                          fontFamily: 'Anton'
                        ),
                      ),
                    ),
                  ),
                ),
                itemsList(),
              ],
            );
          } else {
            return Scaffold(
              backgroundColor: Color(0xf1Eaf4fc),
              body: Column(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff2E83FF),
                          Color(0xff48C8FE),
                        ],
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2, 4),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 35),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Einkaufsliste",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white70,
                            fontFamily: 'Anton'
                          ),
                        ),
                      ),
                    ),
                  ),
                  //itemsList(),
                ],
              ),
              floatingActionButton: SizedBox(
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddItem()));
                  },
                  child: Icon(Icons.add_shopping_cart_rounded, size: 35,),
                ),
              )
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddItem()));
          },
          child: Icon(Icons.add_shopping_cart_rounded, size: 35,),
        ),
      )
    );
  }
}