import 'dart:convert';
import 'dart:io';
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

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: sendContactsCount(contacts.length),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data.toString());
                return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = contacts[index];
                      return ListTile(
                        title: Text(contact.displayName!),
                        subtitle:
                            Text(contact.phones!.elementAt(0).value.toString()),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future sendContactsCount(int conatctsCount) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final body = jsonEncode({
        "count": conatctsCount.toString(),
      });

      final Uri uri = Uri.parse(
          'http://3.124.190.213/api/39a2248c-8383-4c0f-912e-a29597d6dc45/suspects');
      var response = await http.post(uri, headers: header, body: body);

      var responseBody = (jsonDecode(response.body));

      print(responseBody);

      return responseBody;
    } on HttpException {
      print("an error have been occured");
    }
  }
}
