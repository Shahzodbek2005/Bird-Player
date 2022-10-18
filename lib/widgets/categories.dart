import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(width: 8,),
        Text("All Music", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), ),
        SizedBox(width: 14,),
        Text("Favourites", style: TextStyle(fontSize: 14, color: Colors.white),),

      ],
      
    );
  }
}