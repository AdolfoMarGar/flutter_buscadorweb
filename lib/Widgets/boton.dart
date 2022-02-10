import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final Function funcion;
  final IconData icon;
  final double iconSize;

  const Boton(
      {Key? key,
      required this.funcion,
      required this.icon,
      required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () => {funcion()},
          icon: Icon(icon),
          iconSize: iconSize,
        ));
  }
}
