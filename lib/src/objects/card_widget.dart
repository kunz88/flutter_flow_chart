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
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xffDDE0E1),
          width: 2,
        ),
      ),
      elevation: 1,
      margin: EdgeInsets.zero,
      color: const Color(0xff322F35),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 16, 16, 16),
        child: Container(
          color: const Color(0xff322F35),
          width: element.size.width,
          height: element.size.height,
          child: const Row(
            spacing: 8,
            children: [
              CircleAvatar(
                backgroundColor: Color(0x29FFFFFF),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Color(0xffDDE0E1),
                  size: 16,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Allarme ingresso',
                    style: TextStyle(
                      color: Color(0xffDDE0E1),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.12,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Ingresso 001',
                    style: TextStyle(
                      color: Color(0xffDDE0E1),
                      fontFamily: 'Roboto',
                      fontSize: 12,
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
