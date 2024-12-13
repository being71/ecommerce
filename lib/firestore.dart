// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Fetch all transactions for the current user
  Future<List<Transaction>> fetchUserTransactions() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      QuerySnapshot snapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return Transaction.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  // Method to update the transaction in Firestore
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final transactionRef = FirebaseFirestore.instance
          .collection('transactions')
          .doc(transaction.transactionId);

      // Update the entire transaction document with the new data
      await transactionRef.update(transaction.toMap());
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  Future<void> removeItemFromTransaction(
      String transactionId, TransactionItem item) async {
    try {
      final transactionRef = FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId);

      // Remove the item from the 'items' list in the Firestore document
      await transactionRef.update({
        'items':
            FieldValue.arrayRemove([item.toMap()]), // Convert the item to a map
      });
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Method to delete a transaction if there are no items left
  Future<void> deleteTransaction(String transactionId) async {
    try {
      final transactionRef = FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId);

      // Delete the transaction document from Firestore
      await transactionRef.delete();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  // Login User
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  // Register User
  Future<void> registerUser(String name, String email) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
      });
    } catch (e) {
      print('Error saving user data: ${e.toString()}');
    }
  }

  // Fetch Products from Firestore
  Future<List<Product>> fetchProducts() async {
    QuerySnapshot snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }
}

class Transaction {
  final String transactionId;
  final String userId;
  List<TransactionItem> items; // Mutable
  double totalAmount; // Mutable, no final keyword
  String paymentStatus;
  final Timestamp createdAt;
  final String deliveryStatus;

  Transaction({
    required this.transactionId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentStatus,
    required this.createdAt,
    required this.deliveryStatus,
  });

  // Factory method to create a Transaction from Firestore document
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Transaction(
      transactionId: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List)
          .map((item) =>
              TransactionItem.fromFirestore(item as Map<String, dynamic>))
          .toList(),
      totalAmount: data['totalAmount'] ?? 0.0,
      paymentStatus: data['paymentStatus'] ?? '',
      createdAt: data['createdAt'],
      deliveryStatus: data['deliveryStatus'] ?? '',
    );
  }

  // Method to convert Transaction object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt,
      'deliveryStatus': deliveryStatus,
    };
  }
}

class TransactionItem {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  TransactionItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  });

  // Convert TransactionItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  // Method to get the total price for this item (price * quantity)
  double getTotalPrice() {
    return price * quantity;
  }

  // Factory method to create a TransactionItem from Firestore document
  factory TransactionItem.fromFirestore(Map<String, dynamic> data) {
    return TransactionItem(
      productId: data['productId'],
      name: data['name'],
      price: data['price'].toDouble(),
      quantity: data['quantity'] ?? 1,
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

// Product Model
class Product {
  final String id;
  final String name;
  final String description;
  final String fullDescription;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.fullDescription,
    required this.price,
    required this.imageUrl,
  });

  // Factory method to create a Product from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fullDescription: data['full_description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
