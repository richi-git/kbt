import 'package:flutter/foundation.dart';

class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  final ValueNotifier<int> _coins = ValueNotifier<int>(1250);
  ValueListenable<int> get coinsListenable => _coins;
  int get coins => _coins.value;

  void addCoins(int amount) {
    _coins.value += amount;
  }

  bool spendCoins(int amount) {
    if (_coins.value >= amount) {
      _coins.value -= amount;
      return true;
    }
    return false;
  }
}
