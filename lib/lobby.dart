import 'package:flutter/material.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';
import 'package:testgolf/models/player.dart';
import 'package:testgolf/createPlayer.dart';

class Lobby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    Player player = gameState.getPlayer();
    Widget child;
    if (player != null) {
      child = Text("Väntar i lobbyn");
    } else {
      child = CreatePlayer();
    }

    return Center(child: child);
  }
}
