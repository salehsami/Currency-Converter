// lib/screens/exchange_rates.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/currency.dart';

const String _kApiKey = '98cac62f0bc07bda25b98fb6';
const _navy = Color(0xFF0C243C);
const _blue = Color(0xFF387AAE);
const _darkBlue = Color(0xFF162836);
const _surface = Color(0xFFF5F7FA);

const List<String> _kWatchlist = [
  'USD',
  'EUR',
  'GBP',
  'JPY',
  'AED',
  'PKR',
  'INR',
  'CAD',
  'AUD',
  'CHF',
  'CNY',
  'SAR',
];

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});
  @override
  State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen>
    with SingleTickerProviderStateMixin {
  Currency _base = kAllCurrencies[0];
  Map<String, double> _rates = {};
  bool _loading = false;
  String? _error;
  DateTime? _lastUpdated;
  String _search = '';
  bool _showSearch = false;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  final _searchCtrl = TextEditingController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fetch();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    _fadeCtrl.reset();
    try {
      final res = await http.get(
        Uri.parse(
          'https://v6.exchangerate-api.com/v6/$_kApiKey/latest/${_base.code}',
        ),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['result'] == 'success') {
          setState(() {
            _rates = Map<String, double>.fromEntries(
              (data['conversion_rates'] as Map<String, dynamic>).entries.map(
                (e) => MapEntry(e.key, (e.value as num).toDouble()),
              ),
            );
            _lastUpdated = DateTime.now();
          });
          _fadeCtrl.forward();
        } else {
          setState(() => _error = data['error-type']);
        }
      } else {
        setState(() => _error = 'HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Currency> get _filtered {
    final q = _search.toLowerCase();
    if (q.isEmpty) return kAllCurrencies;
    return kAllCurrencies
        .where(
          (c) =>
              c.code.toLowerCase().contains(q) ||
              c.name.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Currency> get _watchlist =>
      kAllCurrencies
          .where((c) => _kWatchlist.contains(c.code) && c.code != _base.code)
          .toList();

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        setState(() => _error = null);
      });
    }

    return Scaffold(
      backgroundColor: _surface,
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _fetch,
        color: _blue,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildSliverHeader(),
            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: _blue)),
              )
            else ...[
              if (_search.isEmpty) ...[
                _sectionLabel('Watchlist'),
                // ── FIX: increased strip height to 112 to stop vertical overflow ──
                SliverToBoxAdapter(child: _buildWatchlistStrip()),
                _sectionLabel('All Currencies'),
              ],
              SliverFadeTransition(
                opacity: _fadeAnim,
                sliver: SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final list = _filtered;
                      if (i >= list.length) return null;
                      return _RateListTile(
                        currency: list[i],
                        base: _base,
                        rate: _rates[list[i].code] ?? 0.0,
                      );
                    }, childCount: _filtered.length),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: _showSearch ? 230 : 195,
      backgroundColor: _navy,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildHeaderContent(),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Rates',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_lastUpdated != null)
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00E5A0),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Updated ${DateFormat('HH:mm').format(_lastUpdated!)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              _HeaderAction(
                icon:
                    _showSearch
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                onTap:
                    () => setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        _search = '';
                        _searchCtrl.clear();
                      }
                    }),
              ),
              const SizedBox(width: 8),
              _HeaderAction(icon: Icons.refresh_rounded, onTap: _fetch),
            ],
          ),
          const SizedBox(height: 14),
          _BasePicker(
            value: _base,
            onChanged: (c) {
              setState(() => _base = c);
              _fetch();
            },
          ),
          if (_showSearch) ...[
            const SizedBox(height: 10),
            _SearchBar(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              onClear: () {
                _searchCtrl.clear();
                setState(() => _search = '');
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    ),
  );

  Widget _buildWatchlistStrip() {
    // ── FIX: 112 gives cards enough room (14 padding × 2 + content) ──
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _watchlist.length,
        itemBuilder: (_, i) {
          final c = _watchlist[i];
          final rate = _rates[c.code] ?? 0.0;
          final seed = c.code.codeUnits.fold(0, (a, b) => a + b);
          final change = ((seed % 200) - 100) / 1000;
          return _WatchCard(
            currency: c,
            rate: rate,
            change: change,
            positive: change >= 0,
          );
        },
      ),
    );
  }
}

// ── Base picker ───────────────────────────────────────────────────────
// FIXED: replaced DropdownButton-in-Row (gives items only ~28px width →
// overflow) with a GestureDetector that opens a full bottom sheet.
class _BasePicker extends StatelessWidget {
  final Currency value;
  final ValueChanged<Currency> onChanged;
  const _BasePicker({required this.value, required this.onChanged});

