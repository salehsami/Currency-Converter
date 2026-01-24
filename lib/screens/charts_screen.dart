import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

String _formatDate(String date) {
  final parts = date.split('-');
  return '${parts[1]}-${parts[2]}'; // MM-DD
}

///////////////////////////////

///////////////////

class _ChartsScreenState extends State<ChartsScreen> {
  // List of API keys
  final List<String> _apiKeys = [
    '90bc081057msh6531ae8b9306df6p1c5751jsn3f26f55ea662',
    '09aa4c0ac5mshbdf6dd9ed64371fp113c4djsnc01436cfd34b',
    'e04b4b2a08msh6ca4c006dc4c02cp174e14jsn4f4a03f54298',
    '7f60b5c0d0msh7c64afa703fe5f5p1de40ejsn65bce8c31250',
    '1848307b17msh5e6ee53d91f5c44p17e596jsne22210196884',
  ];

  late String _apiKey;

  static const String _host = 'currencyxchange.p.rapidapi.com';

  // 🌍 Currency data
  final Map<String, String> currencies = {
    "AUD": "Australian Dollar",
    "BRL": "Brazilian Real",
    "CAD": "Canadian Dollar",
    "CHF": "Swiss Franc",
    "CNY": "Chinese Yuan",
    "CZK": "Czech Koruna",
    "DKK": "Danish Krone",
    "EUR": "Euro",
    "GBP": "British Pound",
    "HKD": "Hong Kong Dollar",
    "HUF": "Hungarian Forint",
    "IDR": "Indonesian Rupiah",
    "ILS": "Israeli Shekel",
    "INR": "Indian Rupee",
    "ISK": "Icelandic Krona",
    "JPY": "Japanese Yen",
    "KRW": "South Korean Won",
    "MXN": "Mexican Peso",
    "MYR": "Malaysian Ringgit",
    "NOK": "Norwegian Krone",
    "NZD": "New Zealand Dollar",
    "PHP": "Philippine Peso",
    "PLN": "Polish Zloty",
    "RON": "Romanian Leu",
    "SEK": "Swedish Krona",
    "SGD": "Singapore Dollar",
    "THB": "Thai Baht",
    "TRY": "Turkish Lira",
    "USD": "US Dollar",
    "ZAR": "South African Rand",
  };

  final Map<String, String> flags = {
    "AUD": "🇦🇺",
    "BRL": "🇧🇷",
    "CAD": "🇨🇦",
    "CHF": "🇨🇭",
    "CNY": "🇨🇳",
    "CZK": "🇨🇿",
    "DKK": "🇩🇰",
    "EUR": "🇪🇺",
    "GBP": "🇬🇧",
    "HKD": "🇭🇰",
    "HUF": "🇭🇺",
    "IDR": "🇮🇩",
    "ILS": "🇮🇱",
    "INR": "🇮🇳",
    "ISK": "🇮🇸",
    "JPY": "🇯🇵",
    "KRW": "🇰🇷",
    "MXN": "🇲🇽",
    "MYR": "🇲🇾",
    "NOK": "🇳🇴",
    "NZD": "🇳🇿",
    "PHP": "🇵🇭",
    "PLN": "🇵🇱",
    "RON": "🇷🇴",
    "SEK": "🇸🇪",
    "SGD": "🇸🇬",
    "THB": "🇹🇭",
    "TRY": "🇹🇷",
    "USD": "🇺🇸",
    "ZAR": "🇿🇦",
  };

  String fromCurrency = 'GBP';
  String toCurrency = 'HKD';
  String selectedRange = '1M';

  List<FlSpot> spots = [];
  List<String> dates = [];

