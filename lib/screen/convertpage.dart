import 'package:flutter/material.dart';

import '../model/currency.dart';

class ConvertPage extends StatefulWidget {
  final String targetCurrency;
  final List<Currency> currencyList;
  ConvertPage({required this.targetCurrency, required this.currencyList});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  late TextEditingController _amountController;
  String _sourceCurrency = 'THB';
  String _selectedTargetCurrency =
      ''; // Local variable to hold selected target currency
  double _convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _selectedTargetCurrency =
        widget.targetCurrency; // Initialize with the provided targetCurrency
  }

  void _convertCurrency() {
    try {
      double amount = double.parse(_amountController.text);

      // Find the source and target currencies in the currencyList
      Currency sourceCurrency = widget.currencyList
          .firstWhere((currency) => currency.data.containsKey(_sourceCurrency));
      Currency targetCurrency = widget.currencyList.firstWhere(
          (currency) => currency.data.containsKey(_selectedTargetCurrency));

      // Get the exchange rates for the source and target currencies
      double sourceRate = sourceCurrency.data[_sourceCurrency]!.value;
      double targetRate = targetCurrency.data[_selectedTargetCurrency]!.value;

      // Calculate the converted amount
      _convertedAmount = (amount / sourceRate) * targetRate;

      setState(() {});
    } catch (e) {
      print('Error converting currency: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            // Navigate back when the back button is pressed
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.cyanAccent,
                child: const Text(
                  "Currency Convert",
                  style: TextStyle(color: Color.fromRGBO(115, 255, 171, 1)),
                ),
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(7, 106, 47, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Amount'),
            ),
            Row(
              children: [
                DropdownButton<String>(
                  isDense: true, // Reduces the dropdown's height
                  itemHeight: 50,
                  value: _sourceCurrency,
                  items: widget.currencyList
                      .expand((currency) => currency.data.keys)
                      .toSet()
                      .map((currencyCode) => DropdownMenuItem<String>(
                            value: currencyCode,
                            child: Text(currencyCode),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _sourceCurrency = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  isDense: true, // Reduces the dropdown's height
                  itemHeight: 50,
                  value: _selectedTargetCurrency,
                  items: widget.currencyList
                      .expand((currency) => currency.data.keys)
                      .toSet()
                      .map((currencyCode) => DropdownMenuItem<String>(
                            value: currencyCode,
                            child: Text(currencyCode),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTargetCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16.0),
            Text('Converted Amount: $_convertedAmount'),
          ],
        ),
      ),
    );
  }
}
