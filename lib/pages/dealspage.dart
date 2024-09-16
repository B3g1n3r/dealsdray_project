import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DealsPage extends StatefulWidget {
  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  List<dynamic> deals = [];
  List<dynamic> unboxedDeals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeals();
  }

  Future<void> fetchDeals() async {
    const String apiUrl =
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          deals = data['data']['products'];
          unboxedDeals = data['data']['unboxed_deals'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load deals');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Deals',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildDealsList(deals),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Unboxed Deals',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildUnboxedDealsList(unboxedDeals),
                ],
              ),
            ),
    );
  }

  Widget buildDealsList(List<dynamic> dealsList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dealsList.length,
      itemBuilder: (context, index) {
        final deal = dealsList[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              deal['icon'],
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            title: Text(deal['label']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal['SubLabel'] ?? 'No description'),
                Text('Offer: ${deal['offer']}',
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }

  Widget buildUnboxedDealsList(List<dynamic> unboxedDealsList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: unboxedDealsList.length,
      itemBuilder: (context, index) {
        final deal = unboxedDealsList[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              deal['icon'],
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            title: Text(deal['label']),
            subtitle: Text('Offer: ${deal['offer']}',
                style: const TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}
