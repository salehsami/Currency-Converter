// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'dart:ui' as ui;
// // import 'package:google_fonts/google_fonts.dart';

// // class SemiCircleBottomShape extends ContinuousRectangleBorder {
// //   @override
// //   Path getOuterPath(Rect rect, {ui.TextDirection? textDirection}) {
// //     final double radius = 40.0;
// //     return Path()
// //       ..moveTo(rect.left, rect.top)
// //       ..lineTo(rect.left, rect.bottom - radius)
// //       ..quadraticBezierTo(
// //         rect.center.dx,
// //         rect.bottom + radius,
// //         rect.right,
// //         rect.bottom - radius,
// //       )
// //       ..lineTo(rect.right, rect.top)
// //       ..close();
// //   }

// //   @override
// //   EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 40);
// // }

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   // Currencies for converter & exchange rates
// //   final List<Currency> _currencies = const [
// //     Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
// //     Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
// //     Currency(code: 'PKR', name: 'Pakistani Rupee', flag: '🇵🇰'),
// //     Currency(code: 'GBP', name: 'British Pound Sterling', flag: '🇬🇧'),
// //     Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵'),
// //     Currency(code: 'AED', name: 'United Arab Emirates Dirham', flag: '🇦🇪'),
// //     Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
// //     Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳'),
// //     Currency(code: 'AFN', name: 'Afghan Afghani', flag: '🇦🇫'),
// //     Currency(code: 'ALL', name: 'Albanian Lek', flag: '🇦🇱'),
// //     Currency(code: 'AMD', name: 'Armenian Dram', flag: '🇦🇲'),
// //     Currency(code: 'ANG', name: 'Netherlands Antillean Guilder', flag: '🇳🇱'),
// //     Currency(code: 'AOA', name: 'Angolan Kwanza', flag: '🇦🇴'),
// //     Currency(code: 'ARS', name: 'Argentine Peso', flag: '🇦🇷'),
// //     Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
// //     Currency(code: 'AWG', name: 'Aruban Florin', flag: '🇦🇼'),
// //     Currency(code: 'AZN', name: 'Azerbaijani Manat', flag: '🇦🇿'),
// //     Currency(code: 'BBD', name: 'Barbadian Dollar', flag: '🇧🇧'),
// //     Currency(code: 'BDT', name: 'Bangladeshi Taka', flag: '🇧🇩'),
// //     Currency(code: 'BGN', name: 'Bulgarian Lev', flag: '🇧🇬'),
// //     Currency(code: 'BHD', name: 'Bahraini Dinar', flag: '🇧🇭'),
// //     Currency(code: 'BIF', name: 'Burundian Franc', flag: '🇧🇮'),
// //     Currency(code: 'BMD', name: 'Bermudian Dollar', flag: '🇧🇲'),
// //     Currency(code: 'BND', name: 'Brunei Dollar', flag: '🇧🇳'),
// //     Currency(code: 'BOB', name: 'Bolivian Boliviano', flag: '🇧🇴'),
// //     Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
// //     Currency(code: 'BSD', name: 'Bahamian Dollar', flag: '🇧🇸'),
// //     Currency(code: 'BTN', name: 'Bhutanese Ngultrum', flag: '🇧🇹'),
// //     Currency(code: 'BWP', name: 'Botswana Pula', flag: '🇧🇼'),
// //     Currency(code: 'BYN', name: 'Belarusian Ruble', flag: '🇧🇾'),
// //     Currency(code: 'BZD', name: 'Belize Dollar', flag: '🇧🇿'),
// //     Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
// //     Currency(code: 'CDF', name: 'Congolese Franc', flag: '🇨🇩'),
// //     Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
// //     Currency(code: 'CLP', name: 'Chilean Peso', flag: '🇨🇱'),
// //     Currency(code: 'COP', name: 'Colombian Peso', flag: '🇨🇴'),
// //     Currency(code: 'CRC', name: 'Costa Rican Colón', flag: '🇨🇷'),
// //     Currency(code: 'CUP', name: 'Cuban Peso', flag: '🇨🇺'),
// //     Currency(code: 'CVE', name: 'Cape Verdean Escudo', flag: '🇨🇻'),
// //     Currency(code: 'CZK', name: 'Czech Koruna', flag: '🇨🇿'),
// //     Currency(code: 'DJF', name: 'Djiboutian Franc', flag: '🇩🇯'),
// //     Currency(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰'),
// //     Currency(code: 'DOP', name: 'Dominican Peso', flag: '🇩🇴'),
// //     Currency(code: 'DZD', name: 'Algerian Dinar', flag: '🇩🇿'),
// //     Currency(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬'),
// //     Currency(code: 'ERN', name: 'Eritrean Nakfa', flag: '🇪🇷'),
// //     Currency(code: 'ETB', name: 'Ethiopian Birr', flag: '🇪🇹'),
// //     Currency(code: 'FJD', name: 'Fijian Dollar', flag: '🇫🇯'),
// //     Currency(code: 'FKP', name: 'Falkland Islands Pound', flag: '🇫🇰'),
// //     Currency(code: 'FOK', name: 'Faroese Króna', flag: '🇫🇴'),
// //     Currency(code: 'GEL', name: 'Georgian Lari', flag: '🇬🇪'),
// //     Currency(code: 'GGP', name: 'Guernsey Pound', flag: '🇬🇬'),
// //     Currency(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭'),
// //     Currency(code: 'GIP', name: 'Gibraltar Pound', flag: '🇬🇮'),
// //     Currency(code: 'GMD', name: 'Gambian Dalasi', flag: '🇬🇲'),
// //     Currency(code: 'GNF', name: 'Guinean Franc', flag: '🇬🇳'),
// //     Currency(code: 'GTQ', name: 'Guatemalan Quetzal', flag: '🇬🇹'),
// //     Currency(code: 'GYD', name: 'Guyanese Dollar', flag: '🇬🇾'),
// //     Currency(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰'),
// //     Currency(code: 'HNL', name: 'Honduran Lempira', flag: '🇭🇳'),
// //     Currency(code: 'HRK', name: 'Croatian Kuna', flag: '🇭🇷'),
// //     Currency(code: 'HTG', name: 'Haitian Gourde', flag: '🇭🇹'),
// //     Currency(code: 'HUF', name: 'Hungarian Forint', flag: '🇭🇺'),
// //     Currency(code: 'IDR', name: 'Indonesian Rupiah', flag: '🇮🇩'),
// //     Currency(code: 'ILS', name: 'Israeli New Shekel', flag: '🇮🇱'),
// //     Currency(code: 'IMP', name: 'Isle of Man Pound', flag: '🇮🇲'),
// //     Currency(code: 'IQD', name: 'Iraqi Dinar', flag: '🇮🇶'),
// //     Currency(code: 'IRR', name: 'Iranian Rial', flag: '🇮🇷'),
// //     Currency(code: 'ISK', name: 'Icelandic Króna', flag: '🇮🇸'),
// //     Currency(code: 'JEP', name: 'Jersey Pound', flag: '🇯🇪'),
// //     Currency(code: 'JMD', name: 'Jamaican Dollar', flag: '🇯🇲'),
// //     Currency(code: 'JOD', name: 'Jordanian Dinar', flag: '🇯🇴'),
// //     Currency(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪'),
// //     Currency(code: 'KGS', name: 'Kyrgyzstani Som', flag: '🇰🇬'),
// //     Currency(code: 'KHR', name: 'Cambodian Riel', flag: '🇰🇭'),
// //     Currency(code: 'KID', name: 'Kiribati Dollar', flag: '🇰🇮'),
// //     Currency(code: 'KMF', name: 'Comorian Franc', flag: '🇰🇲'),
// //     Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷'),
// //     Currency(code: 'KWD', name: 'Kuwaiti Dinar', flag: '🇰🇼'),
// //     Currency(code: 'KYD', name: 'Cayman Islands Dollar', flag: '🇰🇾'),
// //     Currency(code: 'KZT', name: 'Kazakhstani Tenge', flag: '🇰🇿'),
// //     Currency(code: 'LAK', name: 'Laotian Kip', flag: '🇱🇦'),
// //     Currency(code: 'LBP', name: 'Lebanese Pound', flag: '🇱🇧'),
// //     Currency(code: 'LKR', name: 'Sri Lankan Rupee', flag: '🇱🇰'),
// //     Currency(code: 'LRD', name: 'Liberian Dollar', flag: '🇱🇷'),
// //     Currency(code: 'LSL', name: 'Lesotho Loti', flag: '🇱🇸'),
// //     Currency(code: 'LYD', name: 'Libyan Dinar', flag: '🇱🇾'),
// //     Currency(code: 'MAD', name: 'Moroccan Dirham', flag: '🇲🇦'),
// //     Currency(code: 'MDL', name: 'Moldovan Leu', flag: '🇲🇩'),
// //     Currency(code: 'MGA', name: 'Malagasy Ariary', flag: '🇲🇬'),
// //     Currency(code: 'MKD', name: 'Macedonian Denar', flag: '🇲🇰'),
// //     Currency(code: 'MMK', name: 'Myanma Kyat', flag: '🇲🇲'),
// //     Currency(code: 'MNT', name: 'Mongolian Tugrik', flag: '🇲🇳'),
// //     Currency(code: 'MOP', name: 'Macanese Pataca', flag: '🇲🇴'),
// //     Currency(code: 'MRU', name: 'Mauritanian Ouguiya', flag: '🇲🇷'),
// //     Currency(code: 'MUR', name: 'Mauritian Rupee', flag: '🇲🇺'),
// //     Currency(code: 'MVR', name: 'Maldivian Rufiyaa', flag: '🇲🇻'),
// //     Currency(code: 'MWK', name: 'Malawian Kwacha', flag: '🇲🇼'),
// //     Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
// //     Currency(code: 'MYR', name: 'Malaysian Ringgit', flag: '🇲🇾'),
// //     Currency(code: 'MZN', name: 'Mozambican Metical', flag: '🇲🇿'),
// //     Currency(code: 'NAD', name: 'Namibian Dollar', flag: '🇳🇦'),
// //     Currency(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬'),
// //     Currency(code: 'NIO', name: 'Nicaraguan Córdoba', flag: '🇳🇮'),
// //     Currency(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴'),
// //     Currency(code: 'NPR', name: 'Nepalese Rupee', flag: '🇳🇵'),
// //     Currency(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿'),
// //     Currency(code: 'OMR', name: 'Omani Rial', flag: '🇴🇲'),
// //     Currency(code: 'PAB', name: 'Panamanian Balboa', flag: '🇵🇦'),
// //     Currency(code: 'PEN', name: 'Peruvian Nuevo Sol', flag: '🇵🇪'),
// //     Currency(code: 'PGK', name: 'Papua New Guinean Kina', flag: '🇵🇬'),
// //     Currency(code: 'PHP', name: 'Philippine Peso', flag: '🇵🇭'),
// //     Currency(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱'),
// //     Currency(code: 'PYG', name: 'Paraguayan Guarani', flag: '🇵🇾'),
// //     Currency(code: 'QAR', name: 'Qatari Riyal', flag: '🇶🇦'),
// //     Currency(code: 'RON', name: 'Romanian Leu', flag: '🇷🇴'),
// //     Currency(code: 'RSD', name: 'Serbian Dinar', flag: '🇷🇸'),
// //     Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
// //     Currency(code: 'RWF', name: 'Rwandan Franc', flag: '🇷🇼'),
// //     Currency(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
// //     Currency(code: 'SBD', name: 'Solomon Islands Dollar', flag: '🇸🇧'),
// //     Currency(code: 'SCR', name: 'Seychellois Rupee', flag: '🇸🇨'),
// //     Currency(code: 'SDG', name: 'Sudanese Pound', flag: '🇸🇩'),
// //     Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪'),
// //     Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬'),
// //     Currency(code: 'SHP', name: 'Saint Helena Pound', flag: '🇸🇭'),
// //     Currency(code: 'SLL', name: 'Sierra Leonean Leone', flag: '🇸🇱'),
// //     Currency(code: 'SOS', name: 'Somali Shilling', flag: '🇸🇴'),
// //     Currency(code: 'SRD', name: 'Surinamese Dollar', flag: '🇸🇷'),
// //     Currency(code: 'SSP', name: 'South Sudanese Pound', flag: '🇸🇸'),
// //     Currency(code: 'STN', name: 'São Tomé and Príncipe Dobra', flag: '🇸🇹'),
// //     Currency(code: 'SYP', name: 'Syrian Pound', flag: '🇸🇾'),
// //     Currency(code: 'SZL', name: 'Eswatini Lilangeni', flag: '🇸🇿'),
// //     Currency(code: 'THB', name: 'Thai Baht', flag: '🇹🇭'),
// //     Currency(code: 'TJS', name: 'Tajikistani Somoni', flag: '🇹🇯'),
// //     Currency(code: 'TMT', name: 'Turkmenistani Manat', flag: '🇹🇲'),
// //     Currency(code: 'TND', name: 'Tunisian Dinar', flag: '🇹🇳'),
// //     Currency(code: 'TOP', name: 'Tongan Paʻanga', flag: '🇹🇴'),
// //     Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷'),
// //     Currency(code: 'TTD', name: 'Trinidad and Tobago Dollar', flag: '🇹🇹'),
// //     Currency(code: 'TWD', name: 'New Taiwan Dollar', flag: '🇹🇼'),
// //     Currency(code: 'TZS', name: 'Tanzanian Shilling', flag: '🇹🇿'),
// //     Currency(code: 'UAH', name: 'Ukrainian Hryvnia', flag: '🇺🇦'),
// //     Currency(code: 'UGX', name: 'Ugandan Shilling', flag: '🇺🇬'),
// //     Currency(code: 'UYU', name: 'Uruguayan Peso', flag: '🇺🇾'),
// //     Currency(code: 'UZS', name: 'Uzbekistani Som', flag: '🇺🇿'),
// //     Currency(code: 'VND', name: 'Vietnamese Dong', flag: '🇻🇳'),
// //     Currency(code: 'VUV', name: 'Vanuatu Vatu', flag: '🇻🇺'),
// //     Currency(code: 'WST', name: 'Samoan Tala', flag: '🇼🇸'),
// //     Currency(code: 'XAF', name: 'CFA Franc (BEAC)', flag: '🇨🇬'),
// //     Currency(code: 'XAG', name: 'Silver Ounce', flag: '🇸🇳'),
// //     Currency(code: 'XAU', name: 'Gold Ounce', flag: '🇸🇷'),
// //     Currency(code: 'XCD', name: 'East Caribbean Dollar', flag: '🇬🇩'),
// //     Currency(code: 'XOF', name: 'CFA Franc (West Africa)', flag: '🇸🇳'),
// //     Currency(code: 'XPF', name: 'CFP Franc', flag: '🇺🇸'),
// //     Currency(code: 'YER', name: 'Yemeni Rial', flag: '🇾🇪'),
// //     Currency(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦'),
// //     Currency(code: 'ZMW', name: 'Zambian Kwacha', flag: '🇿🇲'),
// //     Currency(code: 'ZWL', name: 'Zimbabwean Dollar', flag: '🇿🇼'),
// //   ];

