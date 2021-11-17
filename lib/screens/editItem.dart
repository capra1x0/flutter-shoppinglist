import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/helper/constants.dart';
import 'package:shoppinglist/screens/home.dart';
import 'package:shoppinglist/services/databse.dart';

class EditItem extends StatefulWidget {
  final String title;
  final String info;
  final String color;
  final bool priority;
  final int index;

  const EditItem({ Key? key, required this.title, required this.info, required this.priority, required this.color, required this.index}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  late String selectedColor;

  late bool isChecked;
  late String title;
  late String info;

  TextEditingController titelEditingController = new TextEditingController(); 
  TextEditingController infoEditingController = new TextEditingController(); 

  updateItem() async {
    print(widget.title);
    print("test");

    //if(formKey.currentState!.validate()) {
    Map<String, dynamic> userInput = {
      "title": titelEditingController.text.isEmpty? title : titelEditingController.text,
      "info": infoEditingController.text.isEmpty? info : infoEditingController.text,
      "priority": isChecked,
      "color": selectedColor,
    };

    List<String> iDs = [];
    var collection = FirebaseFirestore.instance.collection("item");
    var querySnapshot = await collection.get();
    for (var snapshot in querySnapshot.docs) {
      var documentID = snapshot.id;
      iDs.add(documentID);
    }

    // setState(() {
    //   isLoading = true;
    // });

    databaseMethods.updateItem(userInput, iDs[widget.index]);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  //}
  }

  @override
  void initState() {
    selectedColor = widget.color;
    title = widget.title;
    info = widget.info;
    isChecked = widget.priority;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xf1Eaf4fc),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 50, right: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Icon(Icons.keyboard_backspace_rounded, size: 40,)
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.green[200],
                    child: Text(
                      "Neuen Eintrag Erstellen: ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: "Normal"
                      ),
                    ),
                  ),
                  SizedBox(height: 35,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Titel",
                        style: entryTextStyle(),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val!.length > 1 ? null : "Ungültige  Bezeichnung";
                          },
                          controller: titelEditingController,
                          decoration: textFieldInputDecorationWithHint(widget.title),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Info zum Einkauf",
                        style: entryTextStyle(),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val!.length > 1 ? null : "Ungültige  Bezeichnung";
                          },
                          controller: infoEditingController,
                          decoration: textFieldInputDecorationWithHint(widget.info),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 55,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = "0xffFF595B";
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xffFF595B),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selectedColor == "0xffFF595B" ? Colors.black : Color(0xffFF595B), width: 4)
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = "0xff6C8BFA";
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff6C8BFA),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selectedColor == "0xff6C8BFA" ? Colors.black : Color(0xff6C8BFA), width: 4)
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = "0xff1AC9BA";
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff1AC9BA),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selectedColor == "0xff1AC9BA" ? Colors.black : Color(0xff1AC9BA), width: 4)
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = "0xff47B84A";
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff47B84A),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selectedColor == "0xff47B84A" ? Colors.black : Color(0xff47B84A), width: 4)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40,),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.6,
                    child: Checkbox(
                      value: widget.priority,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }
                    ),
                  ),
                  Text(
                    "Auswählen für höhere Priorität",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    updateItem();
                  },
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFF4A54),
                          Color(0xffF87575),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xf0ffffff)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}