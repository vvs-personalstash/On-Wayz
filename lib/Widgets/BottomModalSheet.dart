import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomAddTaskk extends StatefulWidget {
  final Function(double)? voidCallback;
  double radius;
  BottomAddTaskk({required this.voidCallback, required this.radius});

  @override
  State<BottomAddTaskk> createState() => _BottomAddTaskkState();
}

class _BottomAddTaskkState extends State<BottomAddTaskk> {
  var nradius;
  @override
  void initState() {
    // TODO: implement initState
    nradius = widget.radius;
  }

  @override
  Widget build(BuildContext context) {
    String? newTaskTitle;
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Set Max Distance Between You and Others',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 209, 213),
              fontSize: 20.0,
            ),
          ),
          Slider(
              min: 50,
              max: 600,
              thumbColor: Colors.pink,
              activeColor: Color.fromARGB(255, 242, 209, 213),
              inactiveColor: Colors.blueGrey.shade400,
              value: nradius,
              onChanged: (value) {
                setState(() {
                  nradius = value;
                });
              }),
          SizedBox(
            height: 40.0,
          ),
          TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(25, 28, 77, 1),
              )),
              onPressed: () {
                widget.voidCallback!(nradius);
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                'Set Distance',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
