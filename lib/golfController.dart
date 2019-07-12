import 'package:flutter/material.dart';
import 'package:testgolf/game.dart';
import 'package:provider/provider.dart';
import 'package:testgolf/models/golfgame.dart';
import 'package:testgolf/models/player.dart';
import 'package:sensors/sensors.dart';
import 'package:testgolf/resources/custom_golf_icons.dart';
import 'dart:math';

import 'package:testgolf/util.dart';

class GolfController extends StatefulWidget {
  GolfController({Key key}) : super(key: key);

  @override
  _GolfController createState() => _GolfController();
}

class _GolfController extends State<GolfController> {
  double _highestAcceleration = 0;
  bool _swinging = false;
  List<AccelerometerEvent> _swingPoints = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final gameState = Provider.of<GameState>(context);

    //här ska vi ha två olika widgetar. en som är en ruta för att välja namn och som då skapar en player och kallar på gamestate.createPlayer()
    //en annan widget som visar lobbyn / bara en text om att man väntar i lobbyn

    //vilken av de två widgetarna som ska visas beror på om gamestate.getPlayer är null eller inte.
    //createplayer(playernamecontroller.text);

//kanske får skapa ett localState här ändå? för de som andra widgets inte behöver veta om. power, club etc det omrä nedan här
    int strokes = gameState.getStrokes();
    int clubIndex = gameState.getClubIndex();
    //se kommentar ovan. har jag dem här så skrivs de över hela tiden? och blir konstigt inom eventlyssnaren?
    //eller får jag förväntat beteende?

    Player player = gameState.getPlayer();

    Golfgame game = gameState.getGame();
    String scoreText = "You did not score";
    if (player.state == "SCORED") {
      scoreText = Utility.getScoreName(strokes, game.par);
    }

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_swinging) {
        double x = event.x, y = event.y, z = event.z;

        setState(() {
          _swingPoints.add(event);
        });
        // this.drawSwing([{ x: Math.round(x * 2), y: Math.round(y * 2), z: Math.round(z * 2) }]);

        // hur är detta legit? både x och z kan ju vara minusvärden? jag borde lägga om dem till positiva?
        // eller kan jag använda detta för att bara mäta nersvingen?? genom att bara läsa av negative eller positiva värden
        // vilekt som nu är neråt
        // måste göra flera tester, ska y inte tas med?
        // koppla i telefonen och debuga
        double xpower = x.abs();
        double zpower = z.abs();

        double power = xpower + zpower;
        // const power2 = Math.floor(Math.abs(y) + Math.abs(z));
        // const power3 = Math.floor(Math.abs(x) + Math.abs(y));
        // && util.validateSwingMovement(event.acceleration, clubIndex)
        if (power > _highestAcceleration) {
          setState(() {
            _highestAcceleration = power;
          });
          print("power" + power.toString());
        }
      }
    });
    Map<String, dynamic> club = Utility.CLUBS[clubIndex];
    //lägg till ett nytt värde på alla klubbor som är "progressmax acceleration"?
    //eller vad är max acceleration man kan få på en swing?
    double progress = _highestAcceleration / 200;
    Color progressColor = Colors.blue;
    if (progress > 0.9) {
      progressColor = Colors.red;
    } else if (progress > 0.7) {
      progressColor = Colors.redAccent;
    } else if (progress > 0.5) {
      progressColor = Colors.amber;
    }
//kan dela upp alla delar i flera egna widgets...
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5),
                  child: LinearProgressIndicator(
                    value: progress,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(progressColor),
                  )),
              Text((_highestAcceleration / 2).toStringAsFixed(1) + " m/s"),
            ],
          )),
          game.phase == "gameplay"
              ? Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Text("Stroke " + strokes.toString())),
                    FloatingActionButton(
                      backgroundColor: Color(int.parse("0xFF" +
                          (player.color != null
                              ? player.color.substring(1)
                              : "ffffff"))),
                      onPressed: () => {},
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(player.distance.toString() + " yards")),
                  ],
                ))
              : Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Text(
                            player.scoreTime != null && player.state == "SCORED"
                                ? player.scoreTime.toString() + " sec"
                                : " ")),
                    FloatingActionButton(
                      backgroundColor: Color(int.parse("0xFF" +
                          (player.color != null
                              ? player.color.substring(1)
                              : "ffffff"))),
                      onPressed: () => {},
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(scoreText),
                    )
                  ],
                )),
          new Listener(
              onPointerDown: (PointerDownEvent event) {
                setState(() {
                  _highestAcceleration = 0.0;
                  _swingPoints = [];
                  _swinging = true;
                });
                print("down");
              },
              onPointerUp: (PointerUpEvent event) {
                setState(() {
                  _swinging = false;
                });
                if (Utility.isValidSwing(_swingPoints)) {
                  gameState.swing(_highestAcceleration);
                } else {
                  print("invalid swing");
                }
              },
              child: IconButton(
                icon: Icon(Icons.fingerprint,
                    color: player.state == "STILL" && game.phase == "gameplay"
                        ? Colors.lightBlue
                        : Colors.grey),
                iconSize: 200.0,
                splashColor: Colors.blue.shade100,
                highlightColor: Colors.transparent,
                onPressed: () {
                  print("press");
                },
              )),
          Container(
            child: Row(
              children: <Widget>[
                new DropdownButton<String>(
                  items: Utility.CLUBS.map((Map<String, Object> club) {
                    return new DropdownMenuItem<String>(
                        value: club['index'].toString(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 0, 15.0, 0),
                                child: Icon(Utility.clubIcons[club['type']])),
                            Text(club['name']),
                          ],
                        ));
                  }).toList(),
                  icon: Icon(CustomGolf.golfbag),
                  iconSize: 100.0,
                  isDense: true,
                  onChanged: (value) {
                    gameState.setClubIndex(num.parse(value));
                    print(value);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(club['name'])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
