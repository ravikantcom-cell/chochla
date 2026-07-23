import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';

class GameEngine {
  final List<PlayerModel> players = [
    PlayerModel(name: 'Player 1'),
    PlayerModel(name: 'Player 2'),
    PlayerModel(name: 'Player 3'),
  ];

  int? twoSpadesHolderIndex;
  CardModel? remainingCard;

  void startGame() {
    // Previous round ka data clear karo.
    for (final player in players) {
      player.reset();
    }

    twoSpadesHolderIndex = null;
    remainingCard = null;

    final DeckModel deck = DeckModel();

    deck.createDeck();
    deck.shuffle();

    /*
     52 cards me se:
     17 × 3 = 51 cards distribute honge.
     1 card remaining rahega.
    */
    for (int round = 0; round < 17; round++) {
      for (int playerIndex = 0;
          playerIndex < players.length;
          playerIndex++) {
        if (deck.cards.isEmpty) {
          throw StateError(
            'Deck me 51 cards deal karne ke liye enough cards nahi hain.',
          );
        }

        final CardModel card = deck.cards.removeLast();
        players[playerIndex].addCard(card);
      }
    }

    // Deal ke baad exactly 1 card bachna chahiye.
    if (deck.cards.length != 1) {
      throw StateError(
        'Expected 1 remaining card, but found ${deck.cards.length}. '
        'Deck me total ${51 + deck.cards.length} cards hain.',
      );
    }

    remainingCard = deck.cards.removeLast();

    // 2♠ holder ko safely search karo.
    twoSpadesHolderIndex = players.indexWhere(
      (player) => player.cards.any(_isTwoOfSpades),
    );

    if (twoSpadesHolderIndex == -1) {
      twoSpadesHolderIndex = null;

      throw StateError(
        '2♠ holder nahi mila. CardModel aur DeckModel me '
        'rank/suit values check karo.',
      );
    }

    // Remaining 52nd card 2♠ holder ko do.
    players[twoSpadesHolderIndex!].addCard(
      remainingCard!,
    );

    // Cards ko sort karo.
    for (final player in players) {
      deck.sortPlayerCards(player.cards);
    }
  }

  bool _isTwoOfSpades(CardModel card) {
    final normalizedRank = card.rank
        .trim()
        .toUpperCase();

    final normalizedSuit = card.suit
        .trim()
        .toLowerCase();

    final isRankTwo =
        normalizedRank == '2' ||
        normalizedRank == 'TWO';

    final isSpade =
        normalizedSuit == '♠' ||
        normalizedSuit == 'spade' ||
        normalizedSuit == 'spades';

    return isRankTwo && isSpade;
  }

  bool isTwoSpadesHolder(int playerIndex) {
    return twoSpadesHolderIndex == playerIndex;
  }

  void moveCardToSet({
    required int playerIndex,
    required CardModel card,
    required int setIndex,
  }) {
    final player = players[playerIndex];

    if (setIndex < 0 || setIndex >= player.sets.length) {
      return;
    }

    if (player.sets[setIndex].length >= 3) {
      return;
    }

    final removed = player.cards.remove(card);

    if (!removed) {
      return;
    }

    player.sets[setIndex].add(card);
  }

  void removeCardFromSet({
    required int playerIndex,
    required CardModel card,
    required int setIndex,
  }) {
    final player = players[playerIndex];

    if (setIndex < 0 || setIndex >= player.sets.length) {
      return;
    }

    final removed = player.sets[setIndex].remove(card);

    if (removed) {
      player.cards.add(card);
    }
  }

  void moveCardBetweenSets({
    required int playerIndex,
    required CardModel card,
    required int fromSetIndex,
    required int toSetIndex,
  }) {
    final player = players[playerIndex];

    if (fromSetIndex < 0 ||
        fromSetIndex >= player.sets.length ||
        toSetIndex < 0 ||
        toSetIndex >= player.sets.length) {
      return;
    }

    if (player.sets[toSetIndex].length >= 3) {
      return;
    }

    final removed =
        player.sets[fromSetIndex].remove(card);

    if (removed) {
      player.sets[toSetIndex].add(card);
    }
  }

  bool completePlayerArrangement(
    int playerIndex,
  ) {
    final player = players[playerIndex];

    final allSetsComplete = player.sets.every(
      (set) => set.length == 3,
    );

    if (!allSetsComplete) {
      return false;
    }

    player.completeArrangement();
    return true;
  }
}