// //   Currency? _fromCurrency;
// //   Currency? _toCurrency;
// //   double _amount = 0.0;
// //   double _conversionRate = 0.0;
// //   Map<String, double> _exchangeRates = {};
// //   bool _isLoading = false;
// //   String? _errorMessage;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fromCurrency = _currencies[0];
// //     _toCurrency = _currencies[1];
// //     _fetchExchangeRates();
// //   }

// //   Future<void> _fetchExchangeRates() async {
// //     setState(() {
// //       _isLoading = true;
// //       _errorMessage = null;
// //     });

// //     try {
// //       final response = await http.get(
// //         Uri.parse(
// //           'https://v6.exchangerate-api.com/v6/98cac62f0bc07bda25b98fb6/latest/${_fromCurrency?.code}',
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['result'] == 'success') {
// //           setState(() {
// //             _exchangeRates = Map<String, double>.fromEntries(
// //               (data['conversion_rates'] as Map<String, dynamic>).entries.map(
// //                 (e) => MapEntry(e.key, (e.value as num).toDouble()),
// //               ),
// //             );
// //             _convertCurrencies();
// //           });
// //         } else {
// //           setState(() => _errorMessage = 'API Error: ${data['error-type']}');
// //         }
// //       } else {
// //         setState(() => _errorMessage = 'HTTP Error: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       setState(() => _errorMessage = 'Network Error: $e');
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }

