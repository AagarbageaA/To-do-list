import 'package:flutter/material.dart';

class Folder extends StatefulWidget {
  final Text title;
  final List<Widget> children;
  final double? width;
  final double? height;
  final int? animationDuration;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? innerPadding;
  final Color? leadingColor;
  final double? leadingRadius;
  final double? spaceBetweenLeadingAndTitle;

  const Folder({
    super.key,
    required this.title,
    this.children = const <Widget>[],
    this.animationDuration = 120,
    this.height = 60,
    this.width = 400,
    this.backgroundColor = const Color.fromARGB(31, 169, 25, 25),
    this.innerPadding = const EdgeInsets.fromLTRB(12, 5, 12, 5),
    this.leadingColor = const Color.fromARGB(148, 97, 165, 178),
    this.leadingRadius = 10,
    this.spaceBetweenLeadingAndTitle = 10,
  });

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> with SingleTickerProviderStateMixin {
  bool _isExpanded = false; // Detect if the current level is expanded
  late AnimationController _controller; // Animation controller

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration!),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: Card(
            color: widget.backgroundColor!,
            child: Padding(
              padding: widget.innerPadding!,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: widget.leadingRadius!,
                    backgroundColor: widget.leadingColor,
                  ),
                  SizedBox(width: widget.spaceBetweenLeadingAndTitle!),
                  Expanded(child: widget.title),
                  if (widget.children.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded; // Toggle expansion state
                          if (_isExpanded) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                        });
                      },
                      icon: Icon(_isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _controller,
          axisAlignment: -1.0, // Set the expansion direction
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16), // Indentation for child layers
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
