import 'package:flutter/material.dart';
import '../../../constants/app_customs.dart';
import '/src/models/partes_rvmc_model.dart';

class PartesTile extends StatelessWidget {
  const PartesTile({super.key, required this.partesRvmc});

  final PartesRvmcModel partesRvmc;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey,
          ),
          child: Text(
            '${partesRvmc.data} ${partesRvmc.tesouros}',
            style: TextStyle(
              color: CustomColors.customContrastColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ));
  }
}
