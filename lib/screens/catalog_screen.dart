import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class BookCatalogScreen extends StatelessWidget {
  const BookCatalogScreen({super.key});

  final List<Book> books = const [
    Book(
      id: '1',
      title: 'Pemrograman Flutter',
      author: 'Rizky Pratama',
      price: 85000,
      imageUrl: '',
    ),
    Book(
      id: '2',
      title: 'Dasar Pemrograman Dart',
      author: 'Andi Wijaya',
      price: 75000,
      imageUrl: '',
    ),
    Book(
      id: '3',
      title: 'Belajar Database',
      author: 'Budi Santoso',
      price: 90000,
      imageUrl: '',
    ),
    Book(
      id: '4',
      title: 'Mobile App Development',
      author: 'Dewi Lestari',
      price: 100000,
      imageUrl: '',
    ),
  ];

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Ganti Tema',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 55,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Penulis: ${book.author}'),
                        Text(
                          formatRupiah(book.price),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CartProvider>().addItem(book);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${book.title} ditambahkan ke keranjang',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Tambah ke Keranjang'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
