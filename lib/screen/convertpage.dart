import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    //if _selectedTargetCurrency duplicate with targetCurrency
    if (_sourceCurrency == _selectedTargetCurrency) {
      _sourceCurrency = "USD";
    }
  }

  double _getCurrencyRate(String currencyCode) {
    Currency currency = widget.currencyList.firstWhere(
      (currency) => currency.data.containsKey(currencyCode),
    );
    return currency.data[currencyCode]!.value;
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

      setState(() {
        // If the conversion is successful, update the state to trigger a rebuild
      });
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
                  "แปลงสกุลเงิน",
                  style: TextStyle(
                      color: Color.fromRGBO(115, 255, 171, 1),
                      fontWeight: FontWeight.bold),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'ใส่จำนวน'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'จาก',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    DropdownButton<String>(
                      isDense: true,
                      iconSize: 40,
                      itemHeight: 50,
                      value: _sourceCurrency,
                      items: widget.currencyList
                          .expand((currency) => currency.data.keys)
                          .where((currencyCode) =>
                              currencyCode != _selectedTargetCurrency)
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
                  ],
                ),
                SizedBox(
                  width: 90,
                ),
                IconButton(
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    // Swap the source and target currencies
                    setState(() {
                      final String temp = _sourceCurrency;
                      _sourceCurrency = _selectedTargetCurrency;
                      _selectedTargetCurrency = temp;

                      _convertedAmount = 0.0;
                    });
                  },
                ),
                SizedBox(
                  width: 90,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เป็น',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    DropdownButton<String>(
                      isDense: true,
                      iconSize: 40,
                      itemHeight: 50,
                      value: _selectedTargetCurrency,
                      items: widget.currencyList
                          .expand((currency) => currency.data.keys)
                          .where(
                              (currencyCode) => currencyCode != _sourceCurrency)
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _convertCurrency,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Change the background color
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(200, 50)), // Change the size
                  ),
                  child: const Text(
                    'คำนวณ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear the text field
                    _amountController.clear();
                    setState(() {
                      _convertedAmount = 0.0;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  ),
                  child: const Text(
                    'ล้างข้อมูล',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
                'อัตราสกุลเงิน: 1 $_sourceCurrency ต่อ  ${(1 / _getCurrencyRate(_sourceCurrency)) * _getCurrencyRate(_selectedTargetCurrency)} $_selectedTargetCurrency '),
            Text(
              'ผลลัพธ์: $_convertedAmount $_selectedTargetCurrency',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
