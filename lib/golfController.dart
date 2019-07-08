import 'package:flutter/material.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';
import 'package:testgolf/models/golfgame.dart';
import 'package:testgolf/models/player.dart';

class GolfController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final gameState = Provider.of<GameState>(context);
    //här ska vi ha två olika widgetar. en som är en ruta för att välja namn och som då skapar en player och kallar på gamestate.createPlayer()
    //en annan widget som visar lobbyn / bara en text om att man väntar i lobbyn

    //vilken av de två widgetarna som ska visas beror på om gamestate.getPlayer är null eller inte.
    //createplayer(playernamecontroller.text);
    Player player = gameState.getPlayer();
    Golfgame game = gameState.getGame();
    Widget child;
    child = Text("GAMEPLAY");

    return Center(child: child);
  }
}
