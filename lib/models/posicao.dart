// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bitbank_app/models/moeda.dart';

class Posicao {
  Moeda moeda;
  double quantidade;
  Posicao({
    required this.moeda,
    required this.quantidade,
  });
}
