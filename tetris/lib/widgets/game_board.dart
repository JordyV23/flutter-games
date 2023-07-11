import 'package:flutter/material.dart';
import 'package:tetris/infraestructure/models/piece.dart';
import 'package:tetris/infraestructure/models/values.dart';
import 'package:tetris/widgets/pixel.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  //Pieza actual
  Piece currentPiece = Piece(type: Tetromino.L);


@override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame(){
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
          itemCount: rowLenght * colLenght,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowLenght),
          itemBuilder: (context, index) {

            if(currentPiece.position.contains(index)){
            return Pixel(color: Colors.yellow[900], child: index);
            }

            return Pixel(color: Colors.grey[900], child: index);
          }),
    );
  }
}
