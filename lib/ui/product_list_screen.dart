import 'package:flutter/material.dart';
import 'package:tezda_task/models/product.dart';
import 'package:tezda_task/services/api_service.dart';
import 'package:tezda_task/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/ui/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;
  final AuthService _authService = AuthService();

  List<String> favoriteProductIds = [];

  @override
  void initState() {
    super.initState();

    final ApiService apiService = ApiService();
    _futureProducts = apiService.fetchProducts();
    _authService.fetchFavorites(_authService.auth.currentUser!.uid).then((value) => favoriteProductIds = value);
  }

  void _toggleFavorite(Product product) async {
    if (_authService.auth.currentUser == null) return;

    DocumentReference favoriteRef = _authService.firestore.collection('users').doc(_authService.auth.currentUser!.uid).collection('favorites').doc(product.id);

    if (favoriteProductIds.contains(product.id)) {
      await favoriteRef.delete();
      setState(() {
        favoriteProductIds.remove(product.id);
      });
    } else {
      await favoriteRef.set({
        'productId': product.id,
      });
      setState(() {
        favoriteProductIds.add(product.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  product.isFavorite = favoriteProductIds.contains(product.id);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => _toggleFavorite(product),
                                child: Icon(
                                  product.isFavorite! ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: product.isFavorite! ? Colors.red : Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$${product.price}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
