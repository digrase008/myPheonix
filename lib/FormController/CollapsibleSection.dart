import 'package:flutter/material.dart';
import 'CustomeHeader.dart';

class CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget content;

  const CollapsibleSection({
    required this.title,
    required this.content,
  });

  @override
  _CollapsibleSectionState createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title: widget.title,
          onAdd: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          isExpanded: isExpanded,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.content,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
