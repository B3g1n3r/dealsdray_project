import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic> upcomingLaptops = [];
  List<dynamic> featuredLaptops = [];
  List<dynamic> topSellingProducts = [];
  List<dynamic> brandListings = [];
  List<dynamic> categoriesListing = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    const String apiUrl =
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          upcomingLaptops = data['data']['upcoming_laptops'] ?? [];
          featuredLaptops = data['data']['featured_laptop'] ?? [];
          topSellingProducts = data['data']['top_selling_products'] ?? [];
          brandListings = data['data']['brand_listing'] ?? [];
          categoriesListing = data['data']['categories_listing'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Widget buildSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        items.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No items available'),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          item['icon'] ?? '',
                          height: 50,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['label'] ?? 'No label',
                          style: const TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  buildSection('Upcoming Laptops', upcomingLaptops),
                  buildSection('Featured Laptops', featuredLaptops),
                  buildSection('Top Selling Products', topSellingProducts),
                  buildSection('Brand Listings', brandListings),
                  buildSection('Categories Listing', categoriesListing),
                ],
              ),
            ),
    );
  }
}
