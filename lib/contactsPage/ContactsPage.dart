import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName!] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                child: Text('My Contacts'),
              ),
              listItemsExist == true
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Contact contact = contacts[index];
                          var baseColor =
                              contactsColorMap[contact.displayName] as dynamic;
                          Color color1 = baseColor[800];
                          Color color2 = baseColor[400];
                          return ListTile(
                            title: Text(contact.displayName!),
                            subtitle: Text(
                                contact.phones!.elementAt(0).value.toString()),
                            leading: (contact.avatar != null &&
                                    contact.avatar!.length > 0)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          colors: [
                                            color1,
                                            color2,
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight),
                                    ),
                                    child: CircleAvatar(
                                        child: Text(
                                          contact.initials(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.transparent),
                                  ),
                          );
                        },
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(20),
                      child: Text('No contacts exist',
                          style: Theme.of(context).textTheme.headline6),
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  child: Text("Contacts Count"),
                  onPressed: () {
                    sendContactsCount(contacts.length);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendContactsCount(int conatctsCount) async {
    final response = await http.post(
      Uri.parse(
          'http://3.124.190.213/api/5e73ac04-716f-4c9b-870d-eaeef69ca234/suspects'),
      body: jsonEncode(
        <String, int>{
          'count': conatctsCount,
        },
      ),
    );
    var resCode = response.statusCode;
  }
}
