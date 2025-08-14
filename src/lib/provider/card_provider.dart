import 'package:flutter/material.dart';
import 'package:prob/model/card_model.dart';

class CardProvider with ChangeNotifier {
  List<CardModel> _cardList = [];

  List<CardModel> get cardList => _cardList;

  void setCardList(List<CardModel> list) {
    _cardList = list;
    notifyListeners();
  }

  void addCard(CardModel model) {
    _cardList.add(model);
    notifyListeners();
  }

  void delCard(CardModel model) {
    _cardList.removeWhere((card) => card.id == model.id);
    notifyListeners();
  }
}
