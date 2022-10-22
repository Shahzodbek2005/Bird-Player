import 'dart:async';

import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final VoidCallback allPressed;
  final VoidCallback favPressed;
  final StreamController<int> streamController;
  const Categories({
    Key? key,
    required this.allPressed,
    required this.favPressed,
    required this.streamController,
  }) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool isAll = true;
  @override
  void initState() {
    widget.streamController.stream.listen((event) {
      if (event == 0) {
        isAll = true;
      } else {
        isAll = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () {
            widget.allPressed();
            widget.streamController.sink.add(0);
            setState(() {});
          },
          child: SizedBox(
            child: Text(
              "All Music",
              style: TextStyle(
                fontSize: 14,
                fontWeight: (isAll) ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        GestureDetector(
          onTap: () {
            widget.favPressed();
            widget.streamController.add(1);
            setState(() {});
          },
          child: SizedBox(
            child: Text(
              "Favourites",
              style: TextStyle(
                fontSize: 14,
                fontWeight: (!isAll) ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
