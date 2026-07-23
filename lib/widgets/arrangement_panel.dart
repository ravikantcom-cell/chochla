import 'package:flutter/material.dart';

import '../models/card_model.dart';
import 'playing_card.dart';

class ArrangementPanel extends StatelessWidget {
  final List<List<CardModel>> sets;
  final int? selectedSetIndex;
  final void Function(int setIndex) onSetTap;
  final void Function(int setIndex, CardModel card) onCardTap;

  const ArrangementPanel({
    super.key,
    required this.sets,
    required this.selectedSetIndex,
    required this.onSetTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.2,
        ),
      ),
      child: Row(
        children: List.generate(
          5,
          (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                child: _buildSet(
                  index,
                  sets[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSet(
    int setIndex,
    List<CardModel> cards,
  ) {
    final isSelected = selectedSetIndex == setIndex;

    return GestureDetector(
      onTap: () => onSetTap(setIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x5539FF88)
              : const Color(0x66000000),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD54F)
                : Colors.white30,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 3,
              ),
              decoration: const BoxDecoration(
                color: Color(0x99000000),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(9),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'SET ${setIndex + 1}  ${cards.length}/3',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: cards.isEmpty
                  ? const Center(
                      child: Text(
                        'Tap to add',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (
                        context,
                        constraints,
                      ) {
                        const cardWidth = 37.0;
                        const cardHeight = 54.0;

                        final spacing = cards.length <= 1
                            ? 0.0
                            : ((constraints.maxWidth -
                                            cardWidth) /
                                        (cards.length - 1))
                                    .clamp(16.0, 30.0);

                        return Stack(
                          clipBehavior: Clip.none,
                          children: List.generate(
                            cards.length,
                            (cardIndex) {
                              final card = cards[cardIndex];

                              return Positioned(
                                left: cardIndex * spacing,
                                top: 5,
                                child: GestureDetector(
                                  onTap: () => onCardTap(
                                    setIndex,
                                    card,
                                  ),
                                  child: PlayingCard(
                                    card: card,
                                    width: cardWidth,
                                    height: cardHeight,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}