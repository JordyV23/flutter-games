//Dimension del tablero
import 'dart:ui';

int rowLenght = 10;
int colLenght = 15;

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tertrominoColors = {
  Tetromino.L:Color.fromARGB(255, 255, 0, 170),
  Tetromino.J:Color.fromARGB(255, 0, 4, 255),
  Tetromino.I:Color.fromARGB(255, 0, 255, 200),
  Tetromino.O:Color(0xFFFFA500),
  Tetromino.S:Color.fromARGB(255, 25, 160, 7),
  Tetromino.Z:Color.fromARGB(255, 255, 0, 0),
  Tetromino.T:Color.fromARGB(255, 162, 0, 255),
};