
import 'package:flutter/material.dart';

extension WidgetModifier on Widget {
  Widget paddingV([double value = 12]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  Widget paddingH([double value = 12]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget paddingAll([double value = 8]) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget sizedBox([double h = 60, double w = 60]) {
    return SizedBox(
      height: h,
      width: w,
      child: this,
    );
  }
}

