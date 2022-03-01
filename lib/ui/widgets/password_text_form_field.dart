import 'package:flutter/material.dart';

class PasswordTextFormFiled extends StatefulWidget {
  final EdgeInsets padding;
  final int lines;
  final bool secure;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget icon;
  final String Function(String) validator;
  PasswordTextFormFiled(
      {Key key,
      this.secure = true,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
      this.controller,
      this.hint,
      this.lines = 1,
      this.keyboardType = TextInputType.text,
      this.icon,
      this.validator})
      : super(key: key);

  @override
  _PasswordTextFormFiledState createState() => _PasswordTextFormFiledState();
}

class _PasswordTextFormFiledState extends State<PasswordTextFormFiled> {
  bool _secure;
  @override
  void initState() {
    super.initState();
    _secure = widget.secure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        validator: widget.validator,
        maxLines: widget.lines,
        keyboardType: widget.keyboardType,
        obscureText: _secure,
        controller: widget.controller,
        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
        decoration: InputDecoration(
          icon: widget.icon,
          suffixIcon: IconButton(
              icon:
                  _secure ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
              onPressed: () {
                setState(() => _secure = !_secure);
              }),
          labelText: widget.hint,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
