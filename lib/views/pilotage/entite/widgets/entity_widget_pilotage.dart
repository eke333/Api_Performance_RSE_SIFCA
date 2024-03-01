import 'package:flutter/material.dart';

class EntityWidget extends StatefulWidget {
  final String title;
  final Color color;
  final Color hoverColor;
  const EntityWidget({super.key, required this.title, required this.color, required this.hoverColor});

  @override
  State<EntityWidget> createState() => _EntityWidgetState();
}

class _EntityWidgetState extends State<EntityWidget> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 30,
      hoverColor: Colors.transparent,
      onTap: () {},
      onHover: (value) {
        setState(() {
          _isHovering = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 25,
                  color: _isHovering ? widget.color : widget.hoverColor ),
            ),
          ],
        ),
      ),
    );
  }
}