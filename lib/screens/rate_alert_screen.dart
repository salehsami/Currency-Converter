import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/currency.dart';

const _navy = Color(0xFF0C243C);
const _blue = Color(0xFF387AAE);
const _darkBlue = Color(0xFF162836);
const _surface = Color(0xFFF5F7FA);

class RateAlertScreen extends StatefulWidget {
  const RateAlertScreen({super.key});
  @override
  State<RateAlertScreen> createState() => _RateAlertScreenState();
}

class _RateAlertScreenState extends State<RateAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  Currency _from = kAllCurrencies[0]; // USD
  Currency _to = kAllCurrencies[1]; // EUR
  bool _conditionAbove = true; // true = above, false = below
  bool _loading = false;

  // Saved alerts list (local state)
  final List<_Alert> _alerts = [];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _alerts.insert(
        0,
        _Alert(
          from: _from,
          to: _to,
          targetRate: double.parse(_rateCtrl.text),
          above: _conditionAbove,
          email: _emailCtrl.text.trim(),
        ),
      );
      _loading = false;
      _rateCtrl.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'Alert set! We\'ll notify ${_emailCtrl.text.trim()}',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0C7B5E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _removeAlert(int i) {
    setState(() => _alerts.removeAt(i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _navy,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Rate Alerts',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.white.withOpacity(0.08),
                height: 1,
              ),
            ),
          ),

          // ── Hero ───────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHero()),

          // ── Create alert card ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Create New Alert',
                style: GoogleFonts.poppins(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildForm()),

          // ── Active alerts ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Active Alerts',
                    style: GoogleFonts.poppins(
                      color: _darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_alerts.length}',
                      style: GoogleFonts.poppins(
                        color: _blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _alerts.isEmpty
              ? SliverToBoxAdapter(child: _emptyAlerts())
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _AlertCard(
                      alert: _alerts[i],
                      onDelete: () => _removeAlert(i),
                    ),
                    childCount: _alerts.length,
                  ),
                ),
              ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _blue.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Never miss a rate',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set your target and we\'ll email you the moment the rate is hit.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Currency pair ────────────────────────────────────
            _label('Currency Pair'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _currencyDrop(_from, isFrom: true)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap:
                        () => setState(() {
                          final tmp = _from;
                          _from = _to;
                          _to = tmp;
                        }),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: _blue,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(child: _currencyDrop(_to, isFrom: false)),
              ],
            ),

            const SizedBox(height: 20),

            // ── Condition toggle ─────────────────────────────────
            _label('Alert Condition'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ConditionChip(
                    label: 'Rate goes above',
                    icon: Icons.arrow_upward_rounded,
                    selected: _conditionAbove,
                    color: const Color(0xFF0C7B5E),
                    onTap: () => setState(() => _conditionAbove = true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ConditionChip(
                    label: 'Rate goes below',
                    icon: Icons.arrow_downward_rounded,
                    selected: !_conditionAbove,
                    color: const Color(0xFFB8440A),
                    onTap: () => setState(() => _conditionAbove = false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Target rate ──────────────────────────────────────
            _label('Target Rate (${_from.code} → ${_to.code})'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _rateCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. 1.2500',
                prefixIcon: const Icon(
                  Icons.price_change_outlined,
                  color: _blue,
                  size: 20,
                ),
                filled: true,
                fillColor: _surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter a target rate';
                if (double.tryParse(v) == null) return 'Invalid number';
                return null;
              },
            ),

            const SizedBox(height: 20),

            // ── Email ────────────────────────────────────────────
            _label('Notification Email'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'you@example.com',
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: _blue,
                  size: 20,
                ),
                filled: true,
                fillColor: _surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // ── Submit button ────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _blue.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    _loading
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_active_rounded,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Create Alert',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      color: _darkBlue,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
  );

  Widget _currencyDrop(Currency value, {required bool isFrom}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<Currency>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey,
          size: 18,
        ),
        items:
            kAllCurrencies
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Text(c.flag, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          c.code,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
        onChanged: (c) {
          if (c == null) return;
          setState(() {
            if (isFrom)
              _from = c;
            else
              _to = c;
          });
        },
      ),
    );
  }

  Widget _emptyAlerts() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _blue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: _blue,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No alerts yet',
            style: GoogleFonts.poppins(
              color: _darkBlue,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first alert above to get notified when a rate is hit.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Condition chip ────────────────────────────────────────────────────
class _ConditionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ConditionChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? color : Colors.grey[400], size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? color : Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Alert data model ──────────────────────────────────────────────────
class _Alert {
  final Currency from;
  final Currency to;
  final double targetRate;
  final bool above;
  final String email;

  const _Alert({
    required this.from,
    required this.to,
    required this.targetRate,
    required this.above,
    required this.email,
  });
}

// ── Alert card widget ─────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  final _Alert alert;
  final VoidCallback onDelete;

  const _AlertCard({required this.alert, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color =
        alert.above ? const Color(0xFF0C7B5E) : const Color(0xFFB8440A);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Colour indicator
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pair row
                Row(
                  children: [
                    Text(
                      '${alert.from.flag} ${alert.from.code}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _darkBlue,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${alert.to.flag} ${alert.to.code}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _darkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Condition
                Row(
                  children: [
                    Icon(
                      alert.above
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${alert.above ? 'Above' : 'Below'} ${alert.targetRate.toStringAsFixed(4)}',
                      style: GoogleFonts.poppins(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alert.email,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Active badge + delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C7B5E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0C7B5E),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
