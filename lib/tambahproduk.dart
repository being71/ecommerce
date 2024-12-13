import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Kategori Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL Gambar Produk",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String description = descriptionController.text;
                  int price = int.tryParse(priceController.text) ?? 0;
                  int stock = int.tryParse(stockController.text) ?? 0;
                  String category = categoryController.text;
                  String imageUrl = imageUrlController.text;

                  if (name.isNotEmpty &&
                      description.isNotEmpty &&
                      price > 0 &&
                      stock > 0 &&
                      category.isNotEmpty &&
                      imageUrl.isNotEmpty) {
                    try {
                      // Tambahkan produk ke Firestore
                      await _firestore.collection("products").add({
                        "name": name,
                        "description": description,
                        "price": price,
                        "stock": stock,
                        "category": category,
                        "imageUrl": imageUrl,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Produk berhasil ditambahkan")),
                      );

                      // Bersihkan input
                      nameController.clear();
                      descriptionController.clear();
                      priceController.clear();
                      stockController.clear();
                      categoryController.clear();
                      imageUrlController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Mohon lengkapi semua field")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Tambahkan Produk",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
