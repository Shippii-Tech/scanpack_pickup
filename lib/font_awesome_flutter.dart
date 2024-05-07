import 'package:flutter/material.dart';

class ProFontAwesome extends StatelessWidget {
  final ProFontAwesomeIcon icon;
  final ProFontAwesomeWeight weight;
  final double? size;
  final Color? color;
  const ProFontAwesome({super.key, required this.icon, this.size, this.color, this.weight = ProFontAwesomeWeight.Regular});

  @override
  Widget build(BuildContext context) {
    return Text(
      icons[icon]!,
      style: TextStyle(
        fontFamily: weights[weight],
        fontSize: size,
        color: color,
      ),
    );
  }
}

const Map<ProFontAwesomeWeight, String> weights = {
  ProFontAwesomeWeight.Brand: "FontAwesomeBrand",
  ProFontAwesomeWeight.Regular: "FontAwesomeRegular",
  ProFontAwesomeWeight.Solid: "FontAwesomeSolid",
  ProFontAwesomeWeight.Light: "FontAwesomeLight",
  ProFontAwesomeWeight.Thin: "FontAwesomeThin",
  ProFontAwesomeWeight.Deotone: "FontAwesomeDuotone",
  ProFontAwesomeWeight.SharpRegular: "FontAwesomeSharpRegular",
  ProFontAwesomeWeight.SharpSolid: "FontAwesomeSharpSolid",
  ProFontAwesomeWeight.SharpLight: "FontAwesomeSharpLight",
  ProFontAwesomeWeight.SharpThin: "FontAwesomeSharpThin",
};

enum ProFontAwesomeWeight  {
  Solid,
  Regular,
  Light,
  Deotone,
  Thin,
  Brand,
  SharpRegular,
  SharpSolid,
  SharpLight,
  SharpThin
}

enum ProFontAwesomeIcon  {
  clipboardCheckmark,
  locationCheck,
  apartment,
  qrcode,
  plus,
  city,
  angleRight,
  angleLeft,
  angleDown,
  angleUp,
  bell,
  magnifyingGlass,
  xMark,
  bars,
  arrowLeftLong,
  ellipsisVertical,
  arrowDown,
  filePen,
  gear,
  check,
  camera,
  eye,
  eyeSlash,
  mapLocation,
  arrowProgress,
  arrowRight,
  hexagonExclamation,
  circleLocationArrow
}

const Map<ProFontAwesomeIcon, String> icons = {
  ProFontAwesomeIcon.clipboardCheckmark: "\uf46c",
  ProFontAwesomeIcon.locationCheck: "\uf606",
  ProFontAwesomeIcon.apartment: "\ue468",
  ProFontAwesomeIcon.qrcode: "\uf029",
  ProFontAwesomeIcon.plus: "\x2b",
  ProFontAwesomeIcon.city: "\uf64f",
  ProFontAwesomeIcon.angleRight: "\uf105",
  ProFontAwesomeIcon.angleLeft: "\uf104",
  ProFontAwesomeIcon.angleDown: "\uf107",
  ProFontAwesomeIcon.angleUp: "\uf106",
  ProFontAwesomeIcon.bell: "\uf0f3",
  ProFontAwesomeIcon.magnifyingGlass: "\uf002",
  ProFontAwesomeIcon.xMark: "\uf00d",
  ProFontAwesomeIcon.bars: "\uf0c9",
  ProFontAwesomeIcon.arrowLeftLong: "\uf177",
  ProFontAwesomeIcon.ellipsisVertical: "\uf142",
  ProFontAwesomeIcon.arrowDown: "\uf063",
  ProFontAwesomeIcon.filePen: "\uf31c",
  ProFontAwesomeIcon.gear: "\uf013",
  ProFontAwesomeIcon.check: "\uf00c",
  ProFontAwesomeIcon.camera: "\uf030",
  ProFontAwesomeIcon.eye: "\uf06e",
  ProFontAwesomeIcon.eyeSlash: "\uf070",
  ProFontAwesomeIcon.mapLocation: "\uf59f",
  ProFontAwesomeIcon.arrowProgress: "\ue5df",
  ProFontAwesomeIcon.arrowRight: "\uf061",
  ProFontAwesomeIcon.hexagonExclamation: "\ue417",
  ProFontAwesomeIcon.circleLocationArrow: "\uf602",
};

