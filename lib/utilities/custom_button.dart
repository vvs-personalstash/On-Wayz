import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key? key,
      required this.dimensions,
      required this.label,
      required this.action,
      this.image = ''})
      : super(key: key);

  final Size dimensions;
  final String label;
  final Function action;
  final String image;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  var clicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              onTap: () {
                HapticFeedback.vibrate();
                setState(() {
                  clicked = true;
                });
                widget.action();
                setState(() {
                  clicked = true;
                });
              },
              splashColor: Colors.white.withOpacity(0.5),
              enableFeedback: true,
              child: clicked == false
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.image == ''
                            ? Container()
                            : Container(
                                height: 40,
                                width: 40,
                                child: Image(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: widget.dimensions.height * 0.07,
                          child: Center(
                            child: Text(widget.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      child: Container(
                        height: 50,
                        child: CircularProgressIndicator(color: Colors.white),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      ),
                    ),
            )));
  }
}
