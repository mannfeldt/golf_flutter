import 'package:flutter/material.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final gameState = Provider.of<GameState>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(30, 120, 30, 0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: 'Game ID'),
                  )),
              RaisedButton(
                onPressed: () {
                  gameState.joinGame(controller.text);
                },
                child: Text("Connect"),
              )
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: InkWell(
                      child: InkWell(
                    child: Text("Privacy Policy"),
                    onTap: () {
                      launch(
                          "https://github.com/mannfeldt/golf/blob/master/README.md");
                    },
                  )))),
        ],
      ),
    );
  }
}
