import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final String departureLabel;
  final String departureCode;
  final String arrivalLabel;
  final String arrivalCode;
  final String trainNumber;
  final String price;
  final String iconAssetPath;
  final Color iconBackgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? codeStyle;
  final TextStyle? trainNumberStyle;
  final TextStyle? priceStyle;

  const TicketCard({
    super.key,
    this.backgroundColor = const Color(0xFFE0E0E0), // Default grey.shade200
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(18.0),
    required this.departureLabel,
    required this.departureCode,
    required this.arrivalLabel,
    required this.arrivalCode,
    required this.trainNumber,
    required this.price,
    required this.iconAssetPath,
    this.iconBackgroundColor = const Color(0xFFEEEEEE), // Default grey.shade300
    this.labelStyle,
    this.codeStyle,
    this.trainNumberStyle,
    this.priceStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureLabel,
                        style: labelStyle ??
                            TextStyle(
                              fontSize: 16.0,
                              color: Colors.purple.shade900,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        departureCode,
                        style: codeStyle ?? const TextStyle(fontSize: 30.0),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: iconBackgroundColor,
                            child: Image.asset(iconAssetPath),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            'Train No: $trainNumber',
                            style: trainNumberStyle ??
                                TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalLabel,
                        style: labelStyle ??
                            TextStyle(
                              fontSize: 16.0,
                              color: Colors.purple.shade900,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        arrivalCode,
                        style: codeStyle ?? const TextStyle(fontSize: 30.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        price,
                        style: priceStyle ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
