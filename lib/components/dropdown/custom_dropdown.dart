import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swcap/config/app_config.dart';

class CustomDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<DropdownMenuItem> dropdownOptions;
  final void Function(dynamic value) onChange;
  const CustomDropdown({Key key, this.selectedValue, this.dropdownOptions, this.hint, this.onChange}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10
          ),
          decoration: BoxDecoration(
            color: AppConfig.kMediumDarkColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8
              )
            ),
            style: GoogleFonts.poppins(color: Colors.white),
            dropdownColor: AppConfig.kMediumDarkColor,
            value: widget.selectedValue,
            hint: Text(widget.hint , style: GoogleFonts.poppins(color: Colors.white),),
            items: widget.dropdownOptions,
            onChanged: (value) => widget.onChange(value),
          ),
        ),
    );
  }
}
