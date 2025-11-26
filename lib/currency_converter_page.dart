import 'package:flutter/material.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();

  // Current conversion mode
  String fromCurrency = 'USD';
  String toCurrency1 = 'EUR';
  String toCurrency2 = 'LBP';

  double result1 = 0.0;
  double result2 = 0.0;

  // Exchange rates
  final Map<String, Map<String, double>> exchangeRates = {
    'USD': {'EUR': 1.15, 'LBP': 89000.0, 'USD': 1.0},
    'EUR': {'USD': 1 / 1.15, 'LBP': 89000.0 / 1.15, 'EUR': 1.0},
    'LBP': {'USD': 1 / 89000.0, 'EUR': 1.15 / 89000.0, 'LBP': 1.0},
  };

  void _convertCurrency(String value) {
    if (value.isEmpty) {
      setState(() {
        result1 = 0.0;
        result2 = 0.0;
      });
      return;
    }

    final double inputValue = double.tryParse(value) ?? 0.0;
    setState(() {
      result1 = inputValue * (exchangeRates[fromCurrency]?[toCurrency1] ?? 0.0);
      result2 = inputValue * (exchangeRates[fromCurrency]?[toCurrency2] ?? 0.0);
    });
  }

  void _swapCurrencies() {
    setState(() {
      // Rotate currencies: USD -> EUR -> LBP -> USD
      String tempFrom = fromCurrency;

      if (fromCurrency == 'USD') {
        fromCurrency = 'EUR';
        toCurrency1 = 'LBP';
        toCurrency2 = 'USD';
      } else if (fromCurrency == 'EUR') {
        fromCurrency = 'LBP';
        toCurrency1 = 'USD';
        toCurrency2 = 'EUR';
      } else if (fromCurrency == 'LBP') {
        fromCurrency = 'USD';
        toCurrency1 = 'EUR';
        toCurrency2 = 'LBP';
      }

      // Recalculate
      _convertCurrency(_amountController.text);
    });
  }

  String _getCurrencyIcon(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'LBP':
        return 'LBP';
      default:
        return '';
    }
  }

  String _getCurrencyName(String currency) {
    switch (currency) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'LBP':
        return 'Lebanese Pound';
      default:
        return '';
    }
  }

  List<Color> _getCurrencyColors(String currency) {
    switch (currency) {
      case 'USD':
        return [Color(0xFF667eea), Color(0xFF764ba2)];
      case 'EUR':
        return [Color(0xFF11998e), Color(0xFF38ef7d)];
      case 'LBP':
        return [Color(0xFFf093fb), Color(0xFFf5576c)];
      default:
        return [Colors.blue, Colors.purple];
    }
  }

  String _formatRate(double rate) {
    if (rate >= 1000) {
      return rate.toStringAsFixed(0);
    } else if (rate >= 1) {
      return rate.toStringAsFixed(2);
    } else {
      return rate.toStringAsFixed(4);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  // Title
                  Text(
                    'Currency Converter',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Convert between USD, EUR & LBP',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),

                  // Input Card
                  _buildInputCard(),

                  SizedBox(height: 30),

                  // Swap Button
                  Center(
                    child: GestureDetector(
                      onTap: _swapCurrencies,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.swap_vert,
                          color: Color(0xFF667eea),
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Result Card 1
                  _buildResultCard(
                    icon: _getCurrencyIcon(toCurrency1),
                    title: _getCurrencyName(toCurrency1),
                    amount: result1,
                    code: toCurrency1,
                    colors: _getCurrencyColors(toCurrency1),
                  ),

                  SizedBox(height: 20),

                  // Result Card 2
                  _buildResultCard(
                    icon: _getCurrencyIcon(toCurrency2),
                    title: _getCurrencyName(toCurrency2),
                    amount: result2,
                    code: toCurrency2,
                    colors: _getCurrencyColors(toCurrency2),
                  ),

                  SizedBox(height: 30),

                  // Exchange Rates Info
                  _buildExchangeRatesInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    final colors = _getCurrencyColors(fromCurrency);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _getCurrencyIcon(fromCurrency),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                _getCurrencyName(fromCurrency),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colors[0],
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 32,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors[0], width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: _convertCurrency,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String icon,
    required String title,
    required double amount,
    required String code,
    required List<Color> colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            code,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRatesInfo() {
    final rate1 = exchangeRates[fromCurrency]?[toCurrency1] ?? 0.0;
    final rate2 = exchangeRates[fromCurrency]?[toCurrency2] ?? 0.0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Exchange Rates',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRateInfo(
                '1 $fromCurrency',
                '${_formatRate(rate1)} $toCurrency1',
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildRateInfo(
                '1 $fromCurrency',
                '${_formatRate(rate2)} $toCurrency2',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateInfo(String from, String to) {
    return Column(
      children: [
        Text(
          from,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          to,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}