import 'package:flutter/material.dart';
import 'package:praktikum_1/widget/math_background.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // Mockup Saldo Koin Pemain
  int userCoins = 1250;

  // Data Mockup untuk Skin Karakter
  final List<Map<String, dynamic>> skinItems = [
    {
      "name": "BUBU (Default)",
      "icon": Icons.smart_toy,
      "color": Colors.blue[400],
      "price": 0,
      "isOwned": true,
      "isEquipped": true
    },
    {
      "name": "PIRATE BUBU",
      "icon": Icons.smart_toy,
      "color": Colors.red[400],
      "price": 500,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "NINJA BOY",
      "icon": Icons.face_rounded,
      "color": Colors.black87,
      "price": 800,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "PRINCESS GIRL",
      "icon": Icons.face_3_rounded,
      "color": Colors.pink[300],
      "price": 800,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "CYBORG BUBU",
      "icon": Icons.smart_toy_outlined,
      "color": Colors.purple[400],
      "price": 1200,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "PIRATE BOY",
      "icon": Icons.face_retouching_natural,
      "color": Colors.orange[400],
      "price": 1000,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "QUEEN GIRL",
      "icon": Icons.face_3,
      "color": Colors.purple[800],
      "price": 1500,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "ASTRONAUT BUBU",
      "icon": Icons.rocket_launch,
      "color": Colors.indigo[400],
      "price": 2000,
      "isOwned": false,
      "isEquipped": false
    },
  ];

  // Data Mockup untuk Border/Frame Box Game
  final List<Map<String, dynamic>> borderItems = [
    {
      "name": "Classic Blue",
      "color": Colors.blue,
      "price": 0,
      "isOwned": true,
      "isEquipped": true
    },
    {
      "name": "Golden Frame",
      "color": Colors.amber,
      "price": 300,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Toxic Green",
      "color": Colors.greenAccent[700],
      "price": 250,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Neon Pink",
      "color": Colors.pinkAccent,
      "price": 400,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Magma Red",
      "color": Colors.redAccent,
      "price": 450,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Ocean Wave",
      "color": Colors.cyan,
      "price": 350,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Amethyst",
      "color": Colors.purpleAccent,
      "price": 500,
      "isOwned": false,
      "isEquipped": false
    },
    {
      "name": "Silver Plate",
      "color": Colors.grey[400],
      "price": 200,
      "isOwned": false,
      "isEquipped": false
    },
  ];

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
                      _buildHeader(),

                      // === TAB BAR KATEGORI ===
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
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
                          tabs: const [
                            Tab(text: "SKIN KARAKTER"),
                            Tab(text: "FRAME BORDER"),
                          ],
                        ),
                      ),

                      // === ISI TAB (KONTEN TOKO) ===
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildGridContent(skinItems, isSkin: true),
                            _buildGridContent(borderItems, isSkin: false),
                          ],
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
  Widget _buildHeader() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Judul Header
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "STORE",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              Text(
                "Kustomisasi permainanmu!",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // Indikator Koin
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow[200]!, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, offset: Offset(0, 3), blurRadius: 4)
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  userCoins.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET GRID UNTUK ITEM ---
  Widget _buildGridContent(List<Map<String, dynamic>> items,
      {required bool isSkin}) {
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
          return _StoreCard(item: item, isSkin: isSkin);
        },
      ),
    );
  }
}

class _StoreCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isSkin;
  const _StoreCard({required this.item, required this.isSkin});

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isSkin = widget.isSkin;

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
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isHovered ? Colors.blue : item['color'], width: 4),
          boxShadow: [
            BoxShadow(
                color: isHovered
                    ? item['color'].withValues(alpha: 0.4)
                    : Colors.black26,
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
                  color: item['color'].withValues(alpha: 0.2),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: isSkin
                    ? Icon(item['icon'], size: 80, color: item['color'])
                    : Center(
                        // Preview untuk Border
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: item['color'], width: 5),
                          ),
                          child: Center(
                              child: Text("12",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: item['color']))),
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
                    item['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 6),

                  // Harga atau Status
                  if (!item['isOwned'])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item['price'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber),
                        ),
                      ],
                    )
                  else
                    const Text(
                      "DIMILIKI",
                      style: TextStyle(
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
                        // TODO: Tambahkan logika pembelian/penggunaan di sini nanti
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item['isEquipped']
                            ? Colors.grey[400]
                            : (item['isOwned'] ? Colors.blue : Colors.green),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        item['isEquipped']
                            ? "DIPAKAI"
                            : (item['isOwned'] ? "GUNAKAN" : "BELI"),
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
