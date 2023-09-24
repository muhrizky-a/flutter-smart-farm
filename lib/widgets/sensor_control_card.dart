import 'package:flutter/material.dart';
import '../constant.dart';

class SensorControlCard extends StatelessWidget {
  const SensorControlCard({
    super.key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.onTap,
  });

  final Color backgroundColor;
  final String title;
  final String value;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