// //   void _convertCurrencies() {
// //     if (_fromCurrency == null || _toCurrency == null) return;

// //     if (_fromCurrency!.code == _toCurrency!.code) {
// //       _conversionRate = 1.0;
// //     } else if (_exchangeRates.containsKey(_toCurrency!.code)) {
// //       _conversionRate = _exchangeRates[_toCurrency!.code]!;
// //     } else {
// //       _conversionRate = 1.0;
// //     }
// //   }

// //   void _swapCurrencies() {
// //     setState(() {
// //       final temp = _fromCurrency;
// //       _fromCurrency = _toCurrency;
// //       _toCurrency = temp;
// //       if (_fromCurrency != null) _fetchExchangeRates();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
// //       child: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             _buildHeader(),
// //             const SizedBox(height: 20),
// //             _buildConverterCard(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeader() => Container(
// //     padding: const EdgeInsets.all(16),
// //     decoration: BoxDecoration(
// //       gradient: const LinearGradient(
// //         colors: [Color(0xFF387AAE), Color(0xFF162836)],
// //       ),
// //       borderRadius: BorderRadius.circular(12),
// //     ),
// //     child: Row(
// //       children: [
// //         const Icon(Icons.currency_exchange, color: Colors.white, size: 28),
// //         const SizedBox(width: 12),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Currency Converter',
// //               style: GoogleFonts.poppins(
// //                 color: Colors.white,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             Text(
// //               'Real-time rates',
// //               style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
// //             ),
// //           ],
// //         ),
// //       ],
// //     ),
// //   );

