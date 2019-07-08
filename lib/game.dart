import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:async/async.dart';
import 'package:testgolf/models/golfgame.dart';
import 'package:testgolf/models/player.dart';
import 'package:testgolf/models/swing.dart';
import 'package:shared_preferences/shared_preferences.dart';
//vad la jag till sen det börja crasha? golfcontroller, lobby, getPlayerFromGame, shared_preferences,          subscription.cancel();
//finns många vägar att testa. börja med att få till enklast glada vägen. sen alla snesteg och reconnects osv.
class GameState with ChangeNotifier {
  String _gameId;
  String _playerKey;
  Golfgame _golfgame;
  Player _player;
  Swing _swing;
  Stream<Event> _gameListener;
  GameState(this._gameId, this._golfgame);

  void setGameId(String gameId) {
    _gameId = gameId;
    notifyListeners();
  }

  getGameId() => _gameId;

  getGame() => _golfgame;

  getPlayer() => _player;

  void joinGame(gameId) {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference
        .child('games')
        .orderByChild('gameId')
        .equalTo(gameId)
        .once()
        .then((DataSnapshot snapshot) {
      var game = snapshot.value;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values["name"]);
        game = game[key];
      });
      Golfgame golfgame = new Golfgame.fromJson(game);

      print(golfgame);
      if (game != null) {
        if (golfgame.phase == 'connection') {
          if (_player == null) {
            _readPlayerKeyFromPrefs(golfgame, false);
          }
          initGameListiner(golfgame);
        } else if (golfgame.phase == 'setup') {
          print("game has not started");
        } else if (_player != null) {
          initGameListiner(golfgame);
          //reconnect to game med player sparad
          //behöver säkerställa att det är en player som finns på gamet kanske?
        } else {
          //reconnect to game med player null, alltså omstart av appen t.ex.
          _readPlayerKeyFromPrefs(golfgame, true);
        }
        _gameId = gameId;
      } else {
        print("game not found");
      }
      notifyListeners();
    });
  }

  void getPlayerFromGame(String gameKey, bool initgame) {
    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference
        .child("games/" + gameKey + "/players/" + _playerKey)
        .once()
        .then((DataSnapshot snapshot) {
      var player = snapshot.value;
      Map<dynamic, dynamic> playerValues = snapshot.value;
      playerValues.forEach((key, playerValues) {
        print(playerValues["name"]);
        player = player[key];
      });
      if (player != null) {
        _player = Player.fromJson(snapshot.value);
        if(initgame){
          initGameListiner(_golfgame);
        }
        notifyListeners();
      }
    });
  }

  void initGameListiner(golfgame) {
    final databaseReference = FirebaseDatabase.instance.reference();
    _gameListener = databaseReference
        .child('games')
        .orderByChild('gameId')
        .equalTo(golfgame.id)
        .onValue;

    _gameId = golfgame.id;
    _golfgame = golfgame;
    _saveToPrefs("gameid", golfgame.id);
    StreamSubscription subscription;
    subscription = _gameListener.listen((data) {
      Map<dynamic, dynamic> gameValues = data.snapshot.value;
      var game;
      if (gameValues != null) {
        gameValues.forEach((key, gameValues) {
          print(gameValues["name"]);
          game = gameValues[key];
        });
        //game är lika med null? sätts inte rätt?
        _golfgame = new Golfgame.fromJson(game);
        if (_golfgame.phase == "final_result") {
          //subscription.cancel();
          //this.cancel();
        }
      } else {
        _golfgame = null;
      }
      notifyListeners();
    });
  }

  void cancel() {
    //dispose// _gameListener.cancel();
  }

  void createPlayer(String name) {
    final databaseReference = FirebaseDatabase.instance.reference();
    Player player = new Player(name);

    var playerRef =
        databaseReference.child('/games/' + _golfgame.key + '/players').push();
    player.key = playerRef.key;
    _playerKey = player.key;
    //playerkey måste sparas i minnet även vid restart av appen
    playerRef.set(player);
    _player = player;

    _saveToPrefs("playerkey", _playerKey);
    notifyListeners();
  }

  void _saveToPrefs(String key, String value) async {
    //https://pusher.com/tutorials/local-data-flutter
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(key, value);
    // print('saved $value');
  }

  void _readPlayerKeyFromPrefs(Golfgame golfgame, bool initGame) async {
    // final prefs = await SharedPreferences.getInstance();
    // final value = prefs.getString("playerkey") ?? null;
    // _playerKey = value;
    // if (_playerKey != null) {
    //   getPlayerFromGame(golfgame.key, initGame);
    // }else{
    //   print("game is in progress");
    // }
    // print('read: $value');
  }

  void swing(Swing swing) {
    _swing.x = swing.x;
    _swing.y = swing.y;
    _swing.strokes += 1;
    //swing är ett specielt objekt se util
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference
        .child('/games/' + _golfgame.key + '/players/' + _player.key + '/swing')
        .set(swing);

    notifyListeners();
  }
}
