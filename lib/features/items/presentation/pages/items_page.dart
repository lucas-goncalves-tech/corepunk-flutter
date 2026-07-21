import 'package:flutter/material.dart';
import '../widgets/header.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CorepunkHeaderWidget(),
      body: Center(
        child: Text(
          'Aguardando próximo componente (Category Bar)...',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
