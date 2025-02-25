import 'package:bhawani_tech_task/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final double? width;
  final Color? color;
  final GestureTapCallback onTap;
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width * 0.8,
        alignment: Alignment.center,
        height: Get.height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? buttonColor,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
