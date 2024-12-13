import 'package:flutter/material.dart';
import 'firestore.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<List<Transaction>> transactions;

  @override
  void initState() {
    super.initState();
    transactions = FirestoreService().fetchUserTransactions();
  }

  // Method to update the quantity of an item in the transaction
  void _updateItemQuantity(
      Transaction transaction, int index, int newQuantity) {
    setState(() {
      // Update the quantity locally
      transaction.items[index].quantity = newQuantity;

      if (newQuantity == 0) {
        // Remove the item from the transaction if quantity is 0
        // Remove from the local list
        var removedItem = transaction.items.removeAt(index);

        // Also remove the item from Firestore
        FirestoreService()
            .removeItemFromTransaction(transaction.transactionId, removedItem);
      }

      // Recalculate the total amount after modifying the items
      transaction.totalAmount = 0.0;
      for (var item in transaction.items) {
        transaction.totalAmount += item.getTotalPrice(); // Use getTotalPrice()
      }

      // Check if the transaction has no items left
      if (transaction.items.isEmpty) {
        // If the items list is empty, delete the entire transaction document
        FirestoreService().deleteTransaction(transaction.transactionId);
      } else {
        // Otherwise, update the transaction in Firestore after modifying the items
        FirestoreService().updateTransaction(transaction);
      }
    });
  }

  // Function to handle payment
  void _processPayment(Transaction transaction) {
    // Add logic for handling the payment here (e.g., integrating with a payment gateway)
    // For now, we just print a message and update payment status.
    print('Processing payment for transaction ${transaction.transactionId}');

    // Simulate updating payment status
    setState(() {
      transaction.paymentStatus =
          'Paid'; // You can update this based on the payment result
    });

    FirestoreService().updateTransaction(
        transaction); // Update the payment status in Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Transactions'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Transaction>>(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          } else {
            // Filter the transactions to only show those with a "Pending" payment status
            final transactions = snapshot.data!
                .where((transaction) => transaction.paymentStatus == 'Pending')
                .toList();

            if (transactions.isEmpty) {
              return const Center(child: Text('No pending transactions.'));
            }

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Items:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...transaction.items.map((item) {
                          int itemIndex = transaction.items.indexOf(item);
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  // Product Image
                                  Image.network(
                                    item.imageUrl,
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(width: 10),
                                  // Product Name and Price
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rp. ${item.price.toInt()}',
                                          style:
                                              const TextStyle(fontSize: 12.0),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Total: Rp. ${item.getTotalPrice().toInt()}',
                                          style:
                                              const TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity controls (increase/decrease)
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          // Decrease quantity
                                          if (item.quantity > 0) {
                                            _updateItemQuantity(transaction,
                                                itemIndex, item.quantity - 1);
                                          }
                                        },
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          // Increase quantity
                                          _updateItemQuantity(transaction,
                                              itemIndex, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 10),
                        Text(
                          'Total Amount: Rp. ${transaction.totalAmount.toInt()}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Payment Button
                        ElevatedButton(
                          onPressed: () => _processPayment(transaction),
                          child: const Text('Pay Now'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors
                                  .white // You can customize the button color
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
