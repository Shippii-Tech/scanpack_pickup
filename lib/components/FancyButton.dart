import 'package:flutter/material.dart';

enum FancyButtonVariant { icon, normal }

enum FancyButtonColor { primary, secondary, tertiary }


class FancyButton extends StatefulWidget {
  final Widget child;
  final FancyButtonVariant? variant;
  final FancyButtonColor? color;
  final Function() onPressed;
  final bool loading;

  const FancyButton({
    super.key,
    required this.child,
    this.variant = FancyButtonVariant.normal,
    this.color = FancyButtonColor.primary,
    required this.onPressed,
    this.loading = false});

  @override
  State<FancyButton> createState() => _FancyButtonState();
}

class _FancyButtonState extends State<FancyButton> {

  Color getFancyButtonColor() {
    if (widget.color != null) {
      switch (widget.color) {
        case FancyButtonColor.secondary:
          return Theme.of(context).colorScheme.secondary;
        case FancyButtonColor.tertiary:
          return Theme.of(context).colorScheme.tertiary;
        case FancyButtonColor.primary:
        default:
          return Theme.of(context).colorScheme.primary;
      }
    }

    return Theme.of(context).colorScheme.primary;
  }

  Color getSecondButtonColor() {
    if (widget.color != null) {
      switch (widget.color) {
        case FancyButtonColor.secondary:
          return Theme.of(context).colorScheme.tertiary;
        case FancyButtonColor.tertiary:
          return Theme.of(context).colorScheme.primary;
        case FancyButtonColor.primary:
        default:
          return Theme.of(context).colorScheme.secondary;
      }
    }

    return Theme.of(context).colorScheme.primary;
  }

  Color getThirdButtonColor() {
    if (widget.color != null) {
      switch (widget.color) {
        case FancyButtonColor.secondary:
          return Theme.of(context).colorScheme.primary;
        case FancyButtonColor.tertiary:
          return Theme.of(context).colorScheme.secondary;
        case FancyButtonColor.primary:
        default:
          return Theme.of(context).colorScheme.tertiary;
      }
    }

    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: Container(
              height: 27.7,
              width: 28,
              decoration: BoxDecoration(
                color: getThirdButtonColor(),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ),
          Positioned(
            left: 4,
            child: Container(
              height: 27.7,
              width: 28,
              decoration: BoxDecoration(
                color: getSecondButtonColor(),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ),
          widget.variant != null && widget.variant == FancyButtonVariant.icon ?
          IconButton.filled(
              onPressed: widget.loading ? null : widget.onPressed,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              disabledColor: getFancyButtonColor(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(getFancyButtonColor()),
                minimumSize: MaterialStateProperty.all<Size>(const Size(30, 20)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
              ),
              icon: widget.loading ?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1, color: getSecondButtonColor())),
                  )
                  : widget.child) :
          TextButton(
            onPressed: widget.loading ? null : widget.onPressed,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 4, horizontal: 2)),
              minimumSize: MaterialStateProperty.all<Size>(const Size(30, 20)),
              backgroundColor: MaterialStateProperty.all<Color>(getFancyButtonColor()),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
            ),
            child: widget.loading ?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1, color: getSecondButtonColor())),
                  )
                  : widget.child
          ),
        ]
    );
  }
}

