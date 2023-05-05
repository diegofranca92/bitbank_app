// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Function()? onPressed;
  final btnStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.all(20));

  BlockButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          style: btnStyle,
          label: Text(label)),
    );

    // Modelo de Botao que pode ser com ou sem icone
    // Container(
    //         margin: const EdgeInsets.only(top: 24),
    //         child: ElevatedButton(
    //             onPressed: () => submitComprar(),
    //             child: const Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Icon(Icons.add_shopping_cart_outlined),
    //                 Padding(
    //                   padding: EdgeInsets.all(16),
    //                   child: Text(
    //                     'Comprar',
    //                     style: TextStyle(fontSize: 20),
    //                   ),
    //                 )
    //               ],
    //             )),
    //       )
  }
}
