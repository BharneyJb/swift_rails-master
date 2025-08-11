// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/utils/custom_dropdown.dart';
import 'package:swyft_rails/views/utils/input_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController scheduleController = TextEditingController();
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<String> coachList = ['1', '2', '3', '4', '5'];
  var itemList2 = ["First Class", "Business Class", "Economy Class"];

  String? _selectedCoach = '1';
  String? _selectedClass = 'First Class';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 2.0)),
                    child: IconButton.outlined(
                      color: Colors.grey.shade600,
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600),
                      color: _currentIndex == 0
                          ? Color.fromRGBO(64, 1, 168, 100)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _currentIndex = 0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(child: Text("One Way")),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                        color: _currentIndex == 1
                            ? Color.fromRGBO(64, 1, 168, 100)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0))),
                    child: InkWell(
                      onTap: () => setState(() => _currentIndex = 1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(child: Text("Round Trip")),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) =>
                      setState(() => _currentIndex = value),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Column(
                        children: [
                          InputField(
                              controller: scheduleController,
                              hintText: "From",
                              labelText: "From"),
                          SizedBox(
                            height: 15,
                          ),
                          Center(child: Image.asset("assets/icon/to.png")),
                          SizedBox(
                            height: 15,
                          ),
                          InputField(
                              controller: scheduleController,
                              hintText: "To",
                              labelText: "To"),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                    itemList: coachList,
                                    selectedItem: _selectedCoach!,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCoach = value;
                                      });
                                    },
                                    iconData: Icons.person_2_outlined),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomDropdown(
                                  itemList: itemList2,
                                  selectedItem: _selectedClass!,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedClass = value;
                                    });
                                  },
                                  iconData: Icons.notes_outlined,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                 padding: const EdgeInsets.all(18.0),
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 70),
                    backgroundColor: Color(0xff4001a8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                             ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