  double currentRate = 0;
  double percentageChange = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _apiKey = _apiKeys[Random().nextInt(_apiKeys.length)];
    fetchChart();
  }

  DateTimeRange _getRange() {
    final now = DateTime.now();
    switch (selectedRange) {
      case '1D':
        return DateTimeRange(
          start: now.subtract(const Duration(days: 1)),
          end: now,
        );
      case '1W':
        return DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
      case '1M':
        return DateTimeRange(
          start: DateTime(now.year, now.month - 1, now.day),
          end: now,
        );
      case '3M':
        return DateTimeRange(
          start: DateTime(now.year, now.month - 3, now.day),
          end: now,
        );
      case '1Y':
        return DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day),
          end: now,
        );
      default:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
    }
  }

  Future<void> fetchChart() async {
    setState(() => loading = true);

    final range = _getRange();
    final start =
        '${range.start.year}-${range.start.month.toString().padLeft(2, '0')}-${range.start.day.toString().padLeft(2, '0')}';
    final end =
        '${range.end.year}-${range.end.month.toString().padLeft(2, '0')}-${range.end.day.toString().padLeft(2, '0')}';

    final url = Uri.parse(
      'https://currencyxchange.p.rapidapi.com/api/timeseries'
      '?start_date=$start&end_date=$end&base=$fromCurrency&symbols=$toCurrency',
    );

    print('Fetching chart: $fromCurrency -> $toCurrency using $_apiKey');

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Key': _apiKey, 'X-RapidAPI-Host': _host},
    );

    print('Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('API Error: ${response.statusCode} -> ${response.body}');
      setState(() => loading = false);
      return;
    }

    final data = json.decode(response.body);

    if (!data.containsKey('rates')) {
      print('API response missing rates: $data');
      setState(() => loading = false);
      return;
    }

    final rates = data['rates'] as Map<String, dynamic>;

    spots.clear();
    dates.clear();

    int i = 0;
    for (final entry in rates.entries) {
      final value = double.tryParse(entry.value[toCurrency].toString()) ?? 0;
      spots.add(FlSpot(i.toDouble(), value));
      dates.add(entry.key);
      i++;
    }

    currentRate = spots.last.y;
    percentageChange = ((spots.last.y - spots.first.y) / spots.first.y) * 100;

    setState(() => loading = false);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
    fetchChart();
  }

  void _showPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => ListView(
            padding: const EdgeInsets.all(16),
            children:
                currencies.entries.map((e) {
                  return ListTile(
                    leading: Text(
                      flags[e.key]!,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(e.key),
                    subtitle: Text(e.value),
                    onTap: () {
                      setState(() {
                        if (isFrom) {
                          fromCurrency = e.key;
                        } else {
                          toCurrency = e.key;
                        }
                      });
                      Navigator.pop(context);
                      fetchChart();
                    },
                  );
                }).toList(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Charts',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _currencyBox(fromCurrency, true),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: _swapCurrencies,
                        ),
                        _currencyBox(toCurrency, false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '1 $fromCurrency = ${currentRate.toStringAsFixed(6)} $toCurrency',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${percentageChange.toStringAsFixed(3)}% past ${selectedRange}',
                      style: TextStyle(
                        color:
                            percentageChange >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _rangeSelector(),
                    const SizedBox(height: 16),
                    _chart(),
                  ],
                ),
              ),
    );
  }

  Widget _currencyBox(String code, bool isFrom) {
    return Expanded(
      child: InkWell(
        onTap: () => _showPicker(isFrom),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flags[code]!, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(code, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rangeSelector() {
    const ranges = ['1D', '1W', '1M', '3M', '1Y'];
    return Row(
      children:
          ranges.map((r) {
            final selected = r == selectedRange;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedRange = r);
                  fetchChart();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF387AAE) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    r,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _chart() {
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.995;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.005;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toStringAsFixed(4),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(color: Colors.red.withOpacity(0.4), strokeWidth: 1.5),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: Colors.red, // 🔴 red point
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // ❌ remove vertical grid
            drawHorizontalLine: true,
            horizontalInterval: (maxY - minY) / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15), // very subtle
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            // ⬅ LEFT Y AXIS (only one visible)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46,
                interval: (maxY - minY) / 4,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  );
                },
              ),
            ),

            // ❌ RIGHT Y AXIS (disabled)
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // // ⬇ BOTTOM X AXIS (enabled)
            // bottomTitles: AxisTitles(
            //   sideTitles: SideTitles(
            //     showTitles: true,
            //     interval: (spots.length / 4).ceilToDouble(),
            //     getTitlesWidget: (value, meta) {
            //       final index = value.toInt();
            //       if (index < 0 || index >= dates.length) {
            //         return const SizedBox.shrink();
            //       }
            //       return Padding(
            //         padding: const EdgeInsets.only(top: 6),
            //         child: Text(
            //           dates[index].substring(5), // MM-DD
            //           style: const TextStyle(fontSize: 10, color: Colors.grey),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: (spots.length / 4).ceilToDouble(), // 👈 KEY FIX
                getTitlesWidget: (value, meta) {
                  final index = value.round();

                  if (index < 0 || index >= dates.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _formatDate(dates[index]),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            // ❌ TOP X AXIS (disabled)
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: const Color(0xFF387AAE),
              barWidth: 2.8,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF387AAE).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