  void _open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => _BasePickerSheet(
            selected: value,
            onSelected: (c) {
              onChanged(c);
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Text(value.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Base currency',
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${value.code} — ${value.name}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white54,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Base picker bottom sheet ──────────────────────────────────────────
class _BasePickerSheet extends StatefulWidget {
  final Currency selected;
  final ValueChanged<Currency> onSelected;
  const _BasePickerSheet({required this.selected, required this.onSelected});
  @override
  State<_BasePickerSheet> createState() => _BasePickerSheetState();
}

class _BasePickerSheetState extends State<_BasePickerSheet> {
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
                        'Select Base Currency',
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
                      final isSel = c.code == widget.selected.code;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: Text(
                          c.flag,
                          style: const TextStyle(fontSize: 26),
                        ),
                        title: Text(
                          c.code,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isSel ? _blue : _darkBlue,
                          ),
                        ),
                        subtitle: Text(
                          c.name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        trailing:
                            isSel
                                ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: _blue,
                                  size: 20,
                                )
                                : const Icon(
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

// ── Search bar ────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: true,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search currency…',
        hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.white38,
          size: 18,
        ),
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white38,
                    size: 16,
                  ),
                  onPressed: onClear,
                )
                : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ── Header action button ──────────────────────────────────────────────
class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    ),
  );
}

// ── Watchlist horizontal card ─────────────────────────────────────────
// FIX: removed Spacer (was pushing content past the fixed card height).
// Card height is now driven purely by its content + reduced padding (10).
class _WatchCard extends StatelessWidget {
  final Currency currency;
  final double rate;
  final double change;
  final bool positive;
  const _WatchCard({
    required this.currency,
    required this.rate,
    required this.change,
    required this.positive,
  });

  String _fmt(double r) {
    if (r >= 1000) return r.toStringAsFixed(1);
    if (r >= 10) return r.toStringAsFixed(2);
    return r.toStringAsFixed(4);
  }

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF00B87C) : const Color(0xFFE74C3C);
    return Container(
      width: 120,
      // ── FIX: removed fixed height – let content size itself naturally ──
      margin: const EdgeInsets.only(right: 10, bottom: 4, top: 4),
      padding: const EdgeInsets.all(10), // was 14, reduced to avoid overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        mainAxisSize: MainAxisSize.min, // ← don't expand beyond content
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currency.flag, style: const TextStyle(fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${positive ? '+' : ''}${(change * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // was Spacer — fixed amount, not greedy
          Text(
            currency.code,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _darkBlue,
            ),
          ),
          Text(
            rate > 0 ? _fmt(rate) : '—',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rate list tile ────────────────────────────────────────────────────
class _RateListTile extends StatelessWidget {
  final Currency currency;
  final Currency base;
  final double rate;
  const _RateListTile({
    required this.currency,
    required this.base,
    required this.rate,
  });

  bool get _isBase => currency.code == base.code;

  String _fmt(double r) {
    if (r >= 10000) return r.toStringAsFixed(0);
    if (r >= 1000) return r.toStringAsFixed(1);
    if (r >= 10) return r.toStringAsFixed(2);
    return r.toStringAsFixed(4);
  }

  @override
  Widget build(BuildContext context) {
    final seed = currency.code.codeUnits.fold(0, (a, b) => a + b);
    final change = ((seed % 200) - 100) / 1000;
    final positive = change >= 0;
    final changeColor =
        _isBase
            ? _blue
            : (positive ? const Color(0xFF00B87C) : const Color(0xFFE74C3C));

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _isBase ? _blue.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isBase ? _blue.withOpacity(0.25) : Colors.transparent,
        ),
        boxShadow:
            _isBase
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.035),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Flag circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isBase ? _blue.withOpacity(0.1) : _surface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currency.flag,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),

                // Code + name  ── FIX: Expanded wraps the whole column so
                // the BASE badge row can never overflow right ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── FIX: Row must not exceed its Expanded parent.
                      // Wrap the code text in Flexible so the BASE badge
                      // is always visible without overflowing ──
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              currency.code,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _isBase ? _blue : _darkBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_isBase) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: _blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'BASE',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        currency.name,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Mini sparkline
                if (!_isBase && rate > 0) ...[
                  _MiniSparkline(
                    seed: seed,
                    positive: positive,
                    color: changeColor,
                  ),
                  const SizedBox(width: 12),
                ],

                // Rate + change badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _isBase ? '1.0000' : _fmt(rate),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _isBase ? _blue : _darkBlue,
                      ),
                    ),
                    if (!_isBase && rate > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            positive
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            size: 14,
                            color: changeColor,
                          ),
                          Text(
                            '${positive ? '+' : ''}${(change * 100).toStringAsFixed(2)}%',
                            style: GoogleFonts.poppins(
                              color: changeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    else if (_isBase)
                      Text(
                        'base rate',
                        style: GoogleFonts.poppins(
                          color: _blue.withOpacity(0.6),
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mini sparkline bars ───────────────────────────────────────────────
class _MiniSparkline extends StatelessWidget {
  final int seed;
  final bool positive;
  final Color color;
  const _MiniSparkline({
    required this.seed,
    required this.positive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(seed);
    final bars = List.generate(6, (_) => 0.3 + rng.nextDouble() * 0.7);
    bars[5] = positive ? 0.9 : 0.15;
    return SizedBox(
      width: 30,
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            bars
                .map(
                  (h) => Container(
                    width: 3,
                    height: 20 * h,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
