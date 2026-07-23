import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game_engine/game_engine.dart';
import '../models/card_model.dart';
import '../widgets/game_table.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
  });

  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine engine = GameEngine();

  final int currentPlayerIndex = 0;

  CardModel? selectedCard;
  int? selectedSetIndex;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    engine.startGame();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  void _startNewRound() {
    setState(() {
      selectedCard = null;
      selectedSetIndex = null;

      engine.startGame();
    });
  }

  void _handleHandCardTap(
    CardModel card,
  ) {
    setState(() {
      if (identical(selectedCard, card)) {
        selectedCard = null;
      } else {
        selectedCard = card;
      }
    });
  }

  void _handleSetTap(
    int setIndex,
  ) {
    final card = selectedCard;

    if (card == null) {
      setState(() {
        selectedSetIndex = setIndex;
      });

      return;
    }

    final player =
        engine.players[currentPlayerIndex];

    if (player.sets[setIndex].length >= 3) {
      _showMessage(
        'SET ${setIndex + 1} already has 3 cards.',
      );

      return;
    }

    setState(() {
      player.cards.remove(card);
      player.sets[setIndex].add(card);

      selectedCard = null;
      selectedSetIndex = setIndex;
    });
  }

  void _handleSetCardTap(
    int setIndex,
    CardModel card,
  ) {
    final player =
        engine.players[currentPlayerIndex];

    setState(() {
      player.sets[setIndex].remove(card);
      player.cards.add(card);

      selectedCard = null;
      selectedSetIndex = setIndex;
    });
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(
            seconds: 2,
          ),
        ),
      );
  }

  Future<void> _goBack() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (
        didPop,
        result,
      ) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 42,
          backgroundColor: const Color(0xFF1B0C07),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: _goBack,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: const Text(
            'CHOCHLA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _startNewRound,
              tooltip: 'New Round',
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: GameTable(
            engine: engine,
            currentPlayerIndex:
                currentPlayerIndex,
            selectedCard: selectedCard,
            selectedSetIndex:
                selectedSetIndex,
            onHandCardTap:
                _handleHandCardTap,
            onSetTap: _handleSetTap,
            onSetCardTap:
                _handleSetCardTap,
          ),
        ),
      ),
    );
  }
}