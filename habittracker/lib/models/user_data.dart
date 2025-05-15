import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  String? _docId;
  String? _name;
  String? _email;
  String? _password;

  String? get docId => _docId;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;

  void setDocId(String id) {
    _docId = id;
    notifyListeners();
  }

  void setUser({
    required String docId,
    required String email,
    String? password, // optional
  }) {
    _docId = docId;
    _name = name;
    _email = email;
    _password = password;
    notifyListeners();
  }

}
//set
//Provider.of<UserData>(context, listen: false).setDocId('abc123');
//get
//String? id = Provider.of<UserData>(context).docId;


