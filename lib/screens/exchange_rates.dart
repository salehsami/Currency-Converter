import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class Currency {
  final String code;
  final String name;
  final String flag;

  const Currency({required this.code, required this.name, required this.flag});
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  final List<Currency> _baseCurrencies = const [
    Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    Currency(code: 'PKR', name: 'Pakistani Rupee', flag: '🇵🇰'),
    Currency(code: 'GBP', name: 'British Pound Sterling', flag: '🇬🇧'),
    Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵'),
    Currency(code: 'AED', name: 'United Arab Emirates Dirham', flag: '🇦🇪'),
    Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
    Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳'),
    Currency(code: 'AFN', name: 'Afghan Afghani', flag: '🇦🇫'),
    Currency(code: 'ALL', name: 'Albanian Lek', flag: '🇦🇱'),
    Currency(code: 'AMD', name: 'Armenian Dram', flag: '🇦🇲'),
    Currency(code: 'ANG', name: 'Netherlands Antillean Guilder', flag: '🇳🇱'),
    Currency(code: 'AOA', name: 'Angolan Kwanza', flag: '🇦🇴'),
    Currency(code: 'ARS', name: 'Argentine Peso', flag: '🇦🇷'),
    Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
    Currency(code: 'AWG', name: 'Aruban Florin', flag: '🇦🇼'),
    Currency(code: 'AZN', name: 'Azerbaijani Manat', flag: '🇦🇿'),
    Currency(code: 'BBD', name: 'Barbadian Dollar', flag: '🇧🇧'),
    Currency(code: 'BDT', name: 'Bangladeshi Taka', flag: '🇧🇩'),
    Currency(code: 'BGN', name: 'Bulgarian Lev', flag: '🇧🇬'),
    Currency(code: 'BHD', name: 'Bahraini Dinar', flag: '🇧🇭'),
    Currency(code: 'BIF', name: 'Burundian Franc', flag: '🇧🇮'),
    Currency(code: 'BMD', name: 'Bermudian Dollar', flag: '🇧🇲'),
    Currency(code: 'BND', name: 'Brunei Dollar', flag: '🇧🇳'),
    Currency(code: 'BOB', name: 'Bolivian Boliviano', flag: '🇧🇴'),
    Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
    Currency(code: 'BSD', name: 'Bahamian Dollar', flag: '🇧🇸'),
    Currency(code: 'BTN', name: 'Bhutanese Ngultrum', flag: '🇧🇹'),
    Currency(code: 'BWP', name: 'Botswana Pula', flag: '🇧🇼'),
    Currency(code: 'BYN', name: 'Belarusian Ruble', flag: '🇧🇾'),
    Currency(code: 'BZD', name: 'Belize Dollar', flag: '🇧🇿'),
    Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
    Currency(code: 'CDF', name: 'Congolese Franc', flag: '🇨🇩'),
    Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
    Currency(code: 'CLP', name: 'Chilean Peso', flag: '🇨🇱'),
    Currency(code: 'COP', name: 'Colombian Peso', flag: '🇨🇴'),
    Currency(code: 'CRC', name: 'Costa Rican Colón', flag: '🇨🇷'),
    Currency(code: 'CUP', name: 'Cuban Peso', flag: '🇨🇺'),
    Currency(code: 'CVE', name: 'Cape Verdean Escudo', flag: '🇨🇻'),
    Currency(code: 'CZK', name: 'Czech Koruna', flag: '🇨🇿'),
    Currency(code: 'DJF', name: 'Djiboutian Franc', flag: '🇩🇯'),
    Currency(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰'),
    Currency(code: 'DOP', name: 'Dominican Peso', flag: '🇩🇴'),
    Currency(code: 'DZD', name: 'Algerian Dinar', flag: '🇩🇿'),
    Currency(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬'),
    Currency(code: 'ERN', name: 'Eritrean Nakfa', flag: '🇪🇷'),
    Currency(code: 'ETB', name: 'Ethiopian Birr', flag: '🇪🇹'),
    Currency(code: 'FJD', name: 'Fijian Dollar', flag: '🇫🇯'),
    Currency(code: 'FKP', name: 'Falkland Islands Pound', flag: '🇫🇰'),
    Currency(code: 'FOK', name: 'Faroese Króna', flag: '🇫🇴'),
    Currency(code: 'GEL', name: 'Georgian Lari', flag: '🇬🇪'),
    Currency(code: 'GGP', name: 'Guernsey Pound', flag: '🇬🇬'),
    Currency(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭'),
    Currency(code: 'GIP', name: 'Gibraltar Pound', flag: '🇬🇮'),
    Currency(code: 'GMD', name: 'Gambian Dalasi', flag: '🇬🇲'),
    Currency(code: 'GNF', name: 'Guinean Franc', flag: '🇬🇳'),
    Currency(code: 'GTQ', name: 'Guatemalan Quetzal', flag: '🇬🇹'),
    Currency(code: 'GYD', name: 'Guyanese Dollar', flag: '🇬🇾'),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰'),
    Currency(code: 'HNL', name: 'Honduran Lempira', flag: '🇭🇳'),
    Currency(code: 'HRK', name: 'Croatian Kuna', flag: '🇭🇷'),
    Currency(code: 'HTG', name: 'Haitian Gourde', flag: '🇭🇹'),
    Currency(code: 'HUF', name: 'Hungarian Forint', flag: '🇭🇺'),
    Currency(code: 'IDR', name: 'Indonesian Rupiah', flag: '🇮🇩'),
    Currency(code: 'ILS', name: 'Israeli New Shekel', flag: '🇮🇱'),
    Currency(code: 'IMP', name: 'Isle of Man Pound', flag: '🇮🇲'),
    Currency(code: 'IQD', name: 'Iraqi Dinar', flag: '🇮🇶'),
    Currency(code: 'IRR', name: 'Iranian Rial', flag: '🇮🇷'),
    Currency(code: 'ISK', name: 'Icelandic Króna', flag: '🇮🇸'),
    Currency(code: 'JEP', name: 'Jersey Pound', flag: '🇯🇪'),
    Currency(code: 'JMD', name: 'Jamaican Dollar', flag: '🇯🇲'),
    Currency(code: 'JOD', name: 'Jordanian Dinar', flag: '🇯🇴'),
    Currency(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪'),
    Currency(code: 'KGS', name: 'Kyrgyzstani Som', flag: '🇰🇬'),
    Currency(code: 'KHR', name: 'Cambodian Riel', flag: '🇰🇭'),
    Currency(code: 'KID', name: 'Kiribati Dollar', flag: '🇰🇮'),
    Currency(code: 'KMF', name: 'Comorian Franc', flag: '🇰🇲'),
    Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷'),
    Currency(code: 'KWD', name: 'Kuwaiti Dinar', flag: '🇰🇼'),
    Currency(code: 'KYD', name: 'Cayman Islands Dollar', flag: '🇰🇾'),
    Currency(code: 'KZT', name: 'Kazakhstani Tenge', flag: '🇰🇿'),
    Currency(code: 'LAK', name: 'Laotian Kip', flag: '🇱🇦'),
    Currency(code: 'LBP', name: 'Lebanese Pound', flag: '🇱🇧'),
    Currency(code: 'LKR', name: 'Sri Lankan Rupee', flag: '🇱🇰'),
    Currency(code: 'LRD', name: 'Liberian Dollar', flag: '🇱🇷'),
    Currency(code: 'LSL', name: 'Lesotho Loti', flag: '🇱🇸'),
    Currency(code: 'LYD', name: 'Libyan Dinar', flag: '🇱🇾'),
    Currency(code: 'MAD', name: 'Moroccan Dirham', flag: '🇲🇦'),
    Currency(code: 'MDL', name: 'Moldovan Leu', flag: '🇲🇩'),
    Currency(code: 'MGA', name: 'Malagasy Ariary', flag: '🇲🇬'),
    Currency(code: 'MKD', name: 'Macedonian Denar', flag: '🇲🇰'),
    Currency(code: 'MMK', name: 'Myanma Kyat', flag: '🇲🇲'),
    Currency(code: 'MNT', name: 'Mongolian Tugrik', flag: '🇲🇳'),
    Currency(code: 'MOP', name: 'Macanese Pataca', flag: '🇲🇴'),
    Currency(code: 'MRU', name: 'Mauritanian Ouguiya', flag: '🇲🇷'),
    Currency(code: 'MUR', name: 'Mauritian Rupee', flag: '🇲🇺'),
    Currency(code: 'MVR', name: 'Maldivian Rufiyaa', flag: '🇲🇻'),
    Currency(code: 'MWK', name: 'Malawian Kwacha', flag: '🇲🇼'),
    Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
    Currency(code: 'MYR', name: 'Malaysian Ringgit', flag: '🇲🇾'),
    Currency(code: 'MZN', name: 'Mozambican Metical', flag: '🇲🇿'),
    Currency(code: 'NAD', name: 'Namibian Dollar', flag: '🇳🇦'),
    Currency(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬'),
    Currency(code: 'NIO', name: 'Nicaraguan Córdoba', flag: '🇳🇮'),
    Currency(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴'),
    Currency(code: 'NPR', name: 'Nepalese Rupee', flag: '🇳🇵'),
    Currency(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿'),
    Currency(code: 'OMR', name: 'Omani Rial', flag: '🇴🇲'),
    Currency(code: 'PAB', name: 'Panamanian Balboa', flag: '🇵🇦'),
    Currency(code: 'PEN', name: 'Peruvian Nuevo Sol', flag: '🇵🇪'),
    Currency(code: 'PGK', name: 'Papua New Guinean Kina', flag: '🇵🇬'),
    Currency(code: 'PHP', name: 'Philippine Peso', flag: '🇵🇭'),
    Currency(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱'),
    Currency(code: 'PYG', name: 'Paraguayan Guarani', flag: '🇵🇾'),
    Currency(code: 'QAR', name: 'Qatari Riyal', flag: '🇶🇦'),
    Currency(code: 'RON', name: 'Romanian Leu', flag: '🇷🇴'),
    Currency(code: 'RSD', name: 'Serbian Dinar', flag: '🇷🇸'),
    Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
    Currency(code: 'RWF', name: 'Rwandan Franc', flag: '🇷🇼'),
    Currency(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
    Currency(code: 'SBD', name: 'Solomon Islands Dollar', flag: '🇸🇧'),
    Currency(code: 'SCR', name: 'Seychellois Rupee', flag: '🇸🇨'),
    Currency(code: 'SDG', name: 'Sudanese Pound', flag: '🇸🇩'),
    Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪'),
    Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬'),
    Currency(code: 'SHP', name: 'Saint Helena Pound', flag: '🇸🇭'),
    Currency(code: 'SLL', name: 'Sierra Leonean Leone', flag: '🇸🇱'),
    Currency(code: 'SOS', name: 'Somali Shilling', flag: '🇸🇴'),
    Currency(code: 'SRD', name: 'Surinamese Dollar', flag: '🇸🇷'),
    Currency(code: 'SSP', name: 'South Sudanese Pound', flag: '🇸🇸'),
    Currency(code: 'STN', name: 'São Tomé and Príncipe Dobra', flag: '🇸🇹'),
    Currency(code: 'SYP', name: 'Syrian Pound', flag: '🇸🇾'),
    Currency(code: 'SZL', name: 'Eswatini Lilangeni', flag: '🇸🇿'),
    Currency(code: 'THB', name: 'Thai Baht', flag: '🇹🇭'),
    Currency(code: 'TJS', name: 'Tajikistani Somoni', flag: '🇹🇯'),
    Currency(code: 'TMT', name: 'Turkmenistani Manat', flag: '🇹🇲'),
    Currency(code: 'TND', name: 'Tunisian Dinar', flag: '🇹🇳'),
    Currency(code: 'TOP', name: 'Tongan Paʻanga', flag: '🇹🇴'),
    Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷'),
    Currency(code: 'TTD', name: 'Trinidad and Tobago Dollar', flag: '🇹🇹'),
    Currency(code: 'TWD', name: 'New Taiwan Dollar', flag: '🇹🇼'),
    Currency(code: 'TZS', name: 'Tanzanian Shilling', flag: '🇹🇿'),
    Currency(code: 'UAH', name: 'Ukrainian Hryvnia', flag: '🇺🇦'),
    Currency(code: 'UGX', name: 'Ugandan Shilling', flag: '🇺🇬'),
    Currency(code: 'UYU', name: 'Uruguayan Peso', flag: '🇺🇾'),
    Currency(code: 'UZS', name: 'Uzbekistani Som', flag: '🇺🇿'),
    Currency(code: 'VND', name: 'Vietnamese Dong', flag: '🇻🇳'),
    Currency(code: 'VUV', name: 'Vanuatu Vatu', flag: '🇻🇺'),
    Currency(code: 'WST', name: 'Samoan Tala', flag: '🇼🇸'),
    Currency(code: 'XAF', name: 'CFA Franc (BEAC)', flag: '🇨🇬'),
    Currency(code: 'XAG', name: 'Silver Ounce', flag: '🇸🇳'),
    Currency(code: 'XAU', name: 'Gold Ounce', flag: '🇸🇷'),
    Currency(code: 'XCD', name: 'East Caribbean Dollar', flag: '🇬🇩'),
    Currency(code: 'XOF', name: 'CFA Franc (West Africa)', flag: '🇸🇳'),
    Currency(code: 'XPF', name: 'CFP Franc', flag: '🇺🇸'),
    Currency(code: 'YER', name: 'Yemeni Rial', flag: '🇾🇪'),
    Currency(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦'),
    Currency(code: 'ZMW', name: 'Zambian Kwacha', flag: '🇿🇲'),
    Currency(code: 'ZWL', name: 'Zimbabwean Dollar', flag: '🇿🇼'),
  ];

  final List<Currency> _displayCurrencies = [
    Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    Currency(code: 'PKR', name: 'Pakistani Rupee', flag: '🇵🇰'),
    Currency(code: 'GBP', name: 'British Pound Sterling', flag: '🇬🇧'),
    Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵'),
    Currency(code: 'AED', name: 'United Arab Emirates Dirham', flag: '🇦🇪'),
    Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
    Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳'),
    Currency(code: 'AFN', name: 'Afghan Afghani', flag: '🇦🇫'),
    Currency(code: 'ALL', name: 'Albanian Lek', flag: '🇦🇱'),
    Currency(code: 'AMD', name: 'Armenian Dram', flag: '🇦🇲'),
    Currency(code: 'ANG', name: 'Netherlands Antillean Guilder', flag: '🇳🇱'),
    Currency(code: 'AOA', name: 'Angolan Kwanza', flag: '🇦🇴'),
    Currency(code: 'ARS', name: 'Argentine Peso', flag: '🇦🇷'),
    Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
    Currency(code: 'AWG', name: 'Aruban Florin', flag: '🇦🇼'),
    Currency(code: 'AZN', name: 'Azerbaijani Manat', flag: '🇦🇿'),
    Currency(code: 'BBD', name: 'Barbadian Dollar', flag: '🇧🇧'),
    Currency(code: 'BDT', name: 'Bangladeshi Taka', flag: '🇧🇩'),
    Currency(code: 'BGN', name: 'Bulgarian Lev', flag: '🇧🇬'),
    Currency(code: 'BHD', name: 'Bahraini Dinar', flag: '🇧🇭'),
    Currency(code: 'BIF', name: 'Burundian Franc', flag: '🇧🇮'),
    Currency(code: 'BMD', name: 'Bermudian Dollar', flag: '🇧🇲'),
    Currency(code: 'BND', name: 'Brunei Dollar', flag: '🇧🇳'),
    Currency(code: 'BOB', name: 'Bolivian Boliviano', flag: '🇧🇴'),
    Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
    Currency(code: 'BSD', name: 'Bahamian Dollar', flag: '🇧🇸'),
    Currency(code: 'BTN', name: 'Bhutanese Ngultrum', flag: '🇧🇹'),
    Currency(code: 'BWP', name: 'Botswana Pula', flag: '🇧🇼'),
    Currency(code: 'BYN', name: 'Belarusian Ruble', flag: '🇧🇾'),
    Currency(code: 'BZD', name: 'Belize Dollar', flag: '🇧🇿'),
    Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
    Currency(code: 'CDF', name: 'Congolese Franc', flag: '🇨🇩'),
    Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
    Currency(code: 'CLP', name: 'Chilean Peso', flag: '🇨🇱'),
    Currency(code: 'COP', name: 'Colombian Peso', flag: '🇨🇴'),
    Currency(code: 'CRC', name: 'Costa Rican Colón', flag: '🇨🇷'),
    Currency(code: 'CUP', name: 'Cuban Peso', flag: '🇨🇺'),
    Currency(code: 'CVE', name: 'Cape Verdean Escudo', flag: '🇨🇻'),
    Currency(code: 'CZK', name: 'Czech Koruna', flag: '🇨🇿'),
    Currency(code: 'DJF', name: 'Djiboutian Franc', flag: '🇩🇯'),
    Currency(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰'),
    Currency(code: 'DOP', name: 'Dominican Peso', flag: '🇩🇴'),
    Currency(code: 'DZD', name: 'Algerian Dinar', flag: '🇩🇿'),
    Currency(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬'),
    Currency(code: 'ERN', name: 'Eritrean Nakfa', flag: '🇪🇷'),
    Currency(code: 'ETB', name: 'Ethiopian Birr', flag: '🇪🇹'),
    Currency(code: 'FJD', name: 'Fijian Dollar', flag: '🇫🇯'),
    Currency(code: 'FKP', name: 'Falkland Islands Pound', flag: '🇫🇰'),
    Currency(code: 'FOK', name: 'Faroese Króna', flag: '🇫🇴'),
    Currency(code: 'GEL', name: 'Georgian Lari', flag: '🇬🇪'),
    Currency(code: 'GGP', name: 'Guernsey Pound', flag: '🇬🇬'),
    Currency(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭'),
    Currency(code: 'GIP', name: 'Gibraltar Pound', flag: '🇬🇮'),
    Currency(code: 'GMD', name: 'Gambian Dalasi', flag: '🇬🇲'),
    Currency(code: 'GNF', name: 'Guinean Franc', flag: '🇬🇳'),
    Currency(code: 'GTQ', name: 'Guatemalan Quetzal', flag: '🇬🇹'),
    Currency(code: 'GYD', name: 'Guyanese Dollar', flag: '🇬🇾'),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰'),
    Currency(code: 'HNL', name: 'Honduran Lempira', flag: '🇭🇳'),
    Currency(code: 'HRK', name: 'Croatian Kuna', flag: '🇭🇷'),
    Currency(code: 'HTG', name: 'Haitian Gourde', flag: '🇭🇹'),
    Currency(code: 'HUF', name: 'Hungarian Forint', flag: '🇭🇺'),
    Currency(code: 'IDR', name: 'Indonesian Rupiah', flag: '🇮🇩'),
    Currency(code: 'ILS', name: 'Israeli New Shekel', flag: '🇮🇱'),
    Currency(code: 'IMP', name: 'Isle of Man Pound', flag: '🇮🇲'),
    Currency(code: 'IQD', name: 'Iraqi Dinar', flag: '🇮🇶'),
    Currency(code: 'IRR', name: 'Iranian Rial', flag: '🇮🇷'),
    Currency(code: 'ISK', name: 'Icelandic Króna', flag: '🇮🇸'),
    Currency(code: 'JEP', name: 'Jersey Pound', flag: '🇯🇪'),
    Currency(code: 'JMD', name: 'Jamaican Dollar', flag: '🇯🇲'),
    Currency(code: 'JOD', name: 'Jordanian Dinar', flag: '🇯🇴'),
    Currency(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪'),
    Currency(code: 'KGS', name: 'Kyrgyzstani Som', flag: '🇰🇬'),
    Currency(code: 'KHR', name: 'Cambodian Riel', flag: '🇰🇭'),
    Currency(code: 'KID', name: 'Kiribati Dollar', flag: '🇰🇮'),
    Currency(code: 'KMF', name: 'Comorian Franc', flag: '🇰🇲'),
    Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷'),
    Currency(code: 'KWD', name: 'Kuwaiti Dinar', flag: '🇰🇼'),
    Currency(code: 'KYD', name: 'Cayman Islands Dollar', flag: '🇰🇾'),
    Currency(code: 'KZT', name: 'Kazakhstani Tenge', flag: '🇰🇿'),
    Currency(code: 'LAK', name: 'Laotian Kip', flag: '🇱🇦'),
    Currency(code: 'LBP', name: 'Lebanese Pound', flag: '🇱🇧'),
    Currency(code: 'LKR', name: 'Sri Lankan Rupee', flag: '🇱🇰'),
    Currency(code: 'LRD', name: 'Liberian Dollar', flag: '🇱🇷'),
    Currency(code: 'LSL', name: 'Lesotho Loti', flag: '🇱🇸'),
    Currency(code: 'LYD', name: 'Libyan Dinar', flag: '🇱🇾'),
    Currency(code: 'MAD', name: 'Moroccan Dirham', flag: '🇲🇦'),
    Currency(code: 'MDL', name: 'Moldovan Leu', flag: '🇲🇩'),
    Currency(code: 'MGA', name: 'Malagasy Ariary', flag: '🇲🇬'),
    Currency(code: 'MKD', name: 'Macedonian Denar', flag: '🇲🇰'),
    Currency(code: 'MMK', name: 'Myanma Kyat', flag: '🇲🇲'),
    Currency(code: 'MNT', name: 'Mongolian Tugrik', flag: '🇲🇳'),
    Currency(code: 'MOP', name: 'Macanese Pataca', flag: '🇲🇴'),
    Currency(code: 'MRU', name: 'Mauritanian Ouguiya', flag: '🇲🇷'),
    Currency(code: 'MUR', name: 'Mauritian Rupee', flag: '🇲🇺'),
    Currency(code: 'MVR', name: 'Maldivian Rufiyaa', flag: '🇲🇻'),
    Currency(code: 'MWK', name: 'Malawian Kwacha', flag: '🇲🇼'),
    Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
    Currency(code: 'MYR', name: 'Malaysian Ringgit', flag: '🇲🇾'),
    Currency(code: 'MZN', name: 'Mozambican Metical', flag: '🇲🇿'),
    Currency(code: 'NAD', name: 'Namibian Dollar', flag: '🇳🇦'),
    Currency(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬'),
    Currency(code: 'NIO', name: 'Nicaraguan Córdoba', flag: '🇳🇮'),
    Currency(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴'),
    Currency(code: 'NPR', name: 'Nepalese Rupee', flag: '🇳🇵'),
    Currency(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿'),
    Currency(code: 'OMR', name: 'Omani Rial', flag: '🇴🇲'),
    Currency(code: 'PAB', name: 'Panamanian Balboa', flag: '🇵🇦'),
    Currency(code: 'PEN', name: 'Peruvian Nuevo Sol', flag: '🇵🇪'),
    Currency(code: 'PGK', name: 'Papua New Guinean Kina', flag: '🇵🇬'),
    Currency(code: 'PHP', name: 'Philippine Peso', flag: '🇵🇭'),
    Currency(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱'),
    Currency(code: 'PYG', name: 'Paraguayan Guarani', flag: '🇵🇾'),
    Currency(code: 'QAR', name: 'Qatari Riyal', flag: '🇶🇦'),
    Currency(code: 'RON', name: 'Romanian Leu', flag: '🇷🇴'),
    Currency(code: 'RSD', name: 'Serbian Dinar', flag: '🇷🇸'),
    Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
    Currency(code: 'RWF', name: 'Rwandan Franc', flag: '🇷🇼'),
    Currency(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
    Currency(code: 'SBD', name: 'Solomon Islands Dollar', flag: '🇸🇧'),
    Currency(code: 'SCR', name: 'Seychellois Rupee', flag: '🇸🇨'),
    Currency(code: 'SDG', name: 'Sudanese Pound', flag: '🇸🇩'),
    Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪'),
    Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬'),
    Currency(code: 'SHP', name: 'Saint Helena Pound', flag: '🇸🇭'),
    Currency(code: 'SLL', name: 'Sierra Leonean Leone', flag: '🇸🇱'),
    Currency(code: 'SOS', name: 'Somali Shilling', flag: '🇸🇴'),
    Currency(code: 'SRD', name: 'Surinamese Dollar', flag: '🇸🇷'),
    Currency(code: 'SSP', name: 'South Sudanese Pound', flag: '🇸🇸'),
    Currency(code: 'STN', name: 'São Tomé and Príncipe Dobra', flag: '🇸🇹'),
    Currency(code: 'SYP', name: 'Syrian Pound', flag: '🇸🇾'),
    Currency(code: 'SZL', name: 'Eswatini Lilangeni', flag: '🇸🇿'),
    Currency(code: 'THB', name: 'Thai Baht', flag: '🇹🇭'),
    Currency(code: 'TJS', name: 'Tajikistani Somoni', flag: '🇹🇯'),
    Currency(code: 'TMT', name: 'Turkmenistani Manat', flag: '🇹🇲'),
    Currency(code: 'TND', name: 'Tunisian Dinar', flag: '🇹🇳'),
    Currency(code: 'TOP', name: 'Tongan Paʻanga', flag: '🇹🇴'),
    Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷'),
    Currency(code: 'TTD', name: 'Trinidad and Tobago Dollar', flag: '🇹🇹'),
    Currency(code: 'TWD', name: 'New Taiwan Dollar', flag: '🇹🇼'),
    Currency(code: 'TZS', name: 'Tanzanian Shilling', flag: '🇹🇿'),
    Currency(code: 'UAH', name: 'Ukrainian Hryvnia', flag: '🇺🇦'),
    Currency(code: 'UGX', name: 'Ugandan Shilling', flag: '🇺🇬'),
    Currency(code: 'UYU', name: 'Uruguayan Peso', flag: '🇺🇾'),
    Currency(code: 'UZS', name: 'Uzbekistani Som', flag: '🇺🇿'),
    Currency(code: 'VND', name: 'Vietnamese Dong', flag: '🇻🇳'),
    Currency(code: 'VUV', name: 'Vanuatu Vatu', flag: '🇻🇺'),
    Currency(code: 'WST', name: 'Samoan Tala', flag: '🇼🇸'),
    Currency(code: 'XAF', name: 'CFA Franc (BEAC)', flag: '🇨🇬'),
    Currency(code: 'XAG', name: 'Silver Ounce', flag: '🇸🇳'),
    Currency(code: 'XAU', name: 'Gold Ounce', flag: '🇸🇷'),
    Currency(code: 'XCD', name: 'East Caribbean Dollar', flag: '🇬🇩'),
    Currency(code: 'XOF', name: 'CFA Franc (West Africa)', flag: '🇸🇳'),
    Currency(code: 'XPF', name: 'CFP Franc', flag: '🇺🇸'),
    Currency(code: 'YER', name: 'Yemeni Rial', flag: '🇾🇪'),
    Currency(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦'),
    Currency(code: 'ZMW', name: 'Zambian Kwacha', flag: '🇿🇲'),
    Currency(code: 'ZWL', name: 'Zimbabwean Dollar', flag: '🇿🇼'),
  ];

  Currency? _selectedBaseCurrency;
  Map<String, double> _exchangeRates = {};
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _selectedBaseCurrency = _baseCurrencies[0];
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://v6.exchangerate-api.com/v6/49a41f202d697f68ac44d4a2/latest/${_selectedBaseCurrency?.code}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          setState(() {
            _exchangeRates = Map<String, double>.fromEntries(
              (data['conversion_rates'] as Map<String, dynamic>).entries.map(
                (entry) => MapEntry(entry.key, (entry.value as num).toDouble()),
              ),
            );
            _lastUpdated = DateTime.now();
          });
        } else {
          setState(() => _errorMessage = 'API Error: ${data['error-type']}');
        }
      } else {
        setState(() => _errorMessage = 'HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Network Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _errorMessage = null);
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _fetchExchangeRates,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Exchange Rates',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162836),
                    ),
                  ),
                  if (_lastUpdated != null)
                    Text(
                      'Updated: ${DateFormat('HH:mm').format(_lastUpdated!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _buildBaseCurrencySelector(),
              const SizedBox(height: 20),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildRatesTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBaseCurrencySelector() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: DropdownButton<Currency>(
      value: _selectedBaseCurrency,
      isExpanded: true,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF387AAE)),
      items:
          _baseCurrencies
              .map(
                (currency) => DropdownMenuItem<Currency>(
                  value: currency,
                  child: Row(
                    children: [
                      Text(currency.flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text(
                        '${currency.code}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF162836),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
      onChanged: (Currency? newValue) {
        setState(() {
          _selectedBaseCurrency = newValue;
          _fetchExchangeRates();
        });
      },
    ),
  );

  Widget _buildRatesTable() => ListView(
    children: [
      DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(
            label: Text(
              'Currency',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows:
            _displayCurrencies.map((currency) {
              final rate = _exchangeRates[currency.code] ?? 0.0;
              final isBaseCurrency =
                  currency.code == _selectedBaseCurrency?.code;

              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Text(
                          currency.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          currency.code,
                          style: TextStyle(
                            color:
                                isBaseCurrency
                                    ? const Color(0xFF387AAE)
                                    : Colors.black,
                            fontWeight:
                                isBaseCurrency
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      isBaseCurrency ? '1.0000' : rate.toStringAsFixed(4),
                      style: TextStyle(
                        color:
                            isBaseCurrency
                                ? const Color(0xFF387AAE)
                                : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    ],
  );

  String _getCurrencySymbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      case 'AUD':
        return 'A\$';
      case 'CAD':
        return 'C\$';
      case 'CHF':
        return 'CHF';
      case 'ZAR':
        return 'R';
      default:
        return '';
    }
  }
}