// //   Widget _buildConverterCard() => Card(
// //     elevation: 2,
// //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //     child: Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildCurrencyRow(
// //             'From',
// //             _fromCurrency,
// //             () => _showCurrencyPicker(true),
// //           ),
// //           const SizedBox(height: 20),
// //           _buildSwapButton(),
// //           const SizedBox(height: 20),
// //           _buildCurrencyRow(
// //             'To',
// //             _toCurrency,
// //             () => _showCurrencyPicker(false),
// //           ),
// //           const SizedBox(height: 20),
// //           _buildAmountInput(),
// //           const SizedBox(height: 20),
// //           _buildResult(),
// //         ],
// //       ),
// //     ),
// //   );

// //   Widget _buildCurrencyRow(
// //     String title,
// //     Currency? currency,
// //     VoidCallback onTap,
// //   ) => Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //       Text(
// //         title,
// //         style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
// //       ),
// //       const SizedBox(height: 8),
// //       InkWell(
// //         onTap: onTap,
// //         child: Container(
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.grey[50],
// //             borderRadius: BorderRadius.circular(8),
// //             border: Border.all(color: Colors.grey[300]!),
// //           ),
// //           child: Row(
// //             children: [
// //               Text(currency?.flag ?? '', style: const TextStyle(fontSize: 24)),
// //               const SizedBox(width: 16),
// //               Text(
// //                 currency?.code ?? 'Select',
// //                 style: GoogleFonts.poppins(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               const Spacer(),
// //               const Icon(Icons.arrow_drop_down, size: 28),
// //             ],
// //           ),
// //         ),
// //       ),
// //     ],
// //   );

