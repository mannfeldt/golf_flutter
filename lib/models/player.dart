class Player {
  String key;
  String name;
  String color;
  int score;
  bool scored;
  String state;
  int distance;
  //int strokes;

  Player(String name) {
    this.key = null;
    this.name = name;
    this.score = 0;
    this.distance = 0;
    this.state = "STILL";
    this.scored = false;
    this.color = null;
    

  }
  Player.fromJson(Map json) {
    this.key = json["key"];
    this.name = json["name"];
    this.color = json["color"];
    this.score = json["score"];
    this.scored = json["scored"];
    this.state = json["state"];
    this.distance = json["distance"];
    //här behöver jag skapa upp alla atribut.
    //får även skapa under objekt så som player, minigame och koppla dem till Golfgame?
  }
}
