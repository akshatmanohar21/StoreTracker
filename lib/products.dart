import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductsPage extends StatelessWidget {
  final List<Product> products;
  final Function(String) onDelete;

  ProductsPage({required this.products, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    double totalAmount = calculateTotalAmount(products);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: _getBody(totalAmount),
    );
  }

  Widget _getBody(double totalAmount) {
    if (products.isEmpty) {
      return Center(
        child: Text('No products added yet.'),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Quantity: ${product.quantity}, Price: ₹${NumberFormat("#,##0.00").format(product.price)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDelete(product.id),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Amount Earned: ₹${NumberFormat("#,##0.00").format(totalAmount)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  double calculateTotalAmount(List<Product> products) {
    return products.fold(0, (double sum, Product product) => sum + product.price);
  }
}

class Product {
  final String id;
  String name;
  int quantity;
  double price;

  Product({required this.id, required this.name, required this.quantity, required this.price});
}