// //   Widget _buildSwapButton() => Transform.scale(
// //     scale: 1.2,
// //     child: CircleAvatar(
// //       backgroundColor: const Color(0xFF00E1AF),
// //       radius: 28,
// //       child: IconButton(
// //         icon: const Icon(Icons.swap_vert, color: Colors.black),
// //         onPressed: _swapCurrencies,
// //       ),
// //     ),
// //   );

// //   Widget _buildAmountInput() => TextFormField(
// //     style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
// //     decoration: InputDecoration(
// //       prefixIcon: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 12),
// //         child: Text(
// //           '${_fromCurrency?.code}',
// //           style: GoogleFonts.poppins(
// //             fontSize: 24,
// //             fontWeight: FontWeight.w600,
// //             color: Colors.black,
// //           ),
// //         ),
// //       ),
// //       prefixIconConstraints: const BoxConstraints(minWidth: 0),
// //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //     ),
// //     keyboardType: const TextInputType.numberWithOptions(decimal: true),
// //     inputFormatters: [
// //       FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,5}')),
// //     ],
// //     onChanged:
// //         (value) => setState(() => _amount = double.tryParse(value) ?? 0.0),
// //   );

// //   Widget _buildResult() =>
// //       _isLoading
// //           ? const CircularProgressIndicator()
// //           : Column(
// //             children: [
// //               const SizedBox(height: 16),
// //               Text(
// //                 '${_toCurrency?.code ?? ''} ${(_amount * _conversionRate).toStringAsFixed(2)}',
// //                 style: GoogleFonts.poppins(
// //                   fontSize: 36,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //               Text(
// //                 '1 ${_fromCurrency?.code} = ${_conversionRate.toStringAsFixed(4)} ${_toCurrency?.code}',
// //                 style: GoogleFonts.poppins(
// //                   color: Colors.grey[600],
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ],
// //           );

