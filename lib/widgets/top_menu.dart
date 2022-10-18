import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.menu,
          size: 24,
          color: Colors.white,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            height: 36,
            decoration: BoxDecoration(
                color: const Color(0xFFFFFBFB).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10)),
            child: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
