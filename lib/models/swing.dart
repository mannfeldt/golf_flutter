class Swing {
  int strokes;
  int x;
  int y;
  Swing(int x, int y) {
    this.x = x;
    this.y = y;
    this.strokes = 0;
  }
  Map<String, dynamic> toJson() => {
        'strokes': this.strokes,
        'x': this.x,
        'y': this.y
      };
}
