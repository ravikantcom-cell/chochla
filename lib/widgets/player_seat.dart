import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../models/player_model.dart';
import 'card_back.dart';
import 'playing_card.dart';

class PlayerSeat extends StatelessWidget {
  final PlayerModel player;
  final String playerName;
  final bool showCards;
  final bool isCurrentPlayer;
  final bool isTwoSpadesHolder;
  final bool compact;

  final CardModel? selectedCard;
  final void Function(CardModel card)? onCardTap;

  const PlayerSeat({
    super.key,
    required this.player,
    required this.playerName,
    required this.showCards,
    required this.isCurrentPlayer,
    required this.isTwoSpadesHolder,
    this.compact = false,
    this.selectedCard,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlayerInformation(),
        SizedBox(height: compact ? 3 : 5),
        if (showCards)
          _buildVisibleCards()
        else
          _buildHiddenCards(),
      ],
    );
  }

  Widget _buildPlayerInformation() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 13,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? const Color(0xFFD4AF37)
            : const Color(0xCC000000),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentPlayer
              ? Colors.white
              : Colors.white38,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCurrentPlayer
                ? Icons.person
                : Icons.smart_toy_outlined,
            size: compact ? 15 : 18,
            color: isCurrentPlayer
                ? Colors.black
                : Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            playerName,
            style: TextStyle(
              color: isCurrentPlayer
                  ? Colors.black
                  : Colors.white,
              fontSize: compact ? 11 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${player.totalCards} Cards',
            style: TextStyle(
              color: isCurrentPlayer
                  ? Colors.black87
                  : Colors.white70,
              fontSize: compact ? 10 : 12,
            ),
          ),
          if (isTwoSpadesHolder) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '2♠',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisibleCards() {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final cards = player.cards;

        if (cards.isEmpty) {
          return const SizedBox(
            height: 88,
            child: Center(
              child: Text(
                'All cards arranged',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        const cardWidth = 52.0;
        const cardHeight = 75.0;

        final availableWidth = constraints.maxWidth;

        double spacing;

        if (cards.length == 1) {
          spacing = 0;
        } else {
          spacing = (availableWidth - cardWidth) /
              (cards.length - 1);

          spacing = spacing.clamp(19.0, 46.0);
        }

        final calculatedWidth =
            cardWidth + ((cards.length - 1) * spacing);

        final handWidth = calculatedWidth > availableWidth
            ? availableWidth
            : calculatedWidth;

        return SizedBox(
          width: availableWidth,
          height: cardHeight + 15,
          child: Center(
            child: SizedBox(
              width: handWidth,
              height: cardHeight + 15,
              child: Stack(
                clipBehavior: Clip.none,
                children: List.generate(
                  cards.length,
                  (index) {
                    final card = cards[index];

                    return Positioned(
                      left: index * spacing,
                      bottom: 0,
                      child: PlayingCard(
                        card: card,
                        width: cardWidth,
                        height: cardHeight,
                        selected:
                            identical(selectedCard, card),
                        onTap: () {
                          onCardTap?.call(card);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHiddenCards() {
    final cardCount = player.totalCards;
    final visibleCount =
        cardCount > 8 ? 8 : cardCount;

    final width = compact ? 125.0 : 160.0;
    final spacing = compact ? 13.0 : 17.0;

    return SizedBox(
      width: width,
      height: compact ? 47 : 58,
      child: Stack(
        children: List.generate(
          visibleCount,
          (index) {
            return Positioned(
              left: index * spacing,
              child: CardBack(
                width: compact ? 27 : 32,
                height: compact ? 40 : 47,
              ),
            );
          },
        ),
      ),
    );
  }
}