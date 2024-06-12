import 'package:flutter/material.dart';
import 'package:tezda_task/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.product.isFavorite! ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: widget.product.isFavorite! ? Colors.red : Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              SizedBox(height: 16.0),
              Text(
                widget.product.title,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.product.price}',
                    style: TextStyle(fontSize: 26.0, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.yellow[600],
                        size: 30,
                      ),
                      Text(
                        widget.product.rating['rate'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(' (${widget.product.rating['count']!.toString()})'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                widget.product.category.toUpperCase(),
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.product.description,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
