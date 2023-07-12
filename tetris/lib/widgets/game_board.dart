import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/infraestructure/models/piece.dart';
import 'package:tetris/infraestructure/models/values.dart';
import 'package:tetris/widgets/pixel.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLenght,
  (i) => List.generate(
    rowLenght,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Pieza actual
  Piece currentPiece = Piece(type: Tetromino.T);

  //Puntuacion
  int currentScore = 0;
  //velocidad
  Duration frameRate = const Duration(milliseconds: 200);
  //estado juego
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    //Refresh del tablero
    gameLoop(frameRate);
  }

  // Ciclo del juego
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //Limpia lineas
        clearLines();

        //revisar si cae
        checkLanding();

        //revisar fin del juego
        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
        }

        //mover la pieza hacia abajo
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //mensaje game over
  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: Text("Your Score: $currentScore"),
              actions: [
                TextButton(
                    onPressed: () {
                      resetGame();

                      Navigator.pop(context);
                    },
                    child: const Text("Play Again"))
              ],
            ));
  }

  void resetGame() {
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLenght,
        (j) => null,
      ),
    );

    gameOver = false;
    currentScore = 0;

    createNewPiece();

    startGame();
  }

  //Detector de colisiones
  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLenght).floor();
      int col = currentPiece.position[i] % rowLenght;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLenght || col < 0 || col >= rowLenght) {
        return true;
      }

      // Verificar si la celda adyacente está ocupada por otra pieza
      if (row >= 0 && col >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }

    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLenght).floor();
        int col = currentPiece.position[i] % rowLenght;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    //crear tipo aleatorio

    Random rand = Random();

    Tetromino randType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];

    currentPiece = Piece(type: randType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      currentPiece.movePiece(Direction.left);
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      currentPiece.movePiece(Direction.right);
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    //recorrer cada fila de abajo hacia arriba
    for (int row = colLenght - 1; row >= 0; row--) {
      bool rowIsFull = true;

      for (int col = 0; col < rowLenght; col++) {
        //valida si una fila realmente esta llena
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      //Si hay una fila llena, la limpia y mueve las demas
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        //Limpia la primera fila
        gameBoard[0] = List.generate(row, (index) => null);

        //Aumenta puntuacion
        currentScore += 100;

        //Aumenta velocidad
        //frameRate -= const Duration(milliseconds: 400);
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLenght; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLenght * colLenght,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLenght),
                itemBuilder: (context, index) {
                  //obtiene la columna y fila de cada indice
                  int row = (index / rowLenght).floor();
                  int col = index % rowLenght;

                  //Pieza actual
                  if (currentPiece.position.contains(index)) {
                    return Pixel(color: currentPiece.color, child: index);
                  } //19:44
                  //Revisar las piezas en el fondo
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                        color: tertrominoColors[tetrominoType], child: index);
                  } else {
                    return Pixel(color: Colors.grey[900], child: index);
                  }
                }),
          ),

          //Puntaje
          Text(
            'Score: ${currentScore.toString()}',
            style: const TextStyle(color: Colors.white),
          ),

          //Controles
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new)),
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right)),
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
          )
        ],
      ),
    );
  }
}
