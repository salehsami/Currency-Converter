import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'screens/currency_chart_screen.dart';
import 'screens/exchange_rates.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ExchangeRatesScreen(),
    CurrencyChartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0C243C),
        title: const Text(
          'Globe Max',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF387AAE),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange),
                label: 'Convert',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Charts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
