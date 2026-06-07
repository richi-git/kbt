import 'package:flutter/material.dart';
import 'package:praktikum_1/service/currency_service.dart';
import 'package:praktikum_1/service/item_service.dart';
import 'package:praktikum_1/view/topup_page.dart';
import 'package:praktikum_1/widget/math_background.dart';
import 'package:praktikum_1/service/language_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final LanguageService _lang = LanguageService();

  String _t(String key) => _lang.translate('store', key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 Tab: Skin & Border
      child: Scaffold(
        body: Stack(
          children: [
            const MathBackground(),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      // === HEADER & COIN ===
                      _buildHeader(context),

                      // === PREMIUM PROMO ===
                      _buildPremiumPromo(context),

                      // === TAB BAR KATEGORI ===
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(25),
                          border:
                              Border.all(color: Colors.blue[300]!, width: 2),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Colors.amber[500],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.blue[800],
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors
                              .transparent, // Hilangkan garis bawah default
                          tabs: [
                            Tab(text: _t('tab_skin')),
                            Tab(text: _t('tab_border')),
                          ],
                        ),
                      ),

                      // === ISI TAB (KONTEN TOKO) ===
                      Expanded(
                        child: ListenableBuilder(
                          listenable: ItemService(),
                          builder: (context, child) {
                            return TabBarView(
                              children: [
                                _buildGridContent(ItemService().skins,
                                    isSkin: true),
                                _buildGridContent(ItemService().borders,
                                    isSkin: false),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HEADER + INDIKATOR KOIN ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Judul Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('title'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _t('subtitle'),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // Indikator Koin
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TopUpPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.yellow[200]!, width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 4)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_rounded,
                      color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: CurrencyService().coinsListenable,
                    builder: (context, coins, child) {
                      return Text(
                        coins.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.add_circle_outline_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET GRID UNTUK ITEM ---
  Widget _buildGridContent(List<StoreItem> items, {required bool isSkin}) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 90),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _StoreCard(
            item: item,
            isSkin: isSkin,
          );
        },
      ),
    );
  }

  Widget _buildPremiumPromo(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: CurrencyService().premiumListenable,
      builder: (context, isPremium, child) {
        if (isPremium) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TopUpPage()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('premium_title'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        _t('premium_subtitle'),
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StoreCard extends StatefulWidget {
  final StoreItem item;
  final bool isSkin;
  const _StoreCard({
    required this.item,
    required this.isSkin,
  });

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isSkin = widget.isSkin;
    final LanguageService _lang = LanguageService();

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isHovered
            ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          border:
              Border.all(color: isHovered ? Colors.blue : item.color, width: 4),
          boxShadow: [
            BoxShadow(
                color: isHovered ? item.color.withOpacity(0.4) : Colors.black26,
                blurRadius: isHovered ? 15 : 8,
                offset: Offset(0, isHovered ? 8 : 4))
          ],
        ),
        child: Column(
          children: [
            // Gambar / Visual Visual
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: isSkin
                    ? (item.imagePath != null
                        ? Center(
                            child: ClipRect(
                              child: OverflowBox(
                                maxHeight: 180, // 2x zoom (90 * 2)
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  item.imagePath!,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(item.icon,
                                          size: 80, color: item.color),
                                ),
                              ),
                            ),
                          )
                        : Icon(item.icon, size: 80, color: item.color))
                    : Center(
                        // Preview untuk Border
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: item.color, width: 5),
                          ),
                          child: Center(
                              child: Text("12",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: item.color))),
                        ),
                      ),
              ),
            ),

            // Informasi Item
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 6),

                  // Harga atau Status
                  if (!item.isOwned)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item.price.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber),
                        ),
                      ],
                    )
                  else
                    Text(
                      _lang.translate('store', 'owned'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.green),
                    ),

                  const SizedBox(height: 8),

                  // Tombol Aksi
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        if (item.isOwned) {
                          // In Store, if owned, it's already in inventory.
                        } else {
                          // Logika Beli Item
                          if (CurrencyService().spendCoins(item.price)) {
                            ItemService().purchaseItem(item.name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${_lang.translate('store', 'buy_success')}${item.name}!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_lang.translate('store', 'no_money')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            item.isOwned ? Colors.grey[400] : Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        item.isOwned ? _lang.translate('store', 'owned') : _lang.translate('store', 'buy'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12),
                      ),
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
}
