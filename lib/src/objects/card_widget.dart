import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/src/elements/flow_element.dart';

/// A kind of element
class CardWidget extends StatelessWidget {
  ///
  const CardWidget({
    required this.element,
    super.key,
  });

  ///
  final FlowElement element;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(element.handlerSize + 1),
        side: const BorderSide(
          color: Color(0xffDDE0E1),
          width: 2,
        ),
      ),
      elevation: 1,
      margin: EdgeInsets.zero,
      color: const Color(0xff322F35),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 12, 12, 16),
        child: Container(
          color: const Color(0xff322F35),
          width: element.size.width,
          height: element.size.height,
          child: Row(
            spacing: element.handlerSize + 1,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0x29FFFFFF),
                radius: element.handlerSize * 2 - 1,
                child: Icon(
                  Icons.arrow_right_alt,
                  color: const Color(0xffDDE0E1),
                  size: element.handlerSize + 1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Allarme ingresso',
                    style: TextStyle(
                      color: const Color(0xffDDE0E1),
                      fontFamily: 'Roboto',
                      fontSize: element.textSize - 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.12,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Ingresso 001',
                    style: TextStyle(
                      color: const Color(0xffDDE0E1),
                      fontFamily: 'Roboto',
                      fontSize: element.textSize - 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
