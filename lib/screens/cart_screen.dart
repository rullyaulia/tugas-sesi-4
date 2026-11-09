import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: cart.items.values.map((item) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.menu_book,
                            size: 40,
                            color: Colors.blue,
                          ),
                          title: Text(item.book.title),
                          subtitle: Text(
                            '${formatRupiah(item.book.price)}\n'
                            'Jumlah: ${item.quantity}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<CartProvider>()
                                      .removeItem(item.book.id);
                                },
                                icon: const Icon(Icons.remove_circle),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<CartProvider>()
                                      .addItem(item.book);
                                },
                                icon: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Item: ${cart.totalItems}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Total Pembayaran: ${formatRupiah(cart.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cart.totalItems == 0
                              ? null
                              : () {
                                  final messenger =
                                      ScaffoldMessenger.of(context);

                                  context
                                      .read<CartProvider>()
                                      .clearCart();

                                  Navigator.pop(context);

                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Checkout berhasil! Terima kasih telah berbelanja.',
                                      ),
                                    ),
                                  );
                                },
                          child: const Text('Checkout / Bayar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