// //   void _showCurrencyPicker(bool isFromCurrency) {
// //     showModalBottomSheet(
// //       context: context,
// //       builder:
// //           (_) => CurrencyPicker(
// //             currencies: _currencies,
// //             onSelected: (currency) {
// //               setState(() {
// //                 if (isFromCurrency) {
// //                   _fromCurrency = currency;
// //                   _fetchExchangeRates();
// //                 } else {
// //                   _toCurrency = currency;
// //                   _convertCurrencies();
// //                 }
// //               });
// //               Navigator.pop(context);
// //             },
// //           ),
// //     );
// //   }
// // }

// // // --- Models and Currency Picker ---
// // class Currency {
// //   final String code;
// //   final String name;
// //   final String flag;

// //   const Currency({required this.code, required this.name, required this.flag});
// // }

// // class CurrencyPicker extends StatelessWidget {
// //   final List<Currency> currencies;
// //   final Function(Currency) onSelected;

// //   const CurrencyPicker({
// //     super.key,
// //     required this.currencies,
// //     required this.onSelected,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: MediaQuery.of(context).size.height * 0.5,
// //       child: ListView.builder(
// //         itemCount: currencies.length,
// //         itemBuilder: (_, index) {
// //           final c = currencies[index];
// //           return ListTile(
// //             leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
// //             title: Text(c.code),
// //             subtitle: Text(c.name),
// //             onTap: () => onSelected(c),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';
// import '../models/currency.dart'; // ← single Currency source

// const String _kApiKey = '98cac62f0bc07bda25b98fb6';
// const _navy = Color(0xFF0C243C);
// const _blue = Color(0xFF387AAE);
// const _darkBlue = Color(0xFF162836);

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Currency _from = kAllCurrencies[0]; // USD
//   Currency _to = kAllCurrencies[1]; // EUR

//   final _amountCtrl = TextEditingController(text: '1');
//   double _rate = 0.0;
//   bool _loading = false;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRate();
//   }

