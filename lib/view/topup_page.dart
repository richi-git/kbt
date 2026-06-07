import 'package:flutter/material.dart';
import 'package:praktikum_1/service/currency_service.dart';
import 'package:praktikum_1/service/language_service.dart';
import 'package:praktikum_1/widget/math_background.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageService lang = LanguageService();
    final List<Map<String, dynamic>> packages = [
      {"amount": 100, "price": "Rp 10.000", "icon": Icons.monetization_on_outlined},
      {"amount": 500, "price": "Rp 45.000", "icon": Icons.monetization_on_rounded},
      {"amount": 1000, "price": "Rp 80.000", "icon": Icons.paid_rounded},
      {"amount": 5000, "price": "Rp 350.000", "icon": Icons.savings_rounded},
    ];

    return Scaffold(
      body: Stack(
        children: [
          const MathBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, lang),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildPremiumCard(context, lang),
                      const SizedBox(height: 20),
                      ...packages.map((pkg) => _buildPackageCard(context, pkg)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LanguageService lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.translate('store', 'title'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                lang.translate('store', 'subtitle'),
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, LanguageService lang) {
    return ValueListenableBuilder<bool>(
      valueListenable: CurrencyService().premiumListenable,
      builder: (context, isPremium, child) {
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue, Colors.amber],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 40),
              ),
              title: Text(
                lang.translate('store', 'premium_title'),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.translate('store', 'premium_subtitle'),
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Rp 15.000",
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: isPremium ? null : () => _showPaymentDialog(context, lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isPremium ? lang.translate('store', 'owned') : lang.translate('store', 'buy'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPaymentDialog(BuildContext context, LanguageService lang, {int? coinAmount, String? price}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment_rounded, size: 60, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                "PILIH METODE PEMBAYARAN",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                coinAmount != null ? "$coinAmount KOIN - $price" : "Premium Account - Rp 15.000",
                style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildPaymentOption(context, "E-Wallet (GOPAY/OVO)", Icons.account_balance_wallet_rounded, Colors.blue),
              _buildPaymentOption(context, "Transfer Bank", Icons.account_balance_rounded, Colors.green),
              _buildPaymentOption(context, "Credit Card", Icons.credit_card_rounded, Colors.orange),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (coinAmount != null) {
                      CurrencyService().addCoins(coinAmount);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil membeli $coinAmount koin!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      CurrencyService().setPremium(true);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Berhasil upgrade ke Premium! Nikmati fitur Bebas Iklan."),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coinAmount != null ? Colors.amber[600] : Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("KONFIRMASI PEMBAYARAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, Map<String, dynamic> pkg) {
    final LanguageService lang = LanguageService();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber[600]!, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            shape: BoxShape.circle,
          ),
          child: Icon(pkg['icon'], color: Colors.amber[800], size: 32),
        ),
        title: Text(
          "${pkg['amount']} KOIN",
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        subtitle: Text(
          pkg['price'],
          style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        trailing: ElevatedButton(
          onPressed: () => _showPaymentDialog(context, lang, coinAmount: pkg['amount'], price: pkg['price']),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("BELI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
