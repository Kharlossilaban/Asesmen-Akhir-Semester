import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// Rating Display Widget - shows star rating
class RatingDisplay extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;
  final Color? color;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.size = 20,
    this.showValue = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber.shade600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, size: size, color: starColor);
          } else if (index < rating) {
            return Icon(Icons.star_half, size: size, color: starColor);
          } else {
            return Icon(Icons.star_border, size: size, color: starColor);
          }
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Interactive Rating Input Widget
class RatingInput extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  const RatingInput({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: Colors.amber.shade600,
          ),
        );
      }),
    );
  }
}
