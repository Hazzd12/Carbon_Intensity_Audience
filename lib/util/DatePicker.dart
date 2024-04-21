import 'package:carbon_intensity_audience/util/customizedUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final String label;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePicker({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _DatePicker createState() => _DatePicker();
}

class _DatePicker extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(widget.selectedDate);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Container(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomizedText(widget.label + ":",
                    font_color: Colors.black, font_size: 25),
                SizedBox(width: 5),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Change this to desired border color
                      width: 2, // Change this to desired border width
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: widget.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != widget.selectedDate) {
                        widget.onDateSelected(picked);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomizedText(formattedDate,
                            font_Weight: FontWeight.normal,
                            font_size: 16,
                            font_color: Colors.black),
                        SizedBox(
                            width: 20), // Adjust space between text and icon
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
