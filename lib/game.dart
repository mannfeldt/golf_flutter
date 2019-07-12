import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:async/async.dart';
import 'package:testgolf/models/club.dart';
import 'package:testgolf/models/golfgame.dart';
import 'package:testgolf/models/player.dart';
import 'package:testgolf/models/swing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testgolf/util.dart';

//vad la jag till sen det börja crasha? golfcontroller, lobby, getPlayerFromGame, shared_preferences,          subscription.cancel();
//finns många vägar att testa. börja med att få till enklast glada vägen. sen alla snesteg och reconnects osv.
class GameState with ChangeNotifier {
  String _gameId;
  String _playerKey;
  Golfgame _golfgame;
  Player _player;
  int _strokes = 0;
  int _clubIndex = 0;
  Stream<Event> _gameListener;
  Stream<Event> _playerListener;
  StreamSubscription _gameSubscription;
  StreamSubscription _playerSubscription;

  GameState(this._gameId, this._golfgame);

  void setGameId(String gameId) {
    _gameId = gameId;
    notifyListeners();
  }

  getClubIndex() => _clubIndex;

  getGameId() => _gameId;

  getGame() => _golfgame;

  getPlayer() => _player;

  getStrokes() => _strokes;

  void setClubIndex(int clubindex) {
    _clubIndex = clubindex;
    notifyListeners();
  }

  //hit function here? det är om det är viktigt

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
          initGameListener(golfgame);
        } else if (golfgame.phase == 'setup') {
          print("game has not started");
        } else if (_player != null) {
          initGameListener(golfgame);
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

  void getPlayerFromGame(Golfgame golfgame, bool initgame) {
    final databaseReference = FirebaseDatabase.instance.reference();
    String playerPath = "games/" + golfgame.key + "/players/" + _playerKey;
    databaseReference.child(playerPath).once().then((DataSnapshot snapshot) {
      var player = snapshot.value;
      Map<dynamic, dynamic> playerValues = snapshot.value;
      // playerValues.forEach((key, playerValues) {
      //   print(playerValues["name"]);
      //   player = player[key];
      // });
      if (player != null) {
        _player = Player.fromJson(player);
        if (initgame) {
          initGameListener(golfgame);
        }
        _initPlayerListener(golfgame);
        notifyListeners();
      }
    });
  }

  void initGameListener(golfgame) {
    //vid reconnect får jag error för att golfgame är null??
    final databaseReference = FirebaseDatabase.instance.reference();
    _gameListener = databaseReference
        .child('games')
        .orderByChild('gameId')
        .equalTo(golfgame.id)
        .onValue;

    _gameId = golfgame.id;
    _golfgame = golfgame;
    _saveToPrefs("gameid", golfgame.id);
    if (_gameSubscription != null) {
      _gameSubscription.cancel();
    }
    _gameSubscription = _gameListener.listen((data) {
      Map<dynamic, dynamic> gameValues = data.snapshot.value;
      var game = data.snapshot.value;
      gameValues.forEach((key, gameValues) {
        game = gameValues;
      });
      if (game != null) {
        _golfgame = new Golfgame.fromJson(game);
        if (_golfgame.phase == "final_result") {
          _gameSubscription.cancel();
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

  void nextLevel() {
    _strokes = 0;
    //notifyListeners();
  }

  void createPlayer(String name) {
    final databaseReference = FirebaseDatabase.instance.reference();
    Player player = new Player(name);
    var playerRef =
        databaseReference.child('games/' + _golfgame.key + '/players').push();
    player.key = playerRef.key;
    _playerKey = player.key;
    var jsonPlayer = player.toJson();
    playerRef.set(jsonPlayer);
    _player = player;

    _saveToPrefs("playerkey", _playerKey);
    _initPlayerListener(_golfgame);
    notifyListeners();
  }

  void _saveToPrefs(String key, String value) async {
    //https://pusher.com/tutorials/local-data-flutter
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('saved $value');
  }

  void _readPlayerKeyFromPrefs(Golfgame golfgame, bool initGame) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("playerkey") ?? null;
    _playerKey = value;
    if (_playerKey != null) {
      getPlayerFromGame(golfgame, initGame);
    } else {
      print("game is in progress");
    }
    print('read: $value');
  }

  void _initPlayerListener(Golfgame golfgame) {
    final databaseReference = FirebaseDatabase.instance.reference();
    String playerPath = "games/" + golfgame.key + "/players/" + _playerKey;
    _playerListener = databaseReference.child(playerPath).onValue;
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
    }
    _playerSubscription = _playerListener.listen((data) {
      Map<dynamic, dynamic> playerValues = data.snapshot.value;
      var player = data.snapshot.value;
      // playerValues.forEach((key, playerValues) {
      //   player = playerValues;
      // });
      if (player != null) {
        _player = new Player.fromJson(player);
        if (_golfgame.phase == "final_result") {
          _playerSubscription.cancel();
          //this.cancel();
        }
      } else {
        _golfgame = null;
      }
      notifyListeners();
    });
  }

  void swing(double power) {
    if (_player.state != 'STILL') {
      print('ball is not still');
      return;
    }
    if (_golfgame.phase != 'gameplay') {
      print('game is not playing');
      return;
    }

    // if (util.isInvalidSwing(swingData)) {
    //   alert('invalid swing');
    //   return;
    // }

    // ska bara kunna används wood på första slaget? ge det lite extra power
    var club = Utility.CLUBS[_clubIndex];
    //club-klassen används inte?
    Swing swing = Utility.getSwing(club, power);
    _strokes += 1;
    swing.strokes = _strokes;
    print(swing.x.toString() + "  " + swing.y.toString());
//    window.addEventListener('devicemotion', (e) => {. behöver vi swindata?

    //  "/swing" hur skapas den "mappen?"
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference
        .child('games/' + _golfgame.key + '/players/' + _player.key + '/swing')
        .set(swing.toJson());

    notifyListeners();
  }
}
