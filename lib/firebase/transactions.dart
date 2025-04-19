import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTransactionService {
  final transactionCollection = FirebaseFirestore.instance.collection(
    "transaction",
  );

  Future<void> addTransaction(
    String type,
    int customerID,
    List<int> itemIDs,
  ) async {
    try {
      await transactionCollection.add({
        'type': type,
        'customerID': customerID,
        // 'createdAt': FieldValue.serverTimestamp(),
      });
      print("Transaction created successfully");
    } catch (err) {
      print("Error creating transaction: $err");
    }
  }
}
