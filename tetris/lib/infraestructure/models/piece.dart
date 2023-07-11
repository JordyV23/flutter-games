import 'package:tetris/infraestructure/models/values.dart';

class Piece {
  //Tipo de piezas
  Tetromino type;

  Piece({required this.type});

  //Una pieza es una lista de int;
  List<int> position = [];

  //generar int
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [4, 14, 24, 25];
        break;
      default:
    }
  }

  //mover pieza
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLenght;
        }
        break;

      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;

      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;

      default:
    }
  }
}
