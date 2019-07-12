class Golfgame {
  String id;
  String key;
  String phase;
  String status;
  String title;
  int par;
  Golfgame(String id, String key, String phase, String status, String title, int par) {
    this.id = id;
    this.key = key;
    this.phase = phase;
    this.status = status;
    this.title = title;
    this.par = par;
  }
  Golfgame.fromJson(Map json) {
    this.id = json["gameId"];
    this.key = json["key"];
    this.phase = json["phase"];
    this.status = json["status"];
    this.par = json["currentPar"];
    //this.title = json["title"];

    //här behöver jag skapa upp alla atribut.
    //får även skapa under objekt så som player, minigame och koppla dem till Golfgame?
    //måste finnas något bättre sätt för detta. kolla youtube.

    //firebase real time database in flutter.

    //vilka attribute behöver jag ens?
    // phase?
    //behöver hämta key/id så att jag kan updatera rätt game
    //playerId också.
    //kolla mer vad jag behöver för att controller ska fungera:
    //gameId, gameKey, phase, status, playerId
  }
}
