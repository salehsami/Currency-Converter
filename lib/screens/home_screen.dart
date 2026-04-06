// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../models/currency.dart';

const String _kApiKey = '98cac62f0bc07bda25b98fb6';
const _navy = Color(0xFF0C243C);
const _blue = Color(0xFF387AAE);
const _darkBlue = Color(0xFF162836);
const _surface = Color(0xFFF5F7FA);
const _green = Color(0xFF0C7B5E);

const _quickPairs = [
  ('USD', 'EUR'),
  ('USD', 'GBP'),
  ('USD', 'PKR'),
  ('USD', 'AED'),
  ('USD', 'INR'),
  ('EUR', 'GBP'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Currency _from = kAllCurrencies[0]; // USD
  Currency _to = kAllCurrencies[1]; // EUR

  final _amountCtrl = TextEditingController(text: '1');
  double _rate = 0.0;
  bool _loading = false;

  Map<String, double> _tickerRates = {};
  bool _tickerLoading = true;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _fetchRate();
    _fetchTicker();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchRate() async {
    setState(() => _loading = true);
    try {
      final res = await http.get(
        Uri.parse(
          'https://v6.exchangerate-api.com/v6/$_kApiKey/latest/${_from.code}',
        ),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['result'] == 'success') {
          final rates = data['conversion_rates'] as Map<String, dynamic>;
          setState(() => _rate = (rates[_to.code] as num?)?.toDouble() ?? 0.0);
        }
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _fetchTicker() async {
    try {
      final res = await http.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/$_kApiKey/latest/USD'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['result'] == 'success') {
          final rates = data['conversion_rates'] as Map<String, dynamic>;
          setState(() {
            _tickerRates = Map.fromEntries(
              rates.entries.map(
                (e) => MapEntry(e.key, (e.value as num).toDouble()),
              ),
            );
            _tickerLoading = false;
          });
        }
      }
    } catch (_) {
      setState(() => _tickerLoading = false);
    }
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _fetchRate();
  }

  double get _result => (double.tryParse(_amountCtrl.text) ?? 0) * _rate;

  Currency _findCurrency(String code) => kAllCurrencies.firstWhere(
    (c) => c.code == code,
    orElse: () => kAllCurrencies.first,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildDarkHeader(),
            _buildConverterCard(),
            _buildQuickRatesSection(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ── Dark header with ticker ────────────────────────────────────────
  Widget _buildDarkHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_navy, Color(0xFF1A3A52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + live badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to GLobe Max',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Currency Converter',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              ScaleTransition(
                scale: _pulseAnim,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _green.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CD964),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF4CD964),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current rate pill
          if (_rate > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_from.flag}  1 ${_from.code}',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white38,
                      size: 14,
                    ),
                  ),
                  Text(
                    '${_to.flag}  ${_rate.toStringAsFixed(4)} ${_to.code}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          _buildTickerStrip(),
        ],
      ),
    );
  }

  Widget _buildTickerStrip() {
    if (_tickerLoading) {
      return const SizedBox(
        height: 36,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white38,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _quickPairs.length,
        itemBuilder: (_, i) {
          final from = _quickPairs[i].$1;
          final to = _quickPairs[i].$2;
          final fromR = _tickerRates[from] ?? 1.0;
          final toR = _tickerRates[to] ?? 1.0;
          final rate = fromR > 0 ? toR / fromR : 0.0;
          final active = _from.code == from && _to.code == to;

          return GestureDetector(
            onTap: () {
              setState(() {
                _from = _findCurrency(from);
                _to = _findCurrency(to);
              });
              _fetchRate();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active ? _blue : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? _blue : Colors.white.withOpacity(0.15),
                ),
              ),
              child: Text(
                '$from/$to  ${rate.toStringAsFixed(3)}',
                style: GoogleFonts.poppins(
                  color: active ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Floating converter card ─────────────────────────────────────────
  Widget _buildConverterCard() {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: _navy.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // FROM
            _CurrencyInputTile(
              label: 'You send',
              currency: _from,
              isEditable: true,
              controller: _amountCtrl,
              onPickCurrency: () => _showPicker(isFrom: true),
              onChanged: (_) => setState(() {}),
            ),

            // Swap divider
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                GestureDetector(
                  onTap: _swap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_blue, Color(0xFF1E5C8B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _blue.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            // TO
            _CurrencyInputTile(
              label: 'They receive',
              currency: _to,
              isEditable: false,
              controller: null,
              resultValue: _loading ? null : _result,
              isLoading: _loading,
              onPickCurrency: () => _showPicker(isFrom: false),
            ),

            // Rate info bar
            if (_rate > 0)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _blue,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '1 ${_from.code} = ${_rate.toStringAsFixed(6)} ${_to.code}  ·  Mid-market rate',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _fetchRate,
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: _blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Popular rates grid ──────────────────────────────────────────────
  Widget _buildQuickRatesSection() {
    final codes = ['EUR', 'GBP', 'JPY', 'AED', 'PKR', 'INR', 'CAD', 'AUD'];
    final rows =
        codes
            .map((c) => (c, _tickerRates[c] ?? 0.0))
            .where((r) => r.$2 > 0)
            .toList();

    return Transform.translate(
      offset: const Offset(0, -12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Rates',
                  style: GoogleFonts.poppins(
                    color: _darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'vs USD',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: rows.length,
              itemBuilder: (_, i) {
                final code = rows[i].$1;
                final rate = rows[i].$2;
                final cur = _findCurrency(code);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _from = _findCurrency('USD');
                      _to = cur;
                    });
                    _fetchRate();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(cur.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                code,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _darkBlue,
                                ),
                              ),
                              Text(
                                rate >= 100
                                    ? rate.toStringAsFixed(2)
                                    : rate.toStringAsFixed(4),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: _blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // // ── Feature strip ───────────────────────────────────────────────────
  void _showPicker({required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => _PickerSheet(
            onSelected: (c) {
              setState(() {
                if (isFrom)
                  _from = c;
                else
                  _to = c;
              });
              _fetchRate();
              Navigator.pop(context);
            },
          ),
    );
  }
}

// ── Currency input tile ───────────────────────────────────────────────
class _CurrencyInputTile extends StatelessWidget {
  final String label;
  final Currency currency;
  final bool isEditable;
  final TextEditingController? controller;
  final double? resultValue;
  final bool isLoading;
  final VoidCallback onPickCurrency;
  final ValueChanged<String>? onChanged;

  const _CurrencyInputTile({
    required this.label,
    required this.currency,
    required this.isEditable,
    required this.controller,
    required this.onPickCurrency,
    this.resultValue,
    this.isLoading = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Currency selector
          GestureDetector(
            onTap: onPickCurrency,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currency.flag, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.code,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: _darkBlue,
                        ),
                      ),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Amount or result
          if (isEditable)
            SizedBox(
              width: 140,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textAlign: TextAlign.right,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _darkBlue,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[300],
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          else if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: _blue),
            )
          else
            Text(
              resultValue != null
                  ? resultValue! >= 1000
                      ? resultValue!.toStringAsFixed(2)
                      : resultValue!.toStringAsFixed(4)
                  : '—',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _blue,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Searchable picker sheet ───────────────────────────────────────────
class _PickerSheet extends StatefulWidget {
  final ValueChanged<Currency> onSelected;
  const _PickerSheet({required this.onSelected});

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  final _ctrl = TextEditingController();
  List<Currency> _filtered = kAllCurrencies;

  void _filter(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered =
          q.isEmpty
              ? kAllCurrencies
              : kAllCurrencies
                  .where(
                    (c) =>
                        c.code.toLowerCase().contains(lower) ||
                        c.name.toLowerCase().contains(lower),
                  )
                  .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder:
          (_, sc) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        'Select Currency',
                        style: GoogleFonts.poppins(
                          color: _darkBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_filtered.length} currencies',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: _filter,
                    decoration: InputDecoration(
                      hintText: 'Search by code or name…',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: _blue,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: _surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: sc,
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final c = _filtered[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: Text(
                          c.flag,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(
                          c.code,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _darkBlue,
                          ),
                        ),
                        subtitle: Text(
                          c.name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onTap: () => widget.onSelected(c),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
