import 'package:flutter/material.dart';
import '../../../../widgets/export_widget.dart';

class CustomCadre extends StatefulWidget {
  final String imagePath;
  final String titreCadre;
  final Function()? onTap;
  const CustomCadre(
      {Key? key, required this.imagePath, required this.titreCadre, required this.onTap})
      : super(key: key);

  @override
  State<CustomCadre> createState() => _CustomCadreState();
}

class _CustomCadreState extends State<CustomCadre> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor:  Colors.transparent,
      onHover: (value) {
        setState(() {
          _hovered = value;
        });
      },
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            OutlinedCustomCadre(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF5C3F36),
                      borderRadius: BorderRadius.circular(200)),
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.asset(
                      widget.imagePath,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: widget.titreCadre,
              size: 25,
              color: _hovered ? Colors.amber : null,
              weight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}

class OutlinedCustomCadre extends StatefulWidget {
  const OutlinedCustomCadre({
    Key? key,
    required this.child,
    this.clickable = true,
  }) : super(key: key);
  final Widget child;
  final bool clickable;
  @override
  State<OutlinedCustomCadre> createState() => _OutlinedCustomCadreState();
}

class _OutlinedCustomCadreState extends State<OutlinedCustomCadre> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_hovered ? 150 : 8);
    const animationCurve = Curves.easeInOut;
    return MouseRegion(
      onEnter: (_) {
        if (!widget.clickable) return;
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        if (!widget.clickable) return;
        setState(() {
          _hovered = false;
        });
      },
      cursor: widget.clickable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        curve: animationCurve,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hovered
                ? Theme.of(context).colorScheme.outline
                : Colors.transparent,
            width: 1,
          ),
          borderRadius: borderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(
            _hovered ? 0.12 : 0,
          ),
          borderRadius: borderRadius,
        ),
        child: TweenAnimationBuilder<BorderRadius>(
          duration: kThemeAnimationDuration,
          curve: animationCurve,
          tween: Tween(begin: BorderRadius.zero, end: borderRadius),
          builder: (context, borderRadius, child) => ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
