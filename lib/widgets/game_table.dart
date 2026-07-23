import 'package:flutter/material.dart';

import '../game_engine/game_engine.dart';
import '../models/card_model.dart';
import 'arrangement_panel.dart';
import 'card_back.dart';
import 'dealer_widget.dart';
import 'player_seat.dart';

class GameTable extends StatelessWidget {
  final GameEngine engine;
  final int currentPlayerIndex;

  final CardModel? selectedCard;
  final int? selectedSetIndex;

  final void Function(CardModel card) onHandCardTap;
  final void Function(int setIndex) onSetTap;
  final void Function(
    int setIndex,
    CardModel card,
  ) onSetCardTap;

  const GameTable({
    super.key,
    required this.engine,
    required this.currentPlayerIndex,
    required this.selectedCard,
    required this.selectedSetIndex,
    required this.onHandCardTap,
    required this.onSetTap,
    required this.onSetCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final currentPlayer =
            engine.players[currentPlayerIndex];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildBackground(),

            _buildCasinoTable(
              width: width,
              height: height,
            ),

            Positioned(
              left: width * 0.5 - 72.5,
              top: height * 0.5 - 155,
              child: const DealerWidget(
                width: 145,
                height: 170,
              ),
            ),

            Positioned(
              left: 10,
              top: height * 0.25,
              child: SizedBox(
                width: width * 0.24,
                child: PlayerSeat(
                  player: engine.players[1],
                  playerName: 'PLAYER 2',
                  showCards: false,
                  isCurrentPlayer: false,
                  isTwoSpadesHolder:
                      engine.isTwoSpadesHolder(1),
                  compact: true,
                ),
              ),
            ),

            Positioned(
              right: 10,
              top: height * 0.25,
              child: SizedBox(
                width: width * 0.24,
                child: PlayerSeat(
                  player: engine.players[2],
                  playerName: 'PLAYER 3',
                  showCards: false,
                  isCurrentPlayer: false,
                  isTwoSpadesHolder:
                      engine.isTwoSpadesHolder(2),
                  compact: true,
                ),
              ),
            ),

            Positioned(
              right: width * 0.27,
              top: height * 0.40,
              child: _buildDeck(),
            ),

            Positioned(
              left: 5,
              right: 5,
              top: height * 0.49,
              child: ArrangementPanel(
                sets: currentPlayer.sets,
                selectedSetIndex:
                    selectedSetIndex,
                onSetTap: onSetTap,
                onCardTap: onSetCardTap,
              ),
            ),

            Positioned(
              left: 6,
              right: 6,
              bottom: 0,
              child: PlayerSeat(
                player: currentPlayer,
                playerName: 'ME',
                showCards: true,
                isCurrentPlayer: true,
                isTwoSpadesHolder:
                    engine.isTwoSpadesHolder(
                  currentPlayerIndex,
                ),
                selectedCard: selectedCard,
                onCardTap: onHandCardTap,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.25,
            colors: [
              Color(0xFF60341E),
              Color(0xFF2A150D),
              Color(0xFF100705),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCasinoTable({
    required double width,
    required double height,
  }) {
    return Positioned(
      left: width * 0.035,
      right: width * 0.035,
      top: height * 0.08,
      bottom: height * 0.05,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF006A3A),
          borderRadius: BorderRadius.all(
            Radius.elliptical(
              width,
              height,
            ),
          ),
          border: Border.all(
            color: const Color(0xFF75401F),
            width: 12,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.elliptical(
                width,
                height,
              ),
            ),
            border: Border.all(
              color: Colors.white24,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeck() {
    return SizedBox(
      width: 52,
      height: 68,
      child: Stack(
        children: [
          for (int index = 0; index < 5; index++)
            Positioned(
              left: index * 2,
              top: index * 2,
              child: const CardBack(
                width: 40,
                height: 56,
              ),
            ),
        ],
      ),
    );
  }
}