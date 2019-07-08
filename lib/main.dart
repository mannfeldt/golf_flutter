import 'package:flutter/material.dart';
import 'package:testgolf/connect.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';
import 'package:testgolf/golfController.dart';
import 'package:testgolf/models/golfgame.dart';
import 'package:testgolf/lobby.dart';


//import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<GameState>(
          builder: (_) => GameState("test123",null),
          child: HomePage(),
        ),
    );
  }
}

class HomePage extends StatelessWidget {
  //skapa en koppling till game.dart som state?
  //använd funktionerna i game.fetchgame/joingame till en knapp här
  //sen ska ju denna widget bara visas om golfgame är null.
  //annars ska widget lobby eller gameplay visas beroende på vad phase är.
  //denna wdiget är parent som håller state, lobby och gameplay är childs som jag kan passa state till och renderare rätt child beroende på state i parent här.
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    Golfgame golfgame = gameState.getGame();
    Widget child;
    if (golfgame == null) {
      child = Connect();
    } else if(golfgame.phase == "connection"){
      child = Lobby();
    }else if(golfgame.phase == "gameplay"){
      child = GolfController();
    }else{
      child = Text("ERROR GAME PHASE WRONG?");
    }
    //detta funkar inte. hur får jag provider i flera heirarkeier? hur kan jag använda state till att välja vilken widget som ska


    return Scaffold(
      appBar: AppBar(
        title: Text(gameState.getGameId()),
      ),
      body: child,
    );
  }
}
