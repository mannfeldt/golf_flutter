import 'package:flutter/material.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';

class Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final gameState = Provider.of<GameState>(context);
    

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: controller,
            ),
            RaisedButton(
              onPressed: () {
                print("text:" +controller.text);
                gameState.joinGame(controller.text);
              },
              child: Text("connect: " + gameState.getGameId()),
            ),
          ],
        ),
      );
  }
}