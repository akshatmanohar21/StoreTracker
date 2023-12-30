import 'package:flutter/material.dart';
import 'products.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final List<Product> products;

  SearchPage({required this.products});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                hintText: 'Enter product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _searchProducts(query);
              },
            ),
            SizedBox(height: 16.0),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (filteredProducts.isEmpty) {
      return Center(
        child: Text('No results found.'),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text(
                'Quantity: ${product.quantity}, Price: ₹${NumberFormat("#,##0.00").format(product.price)}',
              ),
            );
          },
        ),
      );
    }
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProducts = widget.products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
}
