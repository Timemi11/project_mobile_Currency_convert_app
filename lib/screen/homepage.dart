import 'package:flutter/material.dart';

import '../api/call_api.dart';
import '../model/currency.dart';
import 'convertpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;
  String _searchText = '';
  late Future<List<Currency>> _currencyData;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currencyData = ApiCaller().fetchCurrencyData();
  }

  List<Datum> getFilteredItems(List<Currency> currencyList) {
    // Flatten the list of currencies and filter items based on the search text
    return currencyList
        .expand((currency) => currency.data.values)
        .where((item) =>
            item.code.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.cyanAccent,
          child: Text(
            "แปลงสกุลเงิน",
            style: TextStyle(
                color: Color.fromRGBO(115, 255, 171, 1),
                fontWeight: FontWeight.bold),
          ),
        )),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(7, 106, 47, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'ค้นหา...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          FutureBuilder<List<Currency>>(
            future: _currencyData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading currency data: ${snapshot.error}');
              } else {
                // Access the list of currencies from the snapshot
                List<Currency> currencyList = snapshot.data!;
                List<Datum> filteredItems = getFilteredItems(currencyList);

                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredItems[index].code),
                        subtitle: Text(filteredItems[index].value.toString()),
                        onTap: () {
                          // Navigate to DetailsPage and pass code and value
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConvertPage(
                                targetCurrency: filteredItems[index].code,
                                currencyList: currencyList,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          //Footer Date
          Container(
            child: Center(
              child: FutureBuilder<List<Currency>>(
                future: _currencyData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  } else if (snapshot.hasError) {
                    return Text("Error loading data: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No data available");
                  } else {
                    return Text(
                        "Last Updated: ${snapshot.data!.first.lastUpdatedAt.toIso8601String()}");
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
