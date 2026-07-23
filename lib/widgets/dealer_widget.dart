import 'package:flutter/material.dart';

class DealerWidget extends StatelessWidget {
  final double width;
  final double height;

  const DealerWidget({
    super.key,
    this.width = 145,
    this.height = 170,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD4AF37),
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Image.asset(
              'assets/dealer/dealer.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: const Color(0xFF32170E),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: width * 0.55,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -7),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xE6000000),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFD4AF37),
              ),
            ),
            child: const Text(
              'DEALER',
              style: TextStyle(
                color: Color(0xFFFFE082),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}