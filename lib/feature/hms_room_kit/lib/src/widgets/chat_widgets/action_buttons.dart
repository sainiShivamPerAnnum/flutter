import 'package:flutter/material.dart';

class ChatActionButtons extends StatelessWidget {
  const ChatActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
          SideButton(icon: Icon(Icons.send,size: 30,),name: 'Share',),
          SideButton(icon: Icon(Icons.heart_broken,size: 30,),name: 'Like',),
          SideButton(icon: Icon(Icons.calendar_month,size: 30,),name: 'Book a call',),
          // SideButton(icon: Icon(Icons.back_hand_rounded,size: 30,),name: 'Stage',)
      ],
    );
  }
}

class SideButton extends StatelessWidget {
  const SideButton({super.key,required this.name,required this.icon});
  final String name;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      icon,
      SizedBox(height: 4,),
      Text(name,style: TextStyle(fontSize: 16,color: Colors.white),),
      SizedBox(height: 2,),

    ],);
  }
}