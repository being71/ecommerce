import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart.dart';
import 'package:flutter/material.dart';
import 'firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  // Constructor
  DetailPage({required this.productId});

  // Fetch product details from Firestore using Stream
  Stream<DocumentSnapshot> fetchProductDetails(String productId) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .snapshots(); // This returns a stream of the product document
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the transaction already exists for this user
    DocumentReference transactionRef =
        FirebaseFirestore.instance.collection('transactions').doc(userId);

    // Get the current transaction data
    DocumentSnapshot transactionSnapshot = await transactionRef.get();

    if (transactionSnapshot.exists) {
      Map<String, dynamic> transactionData =
          transactionSnapshot.data() as Map<String, dynamic>;

      // Check if the payment status is "Paid"
      if (transactionData['paymentStatus'] == 'Paid') {
        // Clear the list of items and reset the totalAmount
        await transactionRef.update({
          'items': [],
          'totalAmount': 0.0,
          'paymentStatus': 'Pending', // Reset payment status to Pending
        });

        // After updating, re-fetch the transaction document to ensure the update was successful
        transactionSnapshot = await transactionRef.get();
        transactionData = transactionSnapshot.data() as Map<String, dynamic>;

        // Now we can safely update items, as we know the list is cleared
        print("Transaction cleared, ready for new items.");
      }

      // Update existing transaction
      List<dynamic> items = transactionData['items'] ?? [];

      // Check if the product already exists in the cart
      bool productExists = false;
      for (var item in items) {
        if (item['productId'] == product.id) {
          item['quantity'] += 1; // Increment quantity if product exists
          productExists = true;
          break;
        }
      }

      if (!productExists) {
        // Add new product to the items list
        items.add({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': 1,
          'imageUrl': product.imageUrl,
        });
      }

      // Update the transaction with new items
      await transactionRef.update({
        'items': items,
        'totalAmount': FieldValue.increment(product.price),
      });
    } else {
      // Create new transaction if it doesn't exist
      await transactionRef.set({
        'userId': userId,
        'items': [
          {
            'productId': product.id,
            'name': product.name,
            'price': product.price,
            'quantity': 1,
            'imageUrl': product.imageUrl
          }
        ],
        'totalAmount': product.price,
        'paymentStatus': 'Pending',
        'deliveryStatus': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionPage(),
                ),
                (Route<dynamic> route) => route
                    .isFirst, // Ensures only the first route remains (HomePage)
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: fetchProductDetails(productId), // Listening to product changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Product not found.'));
          } else {
            final product = Product.fromFirestore(snapshot.data!);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Wrap the entire content with a scroll view
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display product image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(product.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Display product name, price, description
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name and rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: Rp. ${product.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Description
                          Text(
                            '${product.fullDescription}',
                            style: const TextStyle(fontSize: 14.0),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add to Cart button if the product is in stock
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          addToCart(context, product);
                        },
                        child: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white, // Set button color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
