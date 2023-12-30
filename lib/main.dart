import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'products.dart';
import 'search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoreTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.pinkAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Product> products = [];
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StoreTracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _getBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getBody() {
    if (_currentIndex == 0) {
      return _buildHomePage();
    } else if (_currentIndex == 1) {
      return ProductsPage(products: products, onDelete: _deleteProduct);
    } else if (_currentIndex == 2) {
      return SearchPage(products: products);
    } else {
      return Center(
        child: Text(
          'Page under construction.',
          style: TextStyle(color: Colors.grey[600], fontSize: 18.0),
        ),
      );
    }
  }

  Widget _buildHomePage() {
    double screenHeight = MediaQuery.of(context).size.height;
    double upperFragmentHeight = screenHeight * 0.475;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: upperFragmentHeight,
          child: _buildProductEntryForm(),
        ),
        Expanded(
          child: _buildProductList(),
        ),
      ],
    );
  }

  Widget _buildProductEntryForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Product Entry Form',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter quantity',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (₹)',
                  hintText: 'Enter price',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  double price = double.tryParse(priceController.text) ?? 0.0;
                  int quantity = int.tryParse(quantityController.text) ?? 0;
                  if (productNameController.text.isNotEmpty && quantity > 0 && price > 0) {
                    setState(() {
                      products.add(Product(
                        id: UniqueKey().toString(),
                        name: productNameController.text,
                        quantity: quantity,
                        price: price * quantity,
                      ));
                      productNameController.clear();
                      quantityController.clear();
                      priceController.clear();
                    });
                  } else {
                    // Handle invalid input
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text('Add Product', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products added yet.',
          style: TextStyle(color: Colors.grey[600], fontSize: 18.0),
        ),
      );
    } else {
      return ProductsPage(products: products, onDelete: _deleteProduct);
    }
  }

  void _deleteProduct(String productId) {
    setState(() {
      products.removeWhere((product) => product.id == productId);
    });
  }

  Widget _buildBottomNavBar() {
    return DotNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        DotNavigationBarItem(
          icon: Icon(Icons.home),
          selectedColor: Colors.red,
        ),
        DotNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          selectedColor: Colors.red,
        ),
        DotNavigationBarItem(
          icon: Icon(Icons.search),
          selectedColor: Colors.red,
        ),
      ],
      backgroundColor: Colors.grey[200],
    );
  }
}
