import 'package:flutter/material.dart';

enum ItemType { skin, border }

class StoreItem {
  final String name;
  final IconData? icon;
  final String? imagePath; // Specific for images
  final Color color;
  final int price;
  bool isOwned;
  final ItemType type;
  final String? borderType; // Specific for borders
  final String? skill; // Specific for skins
  final String? desc; // Specific for skins
  final IconData? skillIcon; // Specific for skins

  StoreItem({
    required this.name,
    this.icon,
    this.imagePath,
    required this.color,
    required this.price,
    this.isOwned = false,
    required this.type,
    this.borderType,
    this.skill,
    this.desc,
    this.skillIcon,
  });
}

class ItemService extends ChangeNotifier {
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal() {
    // Initialize with default items
    _items.addAll([
      // SKINS
      StoreItem(
        name: "BUBU",
        imagePath: "assets/chara_bubu.png",
        icon: Icons.smart_toy,
        color: Colors.blue[400]!,
        price: 0,
        isOwned: true,
        type: ItemType.skin,
        skill: "MATH HELPER",
        desc: "Memberi petunjuk jalur jika kamu bingung selama 5 detik.",
        skillIcon: Icons.lightbulb_rounded,
      ),
      StoreItem(
        name: "BOY",
        imagePath: "assets/boy_char.png",
        icon: Icons.face_rounded,
        color: Colors.orange[400]!,
        price: 1000,
        isOwned: false,
        type: ItemType.skin,
        skill: "QUICK SOLVER",
        desc: "Menambah jeda waktu berpikir AI sebanyak 1 detik.",
        skillIcon: Icons.timer_rounded,
      ),
      StoreItem(
        name: "GIRL",
        imagePath: "assets/girl_char.png",
        icon: Icons.face_3_rounded,
        color: Colors.purple[400]!,
        price: 1000,
        isOwned: false,
        type: ItemType.skin,
        skill: "POINT BOOSTER",
        desc: "Bonus +1 poin ekstra untuk setiap target HARD.",
        skillIcon: Icons.stars_rounded,
      ),
      StoreItem(
        name: "PIRATE BUBU",
        imagePath: "assets/chara_piratebubu.png",
        icon: Icons.sailing_rounded,
        color: Colors.red[700]!,
        price: 500,
        isOwned: false,
        type: ItemType.skin,
        skill: "TREASURE HUNTER",
        desc: "Mendapatkan bonus +50 koin tambahan setiap kali memenangkan level HARD.",
        skillIcon: Icons.monetization_on_rounded,
      ),
      StoreItem(
        name: "NINJA BOY",
        imagePath: "assets/chara_ninjaboy.png",
        icon: Icons.visibility_off_rounded,
        color: Colors.grey[900]!,
        price: 800,
        isOwned: false,
        type: ItemType.skin,
        skill: "SHADOW STRIKE",
        desc: "Mengurangi target angka AI sebanyak 1 poin di awal permainan.",
        skillIcon: Icons.flash_on_rounded,
      ),
      StoreItem(
        name: "PRINCESS GIRL",
        imagePath: "assets/chara_princessgirl.png",
        icon: Icons.auto_awesome_rounded,
        color: Colors.pink[300]!,
        price: 800,
        isOwned: false,
        type: ItemType.skin,
        skill: "ROYAL SHIELD",
        desc: "Memberikan 1x kesempatan salah jawab tanpa mengurangi poin per level.",
        skillIcon: Icons.shield_rounded,
      ),
      StoreItem(
        name: "CYBORG BUBU",
        imagePath: "assets/chara_cyborgbubu.png",
        icon: Icons.smart_toy_outlined,
        color: Colors.purple[400]!,
        price: 1200,
        isOwned: false,
        type: ItemType.skin,
        skill: "TECH SCAN",
        desc: "Mendeteksi jawaban yang benar lebih cepat dengan bantuan sensor.",
        skillIcon: Icons.biotech_rounded,
      ),
      StoreItem(
        name: "QUEEN GIRL",
        imagePath: "assets/chara_queengirl.png",
        icon: Icons.face_3,
        color: Colors.purple[800]!,
        price: 1500,
        isOwned: false,
        type: ItemType.skin,
        skill: "ROYAL WEALTH",
        desc: "Mendapatkan koin 2x lipat lebih banyak di setiap level.",
        skillIcon: Icons.diamond_rounded,
      ),
      StoreItem(
        name: "ASTRONAUT BUBU",
        imagePath: "assets/chara_astronautbubu.png",
        icon: Icons.rocket_launch,
        color: Colors.indigo[400]!,
        price: 2000,
        isOwned: false,
        type: ItemType.skin,
        skill: "GALAXY STRIKE",
        desc: "Kemenangan instan dengan skor 9999 pts saat kondisi kritis.",
        skillIcon: Icons.rocket_launch_rounded,
      ),

      // BORDERS
      StoreItem(
        name: "Classic Blue",
        color: Colors.blue,
        price: 0,
        isOwned: true,
        type: ItemType.border,
        borderType: "flow",
      ),
      StoreItem(
        name: "Golden Royal",
        color: Colors.amber,
        price: 300,
        isOwned: false,
        type: ItemType.border,
        borderType: "shimmer",
      ),
      StoreItem(
        name: "Toxic Matrix",
        color: Colors.greenAccent[700]!,
        price: 250,
        isOwned: false,
        type: ItemType.border,
        borderType: "scan",
      ),
      StoreItem(
        name: "Neon Pulse",
        color: Colors.pinkAccent,
        price: 400,
        isOwned: false,
        type: ItemType.border,
        borderType: "pulse",
      ),
      StoreItem(
        name: "Hellfire",
        color: Colors.orangeAccent,
        price: 450,
        isOwned: false,
        type: ItemType.border,
        borderType: "fire",
      ),
      StoreItem(
        name: "Arctic Frost",
        color: Colors.cyanAccent,
        price: 350,
        isOwned: false,
        type: ItemType.border,
        borderType: "crystal",
      ),
      StoreItem(
        name: "Void Nebula",
        color: Colors.deepPurpleAccent,
        price: 500,
        isOwned: false,
        type: ItemType.border,
        borderType: "vortex",
      ),
      StoreItem(
        name: "Silver Plate",
        color: Colors.grey[400]!,
        price: 200,
        isOwned: false,
        type: ItemType.border,
        borderType: "flow",
      ),
      StoreItem(
        name: "Thunder Flash",
        color: Colors.yellowAccent,
        price: 600,
        isOwned: false,
        type: ItemType.border,
        borderType: "lightning",
      ),
      StoreItem(
        name: "Cyber Grid",
        color: Colors.cyanAccent,
        price: 550,
        isOwned: false,
        type: ItemType.border,
        borderType: "cyber",
      ),
      StoreItem(
        name: "Rainbow Wheel",
        color: Colors.white,
        price: 700,
        isOwned: false,
        type: ItemType.border,
        borderType: "rainbow",
      ),
      StoreItem(
        name: "Phantom Ghost",
        color: Colors.blueGrey[200]!,
        price: 480,
        isOwned: false,
        type: ItemType.border,
        borderType: "phantom",
      ),
    ]);
  }

  final List<StoreItem> _items = [];

  List<StoreItem> get allItems => _items;
  List<StoreItem> get ownedItems => _items.where((item) => item.isOwned).toList();
  List<StoreItem> get skins => _items.where((item) => item.type == ItemType.skin).toList();
  List<StoreItem> get borders => _items.where((item) => item.type == ItemType.border).toList();
  List<StoreItem> get ownedSkins => _items.where((item) => item.type == ItemType.skin && item.isOwned).toList();
  List<StoreItem> get ownedBorders => _items.where((item) => item.type == ItemType.border && item.isOwned).toList();

  void purchaseItem(String name) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index != -1) {
      _items[index].isOwned = true;
      notifyListeners();
    }
  }

  bool isOwned(String name) {
    return _items.any((item) => item.name == name && item.isOwned);
  }
}
