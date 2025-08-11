// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/utils/seat_layout.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.itemList,
    required this.selectedItem,
    required this.onChanged,
    required this.iconData,
  })
  // required this.displayWidget
  : super(key: key);
  final List<String> itemList;
  final String selectedItem;
  final void Function(String?) onChanged;
  final IconData iconData;
  // final Widget Function(String) displayWidget;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
 late Map<String, Widget> _optionWidgets;
 late Widget _selectedWidget;
  @override

  void initState(){
    super.initState();
    // _optionWidgets = _generateOptionWidgets();
    _selectedWidget = SizedBox();
  }

  Map<String, Widget> _generatedOptionWidgets()
  {
    return {
      // 'Option 1' : SeatLayout(optionText: 'Option 1 Custom Widget')
    };
  }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70,
          // width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.shade300,
          ),
          child: Row(
            children: [
              Container(
                height: 70,
                // padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade500),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    widget.iconData,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                      color: Colors.grey.shade300),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: widget.selectedItem, // Current selected item
                      items: widget.itemList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget.onChanged(newValue);
                          _selectedWidget =
                          _optionWidgets[newValue!]!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _selectedWidget,
      ],
    );
  }
}
