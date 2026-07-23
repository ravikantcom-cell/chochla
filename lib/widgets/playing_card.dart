import 'package:flutter/material.dart';

import '../models/card_model.dart';

class PlayingCard extends StatelessWidget {
  final CardModel card;
  final bool selected;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PlayingCard({
    super.key,
    required this.card,
    this.selected = false,
    this.onTap,
    this.width = 54,
    this.height = 78,
  });

  bool get _isRedSuit {
    return card.suit == '♥' || card.suit == '♦';
  }

  Color get _cardColor {
    return _isRedSuit ? const Color(0xFFC62828) : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        height: height,
        transform: Matrix4.translationValues(
          0,
          selected ? -10 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEF8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFC107)
                : Colors.black54,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 4,
              top: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.rank,
                    style: TextStyle(
                      color: _cardColor,
                      fontSize: width * 0.29,
                      height: 0.95,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    card.suit,
                    style: TextStyle(
                      color: _cardColor,
                      fontSize: width * 0.25,
                      height: 0.95,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                card.suit,
                style: TextStyle(
                  color: _cardColor,
                  fontSize: width * 0.52,
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 3,
              child: RotatedBox(
                quarterTurns: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.rank,
                      style: TextStyle(
                        color: _cardColor,
                        fontSize: width * 0.25,
                        height: 0.95,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      card.suit,
                      style: TextStyle(
                        color: _cardColor,
                        fontSize: width * 0.21,
                        height: 0.95,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}