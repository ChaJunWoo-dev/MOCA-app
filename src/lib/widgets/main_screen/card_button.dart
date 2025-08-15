import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Widget routeWidget;

  const CardButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => routeWidget,
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Transform.scale(
                scale: 1.6,
                child: Transform.translate(
                  offset: const Offset(-5, 5),
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Icon(
                      icon,
                      color: const Color(0xFF4CAF93),
                      size: 65,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
