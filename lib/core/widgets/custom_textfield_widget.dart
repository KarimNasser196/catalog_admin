import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final Widget labelWidget;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final int maxLines;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final OutlineInputBorder? border;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelWidget,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.hintStyle,
    this.fillColor,
    this.border,
    this.suffixIconConstraints,
    this.contentPadding,
    String? errorText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelWidget,
        SizedBox(height: 6.h),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            errorStyle: TextStyle(fontSize: 10.sp),
            hintText: widget.hint,
            hintStyle:
                widget.hintStyle ??
                TextStyle(fontSize: 12.sp, color: Color(0xff5F5FF9)),
            filled: true,
            fillColor: widget.fillColor ?? const Color(0xffF1F5FF),
            border:
                widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
            enabledBorder:
                widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
            focusedBorder:
                widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
            suffixIconConstraints: widget.suffixIconConstraints,
            suffixIcon:
                widget.suffixIcon ??
                (widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null),
          ),
        ),
      ],
    );
  }
}
