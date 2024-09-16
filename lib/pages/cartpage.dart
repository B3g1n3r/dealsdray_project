import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> browsingHistory = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    fetchBrowsingHistory();
  }

  Future<void> fetchBrowsingHistory() async {
    final response = await http.get(Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        browsingHistory = data['data']['my_browsing_history'];
        calculateTotal();
      });
    } else {
      throw Exception('Failed to load browsing history');
    }
  }

  void calculateTotal() {
    // Simulate price calculation based on offers for demo
    total = 0;
    for (var item in browsingHistory) {
      double discount = double.parse(item['offer'].replaceAll('%', ''));
      // Simulated price
      double price = 1000 - (1000 * (discount / 100));
      total += price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: browsingHistory.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: browsingHistory.length,
                    itemBuilder: (context, index) {
                      final item = browsingHistory[index];
                      return ListTile(
                        leading: Image.network(item['icon']),
                        title: Text(item['label']),
                        subtitle: Text('${item['offer']} off'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              browsingHistory.removeAt(index);
                              calculateTotal();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Checkout functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Proceeding to checkout')),
                    );
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
    );
  }
}
