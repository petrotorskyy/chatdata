import 'package:firebase_database/firebase_database.dart';
import 'message.dart';

class MessageDAO {
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.reference().child('chat');
  
  void saveMessage(Message message) {
    _firebaseDatabase.push().set(message.toJson());
  }

  Query getMessages() {
    return _firebaseDatabase;
  }

}