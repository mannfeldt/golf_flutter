class Player {
  String key;
  String name;
  String color;
  String score;
  bool scored;
  String state;
  int distance;
  int scoreTime;
  //int strokes;

  Player(String name) {
    this.key = null;
    this.name = name;
    this.score = "0";
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
    this.scoreTime = json["scoreTime"];
    //här behöver jag skapa upp alla atribut.
    //får även skapa under objekt så som player, minigame och koppla dem till Golfgame?
  }

  Map<String, dynamic> toJson() => {
        'key': this.key,
        'name': this.name,
        'color': this.color,
        'score': this.score,
        'scored': this.scored,
        'state': this.state,
        'distance': this.distance
      };
  //här behöver jag skapa upp alla atribut.
  //får även skapa under objekt så som player, minigame och koppla dem till Golfgame?

}
