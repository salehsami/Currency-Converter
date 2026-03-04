import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rate_alert_screen.dart';

const _navy = Color(0xFF0C243C);
const _blue = Color(0xFF387AAE);
const _darkBlue = Color(0xFF162836);
const _surface = Color(0xFFF5F7FA);

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sticky App Bar ─────────────────────────────────────────
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
              'Services',
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

          // ── Hero banner ────────────────────────────────────────────
          SliverToBoxAdapter(child: _HeroBanner()),

          // ── Section label ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'What we offer',
                style: GoogleFonts.poppins(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // ── Service cards ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ServiceCard(
                  icon: Icons.notifications_active_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF387AAE), Color(0xFF1E5C8B)],
                  ),
                  title: 'Rate Alerts',
                  subtitle: 'Get notified the moment your target rate is hit',
                  badge: 'Popular',
                  onTap:
                      () => Navigator.of(
                        context,
                      ).push(_slideRoute(const RateAlertScreen())),
                ),
                const SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.sim_card_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0C7B5E), Color(0xFF0A5C47)],
                  ),
                  title: 'Free International SIM',
                  subtitle:
                      'Order a free SIM and stay connected worldwide with Globe Max',
                  onTap: () => _launch('https://gupimobile.co.uk/'),
                ),
                const SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.newspaper_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B4FA0), Color(0xFF5C3778)],
                  ),
                  title: 'Currency Newsletter',
                  subtitle:
                      'Weekly insights, market trends and analysis delivered to you',
                  onTap: () => _launch('https://globemax.world/currency-news/'),
                ),
                const SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.menu_book_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB8620A), Color(0xFF8A4A08)],
                  ),
                  title: 'Currency Encyclopedia',
                  subtitle:
                      'Explore every currency in the world with detailed history and data',
                  onTap: () => _launch('https://globemax.world/currency/'),
                ),
              ]),
            ),
          ),

          // ── About section ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text(
                'Globe Max',
                style: GoogleFonts.poppins(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: _SmallTile(
                        icon: Icons.people_alt_rounded,
                        label: 'Refer a Friend',
                        color: const Color(0xFF387AAE),
                        onTap:
                            () => _launch(
                              'https://globemax.world/rafer-a-friend/',
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SmallTile(
                        icon: Icons.info_outline_rounded,
                        label: 'About Us',
                        color: const Color(0xFF0C7B5E),
                        onTap:
                            () => _launch('https://globemax.world/about-us/'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SmallTile(
                        icon: Icons.mail_outline_rounded,
                        label: 'Contact',
                        color: const Color(0xFF7B4FA0),
                        onTap:
                            () => _launch('https://globemax.world/contact-us/'),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // ── Trust badge ────────────────────────────────────────────
          SliverToBoxAdapter(child: _TrustBadge()),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder:
        (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
  );
}

// ── Hero banner ──────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _blue.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _blue.withOpacity(0.5)),
                  ),
                  child: Text(
                    '500,000+ users · 175+ countries',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Smart currency\nsolutions',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Real-time rates · Secure · Transparent',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.language_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Large service card ────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Icon box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _darkBlue,
                          ),
                        ),
                        if (badge != null) ...[
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
                              badge!,
                              style: GoogleFonts.poppins(
                                color: _blue,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small icon tile ───────────────────────────────────────────────────
class _SmallTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SmallTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _darkBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Trust badge ───────────────────────────────────────────────────────
class _TrustBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _blue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _blue.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat('500K+', 'Users'),
              _divider(),
              _Stat('175+', 'Countries'),
              _divider(),
              _Stat('99.9%', 'Uptime'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, color: _blue, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Bank-grade encryption · No hidden fees · Real-time data',
                  style: GoogleFonts.poppins(
                    color: _blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(height: 32, width: 1, color: _blue.withOpacity(0.2));
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: _darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 11),
        ),
      ],
    );
  }
}
