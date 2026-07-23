import 'card_model.dart';

class DeckModel {
  final List<CardModel> cards = [];

  DeckModel() {
    createDeck();
  }

  void createDeck() {
    cards.clear();

    const suits = ['♠', '♥', '♦', '♣'];

    const ranks = [
      {'rank': '2', 'value': 2},
      {'rank': '3', 'value': 3},
      {'rank': '4', 'value': 4},
      {'rank': '5', 'value': 5},
      {'rank': '6', 'value': 6},
      {'rank': '7', 'value': 7},
      {'rank': '8', 'value': 8},
      {'rank': '9', 'value': 9},
      {'rank': '10', 'value': 10},
      {'rank': 'J', 'value': 11},
      {'rank': 'Q', 'value': 12},
      {'rank': 'K', 'value': 13},
      {'rank': 'A', 'value': 14},
    ];

    for (final suit in suits) {
      for (final rank in ranks) {
        cards.add(
          CardModel(
            suit: suit,
            rank: rank['rank'] as String,
            value: rank['value'] as int,
          ),
        );
      }
    }
  }

  void shuffle() {
    cards.shuffle();
  }

  void sortPlayerCards(List<CardModel> playerCards) {
    const suitPriority = {
      '♠': 4,
      '♥': 3,
      '♦': 2,
      '♣': 1,
    };

    playerCards.sort((a, b) {
      if (a.suit != b.suit) {
        return suitPriority[b.suit]!
            .compareTo(suitPriority[a.suit]!);
      }

      return b.value.compareTo(a.value);
    });
  }
}