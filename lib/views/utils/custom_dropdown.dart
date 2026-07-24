// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.itemList,
    required this.selectedItem,
    required this.onChanged,
    required this.iconData,
  }) : super(key: key);
  final List<String> itemList;
  final String selectedItem;
  final void Function(String?) onChanged;
  final IconData iconData;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: [
          Container(
            height: 70,
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
                color: Colors.grey.shade300,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  value: widget.selectedItem,
                  items: widget.itemList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
