import 'package:flutter/material.dart';

class AddCart extends ChangeNotifier {
  final List<CartProduct> _cartItems = [];
  int _itemCount = 1;
  double _totalPrice = 0;

  List<CartProduct> get cartItems => _cartItems;
  int get itemCount => _itemCount;
  double get totalPrice => _totalPrice;

  void add(CartProduct item) {
    _cartItems.add(item);
    notifyListeners();
  }

  bool itemInCart(String title) {
    return _cartItems.any((item) => item.name == title);
  }

  void incrementItemCount(double itemPrice) {
    _itemCount++;
    _totalPrice = itemPrice * _itemCount;
    notifyListeners();
  }

  void decrementItemCount(double itemPrice) {
    if (_itemCount > 1) {
      _itemCount--;
      _totalPrice = itemPrice * _itemCount;
      notifyListeners();
    }
  }

  void initializeTotalPrice(double itemPrice) {
    _totalPrice = itemPrice;
    notifyListeners();
  }

  void updateCartItem(String name, int quantity, double itemPrice) {
    for (var item in _cartItems) {
      if (item.name == name) {
        item.quantity = quantity;
        item.price = itemPrice * quantity;
        break;
      }
    }
    notifyListeners();
  }

  double calculateTotalPrice() {
    return _cartItems.fold(
        0, (total, item) => total + item.price * item.quantity);
  }

  void initializeItem(double price) {
    _itemCount = 1;  // Start with 1 item
    _totalPrice = price;
    notifyListeners();
  }
}

class CartProduct {
  String? name;
  String? imageUrl;
  double price;
  int quantity;

  CartProduct(
      {required this.name,
      required this.imageUrl,
      required this.price,
      required this.quantity});
}
