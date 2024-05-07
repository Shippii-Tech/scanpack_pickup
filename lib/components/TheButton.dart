import 'package:flutter/material.dart';

enum TheButtonVariant { text, elevated, outlined, tonal, flat }

enum TheButtonColor { primary, secondary, tertiary, warn, white }

enum TheButtonSize { xs, s, md, l, xl }

class TheButton extends StatefulWidget {
  final TheButtonVariant? variant;

  final String? text;
  final Widget? child;
  final TheButtonColor? color;

  final TheButtonSize? size;
  final void Function()? onPressed;
  final bool? loading;

  final double? elevation;

  const TheButton({super.key, this.variant = TheButtonVariant.flat, this.text, this.child, this.color = TheButtonColor.primary, required this.onPressed, this.size, this.loading, this.elevation})
      : assert((text != null || child != null), 'One of the parameters must be provided'),
        assert(!(variant != null && variant != TheButtonVariant.elevated && elevation != null), 'Elevation can be given only to elevated button variant');

  @override
  State<TheButton> createState() => _TheButtonState();
}

class _TheButtonState extends State<TheButton> {

  Widget component() {
    switch (widget.variant) {
      case TheButtonVariant.text:
        return widgetButtonText();
      case TheButtonVariant.outlined:
        return widgetButtonOutlined();
      case TheButtonVariant.tonal:
        return widgetButtonTonal();
      case TheButtonVariant.elevated:
        return widgetButtonElevated();
      case TheButtonVariant.flat:
      default:
        return widgetButtonFlat();
    }
  }

  Color getTheButtonColor() {
    if (widget.color != null) {
      switch (widget.color) {
        case TheButtonColor.secondary:
          return Theme.of(context).colorScheme.secondary;
        case TheButtonColor.warn:
          return Colors.redAccent;
        case TheButtonColor.tertiary:
          return Theme.of(context).colorScheme.tertiary;
        case TheButtonColor.white:
          return Colors.white;
        case TheButtonColor.primary:
        default:
          return Theme.of(context).colorScheme.primary;
      }
    }

    return Theme.of(context).colorScheme.primary;
  }

  Color getOnTheButtonColor() {
    if (widget.color != null) {
      switch (widget.color) {
        case TheButtonColor.secondary:
          return Theme.of(context).colorScheme.onSecondary;
        case TheButtonColor.tertiary:
          return Theme.of(context).colorScheme.onTertiary;
        case TheButtonColor.warn:
          return Colors.white;
        case TheButtonColor.white:
          return Colors.black;
        case TheButtonColor.primary:
        default:
          return Theme.of(context).colorScheme.onPrimary;
      }
    }

    return Theme.of(context).colorScheme.onPrimary;
  }

  EdgeInsetsGeometry getTheButtonSize() {
    if (widget.size != null) {
      switch (widget.size) {
        case TheButtonSize.xs:
          return const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6);
        case TheButtonSize.s:
          return const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8);
        case TheButtonSize.l:
          return const EdgeInsets.symmetric(horizontal: 26.0, vertical: 23);
        case TheButtonSize.xl:
          return const EdgeInsets.symmetric(horizontal: 30.0, vertical: 26);
        case TheButtonSize.md:
        default:
          return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6);
      }
    }

    return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6);
  }

  Widget getButtonLoader() {
    if (widget.size != null) {
      switch (widget.size) {
        case TheButtonSize.xs:
          return const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2));
        case TheButtonSize.s:
          return const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2));
        case TheButtonSize.l:
          return const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2));
        case TheButtonSize.xl:
          return const SizedBox(width: 31, height: 31, child: CircularProgressIndicator(strokeWidth: 2));
        case TheButtonSize.md:
        default:
          return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
      }
    }

    return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
  }

  double getButtonTextSize() {
    if (widget.size != null) {
      switch (widget.size) {
        case TheButtonSize.xs:
          return 10;
        case TheButtonSize.s:
          return 12;
        case TheButtonSize.l:
          return 18;
        case TheButtonSize.xl:
          return 22;
        case TheButtonSize.md:
        default:
          return 14;
      }
    }

    return 14;
  }

  Widget widgetButtonText() {
    return TextButton(
        onPressed: widget.loading != null && widget.loading == true ? () {} : widget.onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(getTheButtonSize()),
          overlayColor: MaterialStateProperty.all<Color>(getTheButtonColor().withOpacity(0.2)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          )),
        ),
        child: widget.loading != null && widget.loading == true
            ? getButtonLoader()
            : widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(color: widget.onPressed != null ? getTheButtonColor() : Colors.grey, fontSize: getButtonTextSize(), fontWeight: FontWeight.w600),
                  )
                : widget.child!);
  }

  Widget widgetButtonOutlined() {
    return OutlinedButton(
        onPressed: widget.loading != null && widget.loading == true ? () {} : widget.onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(getTheButtonSize()),
          backgroundColor: null,
          overlayColor: null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(4)))),
          side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: getTheButtonColor())
          )
        ),
        child: widget.loading != null && widget.loading == true
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
            : widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(color: widget.onPressed != null ? getTheButtonColor() : Colors.grey, fontSize: getButtonTextSize(), fontWeight: FontWeight.w600),
                  )
                : widget.child!);
  }

  Widget widgetButtonElevated() {
    return ElevatedButton(
        onPressed: widget.loading != null && widget.loading == true ? () {} : widget.onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(widget.elevation ?? 1),
          minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(getTheButtonSize()),
          backgroundColor: MaterialStateProperty.all<Color>(widget.onPressed != null ? getTheButtonColor() : Colors.grey),
          overlayColor: MaterialStateProperty.all<Color>(getOnTheButtonColor().withOpacity(0.2)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          )),
        ),
        child: widget.loading != null && widget.loading == true
            ? getButtonLoader()
            : widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(color: widget.onPressed != null ? getOnTheButtonColor() : Colors.grey, fontSize: getButtonTextSize(), fontWeight: FontWeight.w600),
                  )
                : widget.child!);
  }

  Widget widgetButtonFlat() {
    return ElevatedButton(
        onPressed: widget.loading != null && widget.loading == true ? () {} : widget.onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(getTheButtonSize()),
          backgroundColor: MaterialStateProperty.all<Color>(widget.onPressed != null ? getTheButtonColor() : Colors.grey),
          overlayColor: MaterialStateProperty.all<Color>(getOnTheButtonColor().withOpacity(0.2)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          )),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: widget.loading != null && widget.loading == true
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
            : widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(color: widget.onPressed != null ? getOnTheButtonColor() : Colors.black, fontSize: getButtonTextSize(), fontWeight: FontWeight.w600),
                  )
                : widget.child!);
  }

  Widget widgetButtonTonal() {
    return ElevatedButton(
        onPressed: widget.loading != null && widget.loading == true ? () {} : widget.onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(getTheButtonSize()),
          backgroundColor: MaterialStateProperty.all<Color>((widget.onPressed != null ? getTheButtonColor() : Colors.grey).withOpacity(0.1)),
          overlayColor: MaterialStateProperty.all<Color>(getTheButtonColor().withOpacity(0.4)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          )),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: widget.loading != null && widget.loading == true
            ? getButtonLoader()
            : widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(color: widget.onPressed != null ? getTheButtonColor() : Colors.grey, fontSize: getButtonTextSize(), fontWeight: FontWeight.w600),
                  )
                : widget.child!);
  }

  @override
  Widget build(BuildContext context) {
    return component();
  }
}
