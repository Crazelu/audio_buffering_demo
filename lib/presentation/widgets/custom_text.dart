import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? width;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.style,
    this.textAlign,
    this.width,
    this.height,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.decoration,
  }) : super(key: key);

  factory CustomText.header2({
    required String text,
    double? fontSize,
    Color? color,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w700,
      fontSize: 23,
      color: color,
    );
  }
  factory CustomText.header3({
    required String text,
    double? fontSize,
    Color? color,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w700,
      fontSize: fontSize ?? 19,
      color: color,
    );
  }

  factory CustomText.body5({
    required String text,
    double? fontSize,
    Color? color,
    double? height,
    bool? softWrap,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? 12,
      color: color,
      height: height ?? 1.7,
      softWrap: softWrap,
    );
  }

  factory CustomText.body4({
    required String text,
    double? fontSize,
    Color? color,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w700,
      fontSize: fontSize ?? 15,
      color: color,
      height: 1.7,
    );
  }
  factory CustomText.body3({
    required String text,
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    double? height,
    bool? softWrap,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? 12,
      color: color,
      height: height ?? 1.7,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
    );
  }

  factory CustomText.body2({
    required String text,
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    double? height,
    bool? softWrap,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? 14,
      color: color,
      height: height ?? 1.7,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
    );
  }
  factory CustomText.body1({
    required String text,
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    double? height,
    bool? softWrap,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? 14,
      color: color,
      height: 1.7,
      decoration: decoration,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory CustomText.caption2({
    required String text,
    double? fontSize,
    Color? color,
    double? height,
    bool? softWrap,
  }) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? 12,
      color: color,
      height: height ?? 1.7,
      softWrap: softWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        overflow: overflow,
        softWrap: softWrap,
        textAlign: textAlign,
        maxLines: maxLines,
        style: style ??
            TextStyle(
              decoration: decoration,
              height: height,
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: color,
              fontFamily: fontFamily,
            ),
      ),
    );
  }
}
