import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

const String _apiKey = '98cac62f0bc07bda25b98fb6';

// ── Colour palette (matches your app) ────────────────────────────────────────
const _navy = Color(0xFF0C243C);
const _blue = Color(0xFF387AAE);
const _darkBlue = Color(0xFF162836);
const _surface = Color(0xFFF5F7FA);

class _Currency {
  final String code, name, flag;
  const _Currency(this.code, this.name, this.flag);
}

// ── Master currency list ──────────────────────────────────────────────────────
const List<_Currency> _kCurrencies = [
  _Currency('USD', 'US Dollar', '🇺🇸'),
  _Currency('EUR', 'Euro', '🇪🇺'),
  _Currency('GBP', 'British Pound', '🇬🇧'),
  _Currency('JPY', 'Japanese Yen', '🇯🇵'),
  _Currency('CAD', 'Canadian Dollar', '🇨🇦'),
  _Currency('AUD', 'Australian Dollar', '🇦🇺'),
  _Currency('CHF', 'Swiss Franc', '🇨🇭'),
  _Currency('CNY', 'Chinese Yuan', '🇨🇳'),
  _Currency('INR', 'Indian Rupee', '🇮🇳'),
  _Currency('ZAR', 'South African Rand', '🇿🇦'),
  _Currency('NGN', 'Nigerian Naira', '🇳🇬'),
  _Currency('KES', 'Kenyan Shilling', '🇰🇪'),
  _Currency('GHS', 'Ghanaian Cedi', '🇬🇭'),
  _Currency('EGP', 'Egyptian Pound', '🇪🇬'),
  _Currency('ZMW', 'Zambian Kwacha', '🇿🇲'),
  _Currency('ZWL', 'Zimbabwean Dollar', '🇿🇼'),
];

// ── Helper: date-points per range ─────────────────────────────────────────────
List<DateTime> _buildDateRange(String range) {
  final now = DateTime.now();
  final List<DateTime> out = [];
  switch (range) {
    case '1W':
      for (int i = 6; i >= 0; i--) out.add(now.subtract(Duration(days: i)));
      break;
    case '1M':
      for (int i = 28; i >= 0; i -= 2) out.add(now.subtract(Duration(days: i)));
      break;
    case '3M':
      for (int i = 84; i >= 0; i -= 7) out.add(now.subtract(Duration(days: i)));
      break;
    case '6M':
      for (int i = 168; i >= 0; i -= 14)
        out.add(now.subtract(Duration(days: i)));
      break;
    case '1Y':
      for (int i = 360; i >= 0; i -= 30)
        out.add(now.subtract(Duration(days: i)));
      break;
  }
  return out;
}