//   @override
//   void dispose() {
//     _amountCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchRate() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final res = await http.get(
//         Uri.parse(
//           'https://v6.exchangerate-api.com/v6/$_kApiKey/latest/${_from.code}',
//         ),
//       );
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['result'] == 'success') {
//           final rates = data['conversion_rates'] as Map<String, dynamic>;
//           setState(() => _rate = (rates[_to.code] as num?)?.toDouble() ?? 0.0);
//         } else {
//           setState(() => _error = data['error-type']);
//         }
//       } else {
//         setState(() => _error = 'HTTP ${res.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _error = e.toString());
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   void _swap() {
//     setState(() {
//       final tmp = _from;
//       _from = _to;
//       _to = tmp;
//     });
//     _fetchRate();
//   }

//   double get _result {
//     final amt = double.tryParse(_amountCtrl.text) ?? 0.0;
//     return amt * _rate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             _buildHeroCard(),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//               child: Column(
//                 children: [
//                   _buildConverterCard(),
//                   const SizedBox(height: 16),
//                   _buildTipsCard(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Dark gradient hero ──────────────────────────────────────────────
//   Widget _buildHeroCard() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_navy, _darkBlue],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
//       ),
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Currency Converter',
//             style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Real-time rates',
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Live rate pill
//           if (_rate > 0 && !_loading)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: _blue.withOpacity(0.25),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: _blue.withOpacity(0.5)),
//               ),
//               child: Text(
//                 '1 ${_from.code} = ${_rate.toStringAsFixed(4)} ${_to.code}',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // ── White converter card ────────────────────────────────────────────
//   Widget _buildConverterCard() {
//     return Transform.translate(
//       offset: const Offset(0, -24),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 24,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // FROM
//             _CurrencyField(
//               label: 'From',
//               currency: _from,
//               onTap: () => _pickCurrency(isFrom: true),
//               child: TextFormField(
//                 controller: _amountCtrl,
//                 style: GoogleFonts.poppins(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   hintText: '0',
//                 ),
//                 keyboardType: const TextInputType.numberWithOptions(
//                   decimal: true,
//                 ),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
//                 ],
//                 onChanged: (_) => setState(() {}),
//               ),
//             ),

//             // Swap button
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Center(
//                 child: GestureDetector(
//                   onTap: _swap,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [_blue, Color(0xFF1E5C8B)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: _blue.withOpacity(0.4),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.swap_vert_rounded,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // TO
//             _CurrencyField(
//               label: 'To',
//               currency: _to,
//               onTap: () => _pickCurrency(isFrom: false),
//               child:
//                   _loading
//                       ? const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                         child: LinearProgressIndicator(color: _blue),
//                       )
//                       : _error != null
//                       ? Text(
//                         'Error',
//                         style: GoogleFonts.poppins(
//                           color: Colors.red,
//                           fontSize: 20,
//                         ),
//                       )
//                       : Text(
//                         _result.toStringAsFixed(2),
//                         style: GoogleFonts.poppins(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           color: _blue,
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTipsCard() {
//     return Transform.translate(
//       offset: const Offset(0, -16),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: _blue.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _blue.withOpacity(0.15)),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.info_outline_rounded, color: _blue, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Rates update in real-time. Tap the swap button to reverse the conversion.',
//                 style: GoogleFonts.poppins(
//                   color: _darkBlue,
//                   fontSize: 12,
//                   height: 1.5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Searchable currency picker bottom sheet ─────────────────────────
//   void _pickCurrency({required bool isFrom}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (_) => _CurrencyPickerSheet(
//             onSelected: (c) {
//               setState(() {
//                 if (isFrom)
//                   _from = c;
//                 else
//                   _to = c;
//               });
//               _fetchRate();
//               Navigator.pop(context);
//             },
//           ),
//     );
//   }
// }

// // ── Reusable currency field widget ────────────────────────────────────
// class _CurrencyField extends StatelessWidget {
//   final String label;
//   final Currency currency;
//   final VoidCallback onTap;
//   final Widget child;

//   const _CurrencyField({
//     required this.label,
//     required this.currency,
//     required this.onTap,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F7FA),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 11),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               // Currency selector pill
//               GestureDetector(
//                 onTap: onTap,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 6,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(currency.flag, style: const TextStyle(fontSize: 20)),
//                       const SizedBox(width: 6),
//                       Text(
//                         currency.code,
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 15,
//                           color: const Color(0xFF162836),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       const Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: child),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Searchable bottom sheet picker ────────────────────────────────────
// class _CurrencyPickerSheet extends StatefulWidget {
//   final ValueChanged<Currency> onSelected;
//   const _CurrencyPickerSheet({required this.onSelected});

//   @override
//   State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
// }

// class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
//   final _ctrl = TextEditingController();
//   List<Currency> _filtered = kAllCurrencies;

//   void _filter(String q) {
//     final lower = q.toLowerCase();
//     setState(() {
//       _filtered =
//           q.isEmpty
//               ? kAllCurrencies
//               : kAllCurrencies
//                   .where(
//                     (c) =>
//                         c.code.toLowerCase().contains(lower) ||
//                         c.name.toLowerCase().contains(lower),
//                   )
//                   .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.75,
//       maxChildSize: 0.95,
//       minChildSize: 0.4,
//       builder:
//           (_, scrollCtrl) => Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Column(
//               children: [
//                 // Handle
//                 Container(
//                   margin: const EdgeInsets.only(top: 10, bottom: 6),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: TextField(
//                     controller: _ctrl,
//                     autofocus: true,
//                     onChanged: _filter,
//                     decoration: InputDecoration(
//                       hintText: 'Search currency…',
//                       prefixIcon: const Icon(
//                         Icons.search_rounded,
//                         color: _blue,
//                       ),
//                       filled: true,
//                       fillColor: const Color(0xFFF5F7FA),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     controller: scrollCtrl,
//                     itemCount: _filtered.length,
//                     itemBuilder: (_, i) {
//                       final c = _filtered[i];
//                       return ListTile(
//                         leading: Text(
//                           c.flag,
//                           style: const TextStyle(fontSize: 26),
//                         ),
//                         title: Text(
//                           c.code,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         subtitle: Text(
//                           c.name,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                         onTap: () => widget.onSelected(c),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
// }

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
