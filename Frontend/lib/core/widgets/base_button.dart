import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/app_color.dart';
class BaseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Widget? icon;
  final double? height;

  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? (isPrimary ? 47.976 : 50.277),
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.whiteWithOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColor.primary,
                  width: 1.15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon!,
                        const SizedBox(width: 12),
                        Text(
                          text,
                          style: const TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 16,
                            color: AppColor.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      text,
                      style: const TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: AppColor.textSecondary,
                        height: 1.5,
                      ),
                    ),
            ),
    );
  }
}