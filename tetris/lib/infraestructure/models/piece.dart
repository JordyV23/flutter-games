import 'dart:ui';

import 'package:tetris/infraestructure/models/values.dart';
import 'package:tetris/widgets/game_board.dart';

class Piece {
  //Tipo de piezas
  Tetromino type;

  Piece({required this.type});

  //Una pieza es una lista de int;
  List<int> position = [];

  //Obtener color de la pieza
  Color get color {
    return tertrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  //generar int
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;

      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;

      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;

      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;

      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;

      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;

      case Tetromino.Z:
        position = [-17, -16, -6, -5];
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

  //rotar
  int rotationState = 1;
  void rotatePiece() {
    List<int> newPosition = [];

    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            rotationMove(newPosition, [1, 1, 1, 1], -rowLenght, 0, rowLenght,
                rowLenght + 1);
            break;
          case 1:
            rotationMove(newPosition, [1, 1, 1, 1], -1, 0, 1, rowLenght - 1);
            break;
          case 2:
            rotationMove(newPosition, [1, 1, 1, 1], rowLenght, 0, -rowLenght,
                -rowLenght - 1);
            break;
          case 3:
            rotationMove(newPosition, [1, 1, 1, 1], -rowLenght + 1, 0, 1, -1);
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            rotationMove(newPosition, [1, 1, 1, 1], -rowLenght, 0, rowLenght,
                rowLenght - 1);
            break;
          case 1:
            rotationMove(newPosition, [1, 1, 1, 1], -rowLenght - 1, 0, -1, 1);
            break;
          case 2:
            rotationMove(newPosition, [1, 1, 1, 1], rowLenght, 0, -rowLenght,
                -rowLenght + 1);
            break;
          case 3:
            rotationMove(newPosition, [1, 1, 1, 1], 1, 0, -1, rowLenght + 1);
            break;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            rotationMove(newPosition, [1, 1, 1, 1], -1, 0, 1, 2);
            break;
          case 1:
            rotationMove(newPosition, [1, 1, 1, 1], -rowLenght, 0, rowLenght,
                2 * rowLenght);
            break;
          case 2:
            rotationMove(newPosition, [1, 1, 1, 1], 1, 0, -1, -2);
            break;
          case 3:
            rotationMove(newPosition, [1, 1, 1, 1], rowLenght, 0, -rowLenght,
                -(2 * rowLenght));
            break;
        }
        break;

      case Tetromino.O:
        break;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            rotationMove(
                newPosition, [1, 1, 1, 1], 0, 1, rowLenght - 1, rowLenght);
            break;
          case 1:
            rotationMove(
                newPosition, [0, 0, 0, 0], -rowLenght, 0, 1, rowLenght + 1);
            break;
          case 2:
            rotationMove(
                newPosition, [1, 1, 1, 1], 0, 1, rowLenght - 1, rowLenght);
            break;
          case 3:
            rotationMove(
                newPosition, [0, 0, 0, 0], -rowLenght, 0, 1, rowLenght + 1);
            break;
        }

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
          case 2:
            rotationMove(
                newPosition, [0, 1, 2, 3], rowLenght - 2, 0, rowLenght - 1, 1);
            break;
          case 1:
          case 3:
            rotationMove(newPosition, [0, 1, 2, 3], -rowLenght + 2, 0,
                -rowLenght + 1, -1);
            break;
        }

          case Tetromino.T:
        switch (rotationState) {
          case 0:
            rotationMove(newPosition,[2,2,2,2], -rowLenght, 0, 1, rowLenght);
            break;
          case 1:
            rotationMove(newPosition,[1,1,1,1], -1, 0, 1, rowLenght);
            break;
          case 2:
            rotationMove(newPosition,[1,1,1,1], -rowLenght, -1, 0, rowLenght);
            break;
          case 3:
            rotationMove(newPosition,[2,2,2,2], -rowLenght,-1, 0, 1);
            break;
        }
        break;


      default:
    }
  }

  List<int> rotationMove(List<int> newPosition, List<int> index, int val1,
      int val2, int val3, int val4) {
    newPosition = [
      position[index[0]] + val1,
      position[index[1]] + val2,
      position[index[2]] + val3,
      position[index[3]] + val4,
    ];

    // Revisa si la posicion es valida en el movimiento
    if (piecePositionIsValid(newPosition)) {
      //actualiza la posicion
      position = newPosition;
      //actualiza el estado de la actualizacion
      rotationState = (rotationState + 1) % 4;
    }

    return newPosition;
  }

  bool positionIsValid(int position) {
    int row = (position / rowLenght).floor();
    int col = position % rowLenght;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

  //Funcion que revisa si la posicion en valida
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOcupied = false;
    bool lastColOcupied = false;

    for (int pos in piecePosition) {
      // si la posicion ya esta ocupada retorna falso
      if (!positionIsValid(pos)) {
        return false;
      }

      // obtiene la posicion de la columna
      int col = pos % rowLenght;

      //revisa si la primera columna esta ocupada
      if (col == 0) {
        firstColOcupied = true;
      }

      if (col == rowLenght - 1) {
        lastColOcupied = true;
      }
    }

    return !(firstColOcupied && lastColOcupied);
  }
}
