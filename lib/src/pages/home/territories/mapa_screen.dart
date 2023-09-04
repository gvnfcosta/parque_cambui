import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/territories_model.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key, required this.territories});

  final Territories territories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: territories.url,
            child: InteractiveViewer(
              child: Transform.rotate(
                alignment: FractionalOffset.center,
                angle: pi / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    territories.url,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blueGrey,
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
