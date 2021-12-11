import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textform(
    {TextEditingController? controller,
    Function? function,
    String? hint,
    Color? hintColor,
    double? hintsize,
    String? validation,
    EdgeInsetsGeometry? padding,
    int? maxlines,
    bool? issecure}) {
  return TextFormField(
    style: TextStyle(color: Colors.black, fontSize: 18.sp),
    obscureText: issecure ?? false,
    keyboardType: validation == "number"
        ? TextInputType.phone
        : validation == "name"
            ? TextInputType.name
            : validation == "email"
                ? TextInputType.emailAddress
                : TextInputType.text,
    decoration: InputDecoration(
        contentPadding: padding ?? EdgeInsets.all(w(5)),
        border: InputBorder.none,
        hintText: hint,
        isDense: true,
        hintStyle: TextStyle(
          color: hintColor ?? Colors.black,
          fontSize: hintsize ?? 12.sp,
        )),
    controller: controller,

    // expands: true,
    maxLines: maxlines ?? 1,
    minLines: null,
    onChanged: (value) {
      function!(value);
    },
  );
}

double h(double h) {
  return ScreenUtil().setHeight(h);
}

double w(double w) {
  return ScreenUtil().setWidth(w);
}
