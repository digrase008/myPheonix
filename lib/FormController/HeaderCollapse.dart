import 'package:flutter/material.dart';
import '../../Utility/AppColor.dart';

class HeaderCollapse extends StatefulWidget {
  final String headlineText;
  final bool showClearAllButton;
  final VoidCallback? onClearAll;
  final VoidCallback? onAdd;

  const HeaderCollapse({
    Key? key,
    required this.headlineText,
    this.showClearAllButton = true,
    this.onClearAll,
    this.onAdd,
  }) : super(key: key);

  @override
  _HeaderCollapseState createState() => _HeaderCollapseState();
}

class _HeaderCollapseState extends State<HeaderCollapse> {
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
              if (widget.onAdd != null) {
                widget.onAdd!();
                isCollapsed = !isCollapsed; // Toggle the add icon
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.headlineText,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    decoration: isCollapsed
                        ? TextDecoration.none
                        : TextDecoration.underline,
                  ),
                ),
                if (widget.showClearAllButton)
                  TextButton(
                    onPressed: widget.onClearAll,
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all(AppColors.primaryColor),
                      side: WidgetStateProperty.all(
                        const BorderSide(
                          width: 1.0,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(isCollapsed ? Icons.add : Icons.remove),
                  onPressed: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}
