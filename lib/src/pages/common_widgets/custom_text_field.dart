import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_customs.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String nome;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  CustomTextField({
    super.key,
    this.icon = Icons.person,
    required this.label,
    this.nome = '',
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.controller,
  });

  final isObscure = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final controllerLocal =
        controller ?? TextEditingController(text: initialValue);
    IconData icon = this.icon;

    if (label.contains('Vídeo')) {
      icon = Icons.screenshot_monitor;
    } else if (label.contains('Revisita') || label.contains('Conversa')) {
      icon = Icons.people;
    }

    return label != ''
        ? Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: ValueListenableBuilder(
                valueListenable: isObscure,
                builder: (context, value, _) {
                  return TextFormField(
                    readOnly: readOnly,
                    controller: controllerLocal,
                    // initialValue: initialValue,
                    style: const TextStyle(fontSize: 16),
                    inputFormatters: inputFormatters,
                    obscureText: isObscure.value,
                    validator: validator,
                    decoration: InputDecoration(
                      prefixIcon: Icon(icon, size: 22),
                      suffixIcon: isSecret
                          ? IconButton(
                              onPressed: (() {
                                isObscure.value = !isObscure.value;
                              }),
                              icon: Icon(isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off))
                          : null,
                      labelText: label,
                      labelStyle: (TextStyle(
                        color: CustomColors.customContrastColor,
                        fontSize: 16,
                      )),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }),
          )
        : const SizedBox();
  }
}
