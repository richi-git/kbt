import 'package:flutter/foundation.dart';

class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  final ValueNotifier<int> _coins = ValueNotifier<int>(1250);
  final ValueNotifier<bool> _isPremium = ValueNotifier<bool>(false);

  ValueListenable<int> get coinsListenable => _coins;
  ValueListenable<bool> get premiumListenable => _isPremium;

  int get coins => _coins.value;
  bool get isPremium => _isPremium.value;

  void addCoins(int amount) {
    _coins.value += amount;
  }

  void setPremium(bool value) {
    _isPremium.value = value;
  }

  bool spendCoins(int amount) {
    if (_coins.value >= amount) {
      _coins.value -= amount;
      return true;
    }
    return false;
  }
}
