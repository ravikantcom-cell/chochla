import 'card_model.dart';

class PlayerModel {
  final int id;

  // Player ko deal hue cards.
  // Baad me cards yahan se 5 sets me move honge.
  final List<CardModel> cards = [];

  // Har player ko 3-3 cards ke 5 sets banane hain.
  final List<List<CardModel>> sets = List.generate(
    5,
    (_) => <CardModel>[],
  );

  // Arrangement ke baad bache hue cards.
  final List<CardModel> discardedCards = [];

  bool hasTwoSpades = false;
  bool arrangementCompleted = false;

  PlayerModel({
    required this.id,
  });

  void addCard(CardModel card) {
    cards.add(card);

    if (card.suit == '♠' && card.rank == '2') {
      hasTwoSpades = true;
    }
  }

  void reset() {
    cards.clear();
    discardedCards.clear();

    for (final set in sets) {
      set.clear();
    }

    hasTwoSpades = false;
    arrangementCompleted = false;
  }

  bool addCardToSet({
    required CardModel card,
    required int setIndex,
  }) {
    if (setIndex < 0 || setIndex >= sets.length) {
      return false;
    }

    if (sets[setIndex].length >= 3) {
      return false;
    }

    if (!cards.contains(card)) {
      return false;
    }

    cards.remove(card);
    sets[setIndex].add(card);

    return true;
  }

  bool removeCardFromSet({
    required CardModel card,
    required int setIndex,
  }) {
    if (setIndex < 0 || setIndex >= sets.length) {
      return false;
    }

    if (!sets[setIndex].contains(card)) {
      return false;
    }

    sets[setIndex].remove(card);
    cards.add(card);

    return true;
  }

  bool moveCardBetweenSets({
    required CardModel card,
    required int fromSetIndex,
    required int toSetIndex,
  }) {
    if (fromSetIndex < 0 ||
        fromSetIndex >= sets.length ||
        toSetIndex < 0 ||
        toSetIndex >= sets.length) {
      return false;
    }

    if (sets[toSetIndex].length >= 3) {
      return false;
    }

    if (!sets[fromSetIndex].contains(card)) {
      return false;
    }

    sets[fromSetIndex].remove(card);
    sets[toSetIndex].add(card);

    return true;
  }

  bool get allSetsCompleted {
    return sets.every((set) => set.length == 3);
  }

  int get cardsUsedInSets {
    return sets.fold(
      0,
      (total, set) => total + set.length,
    );
  }

  int get requiredDiscardCount {
    return hasTwoSpades ? 3 : 2;
  }

  bool completeArrangement() {
    if (!allSetsCompleted) {
      return false;
    }

    if (cards.length != requiredDiscardCount) {
      return false;
    }

    discardedCards
      ..clear()
      ..addAll(cards);

    cards.clear();
    arrangementCompleted = true;

    return true;
  }

  int get totalCards {
    return cards.length +
        cardsUsedInSets +
        discardedCards.length;
  }
}