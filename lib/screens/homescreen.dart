import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/model/bannermodel.dart';
import 'package:shop/pages/dealspage.dart';
import 'package:shop/pages/homepage.dart';
import 'package:shop/pages/profilepage.dart';
import 'package:shop/service/apiservice.dart';
import 'package:http/http.dart' as http;

import '../pages/cartpage.dart';
import '../pages/categorypage.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String name;
  final String referralCode;

  HomeScreen({
    super.key,
    required this.email,
    required this.name,
    required this.referralCode,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<BannerData> futureBannerData;
  ApiService apiService = ApiService();
  List categories = [];
  List products = [];
  int _selectedindex = 0;

  @override
  void initState() {
    super.initState();
    futureBannerData = apiService.fetchBannerData();
    fetchCategoriesAndProducts();
  }

  Future<void> fetchCategoriesAndProducts() async {
    final response = await http.get(Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = data['data']['category'];
        products = data['data']['categories_listing'];
        print('Products: $products');
      });
    } else {
      throw Exception('Failed to load categories or products');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search here',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedindex == 4
          ? ProfileScreen(
              email: widget.email,
              name: widget.name,
              referralCode: widget.referralCode,
            )
          : _pages[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined, color: Colors.grey),
              label: 'Category'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop_2_rounded, color: Colors.grey),
              label: 'Deals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              label: 'Cart'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded, color: Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  final List<Widget> _pages = <Widget>[
    HomePage(),
    CategoryScreen(),
    DealsPage(),
    CartPage(),
  ];
}
