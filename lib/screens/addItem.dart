import 'package:flutter/material.dart';
import 'package:shoppinglist/helper/constants.dart';
import 'package:shoppinglist/screens/home.dart';
import 'package:shoppinglist/services/databse.dart';

class AddItem extends StatefulWidget {
  const AddItem({ Key? key }) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  
  DatabaseMethods databaseMethods = new DatabaseMethods();

  String selectedColor = "0xffFF595B";

  bool isChecked = false;

  TextEditingController titelEditingController = new TextEditingController(); 
  TextEditingController infoEditingController = new TextEditingController(); 

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  addItemsToDatabase() {
    //if(formKey.currentState!.validate()) {
      Map<String, dynamic> userInput = {
        "title": titelEditingController.text,
        "info": infoEditingController.text,
        "priority": isChecked,
        "color": selectedColor,
        "checked": false,
      };

      setState(() {
        isLoading = true;
      });

      databaseMethods.uploadNewItem(userInput);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    //}
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? Container() : Scaffold(
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
                          decoration: textFieldInputDecoration(),
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
                          decoration: textFieldInputDecoration(),
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
                      value: isChecked,
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
                    addItemsToDatabase();
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
                      "Hinzufügen",
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