// ─────────────────────────────────────────────────────────────────────────────
class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});
  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with SingleTickerProviderStateMixin {
  _Currency _from = _kCurrencies[0]; // USD
  _Currency _to = _kCurrencies[1]; // EUR
  String _range = '1M';

  List<FlSpot> _spots = [];
  List<DateTime> _dates = [];
  bool _loading = false;
  String? _error;

  double _current = 0, _high = 0, _low = 0, _change = 0;

  // For touch highlight
  int _touchedIdx = -1;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fetch();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
      _spots = [];
      _dates = [];
      _touchedIdx = -1;
    });
    _fadeCtrl.reset();

    final dates = _buildDateRange(_range);

    try {
      // Fire all requests concurrently
      final futures =
          dates.map((d) async {
            final url =
                'https://v6.exchangerate-api.com/v6/$_apiKey/history/${_from.code}/${d.year}/${d.month}/${d.day}';
            try {
              final res = await http.get(Uri.parse(url));
              if (res.statusCode == 200) {
                final body = jsonDecode(res.body);
                if (body['result'] == 'success') {
                  final rates =
                      body['conversion_rates'] as Map<String, dynamic>;
                  return (rates[_to.code] as num?)?.toDouble();
                }
              }
            } catch (_) {}
            return null;
          }).toList();

      final results = await Future.wait(futures);

      final List<FlSpot> spots = [];
      final List<DateTime> validDates = [];
      final List<double> rawRates = [];

      for (int i = 0; i < results.length; i++) {
        final r = results[i];
        if (r != null && r > 0) {
          spots.add(FlSpot(spots.length.toDouble(), r));
          validDates.add(dates[i]);
          rawRates.add(r);
        }
      }

      if (!mounted) return;
      setState(() {
        _spots = spots;
        _dates = validDates;
        if (rawRates.isNotEmpty) {
          _current = rawRates.last;
          _high = rawRates.reduce((a, b) => a > b ? a : b);
          _low = rawRates.reduce((a, b) => a < b ? a : b);
          _change =
              rawRates.length > 1
                  ? ((rawRates.last - rawRates.first) / rawRates.first) * 100
                  : 0;
        }
      });
      _fadeCtrl.forward();
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to load chart data.\n$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _fetch();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: Column(
        children: [
          // ── Dark top header ──
          _buildTopHeader(),

          // ── White card body ──
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child:
                  _loading
                      ? const Center(
                        child: CircularProgressIndicator(color: _blue),
                      )
                      : _error != null
                      ? _buildErrorState()
                      : _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top dark section: currency selector + live rate ───────────────────────
  Widget _buildTopHeader() {
    final positive = _change >= 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          // Currency pair row
          Row(
            children: [
              Expanded(child: _currencyPicker(_from, isFrom: true)),
              _swapButton(),
              Expanded(child: _currencyPicker(_to, isFrom: false)),
            ],
          ),

          if (_current > 0) ...[
            const SizedBox(height: 20),
            // Live rate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '1 ${_from.code}  =  ',
                  style: const TextStyle(color: Colors.white54, fontSize: 15),
                ),
                Text(
                  _current.toStringAsFixed(4),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _to.code,
                  style: const TextStyle(color: Colors.white54, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Change badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: (positive ? Colors.green : Colors.red).withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (positive ? Colors.greenAccent : Colors.redAccent)
                      .withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    positive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: positive ? Colors.greenAccent : Colors.redAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${positive ? '+' : ''}${_change.toStringAsFixed(2)}%  this period',
                    style: TextStyle(
                      color: positive ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _swapButton() {
    return GestureDetector(
      onTap: _swap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_blue, Color(0xFF1E5C8B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _blue.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.swap_horiz_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _currencyPicker(_Currency selected, {required bool isFrom}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: DropdownButton<_Currency>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF162836),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white54,
          size: 18,
        ),
        style: const TextStyle(color: Colors.white),
        items:
            _kCurrencies
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Text(c.flag, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              c.code,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              c.name,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
        onChanged: (val) {
          if (val == null) return;
          setState(() {
            if (isFrom)
              _from = val;
            else
              _to = val;
          });
          _fetch();
        },
      ),
    );
  }

  // ── Scrollable body: range tabs + chart + stats ───────────────────────────
  Widget _buildBody() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            _buildRangeTabs(),
            const SizedBox(height: 16),
            _buildChartCard(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildRateInfoCard(),
          ],
        ),
      ),
    );
  }

  // ── Time range pill selector ───────────────────────────────────────────────
  Widget _buildRangeTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children:
            ['1W', '1M', '3M', '6M', '1Y'].map((r) {
              final active = r == _range;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (r == _range) return;
                    setState(() => _range = r);
                    _fetch();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? _blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:
                          active
                              ? [
                                BoxShadow(
                                  color: _blue.withOpacity(0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : [],
                    ),
                    child: Text(
                      r,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey[500],
                        fontWeight: active ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // ── fl_chart line chart ───────────────────────────────────────────────────
  Widget _buildChartCard() {
    if (_spots.isEmpty) {
      return _emptyChart();
    }

    final positive = _change >= 0;
    final lineColor = positive ? _blue : const Color(0xFFE74C3C);
    final gradientStart =
        positive
            ? _blue.withOpacity(0.28)
            : const Color(0xFFE74C3C).withOpacity(0.22);
    final minY = (_low * 0.9985);
    final maxY = (_high * 1.0015);

    // Determine label format from range
    String labelFmt =
        _range == '1W' ? 'EEE' : (_range == '1Y' ? 'MMM' : 'MMM d');
    // Show ~4 bottom labels
    final double labelInterval = (_spots.length / 4).ceilToDouble();

    return Container(
      height: 270,
      padding: const EdgeInsets.fromLTRB(4, 20, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          clipData: const FlClipData.all(),

          // ── Touch ──
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              setState(() {
                if (response?.lineBarSpots != null &&
                    response!.lineBarSpots!.isNotEmpty) {
                  _touchedIdx = response.lineBarSpots!.first.x.toInt();
                } else {
                  _touchedIdx = -1;
                }
              });
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => _navy,
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipItems:
                  (spots) =>
                      spots.map((s) {
                        final idx = s.x.toInt();
                        final date = idx < _dates.length ? _dates[idx] : null;
                        return LineTooltipItem(
                          date != null
                              ? '${DateFormat('d MMM yyyy').format(date)}\n'
                              : '',
                          const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                              text: s.y.toStringAsFixed(4),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
            ),
          ),

          // ── Grid ──
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine:
                (_) => FlLine(
                  color: Colors.grey.withOpacity(0.12),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
          ),
          borderData: FlBorderData(show: false),

          // ── Axes ──
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 54,
                getTitlesWidget:
                    (v, _) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        v.toStringAsFixed(
                          v >= 100
                              ? 1
                              : v >= 10
                              ? 2
                              : 4,
                        ),
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                        textAlign: TextAlign.right,
                      ),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: labelInterval,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= _dates.length) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat(labelFmt).format(_dates[i]),
                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Line ──
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: lineColor,
              barWidth: 2.8,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, _) => spot.x.toInt() == _touchedIdx,
                getDotPainter:
                    (spot, _, __, ___) => FlDotCirclePainter(
                      radius: 5,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: lineColor,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [gradientStart, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _emptyChart() => Container(
    height: 200,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text('No data available', style: TextStyle(color: Colors.grey[400])),
  );

  // ── Stats row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard(
          'Period High',
          _high.toStringAsFixed(4),
          Colors.green[700]!,
          Icons.arrow_upward_rounded,
        ),
        const SizedBox(width: 10),
        _statCard(
          'Period Low',
          _low.toStringAsFixed(4),
          Colors.red[600]!,
          Icons.arrow_downward_rounded,
        ),
        const SizedBox(width: 10),
        _statCard(
          'Change',
          '${_change >= 0 ? '+' : ''}${_change.toStringAsFixed(2)}%',
          _change >= 0 ? Colors.green[700]! : Colors.red[600]!,
          _change >= 0
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info/hint card at the bottom ──────────────────────────────────────────
  Widget _buildRateInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white70,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_from.flag} ${_from.code}  →  ${_to.flag} ${_to.code}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Live market rate - Updates on every refresh',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _fetch,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 54, color: Colors.grey),
            const SizedBox(height: 14),
            Text(
              _error ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetch,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
