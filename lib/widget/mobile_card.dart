import 'package:flutter/material.dart';

class MobileExtensionCard extends StatefulWidget {
  const MobileExtensionCard({
    super.key,
    required this.isChecked,
    required this.title,
    required this.date,
    this.note,
    this.place,
    this.folder,
    required this.onCkeckedChange,
    required this.onDelete,
  });
  //資料區
  final bool isChecked;
  final String title;
  final String date;
  final String? place;
  final String? note;
  final String? folder;

  //操作區
  final void Function(bool?) onCkeckedChange;
  final VoidCallback onDelete;

  @override
  State<MobileExtensionCard> createState() => _ExtensionCardState();
}

class _ExtensionCardState extends State<MobileExtensionCard>
    with SingleTickerProviderStateMixin {
  //動畫相關參數
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isExpanded = false;
  bool _showDetails = false;
  void Function(bool)? onExpansionChanged;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCirc,
    );
  }

  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
        if (_isExpanded) {
          _controller.forward().whenComplete(() {
            if (mounted) {
              setState(() {
                _showDetails = true;
              });
            }
          });
        } else {
          _controller.reverse().whenComplete(() {
            if (mounted) {
              setState(() {
                _showDetails = false;
              });
            }
          });
        }
        if (onExpansionChanged != null) {
          onExpansionChanged!(_isExpanded);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: GestureDetector(
            onTap: () => _setExpansion(!_isExpanded),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(62, 22, 20, 76), // 陰影顏色，30% 透明度
                        offset: Offset(2, 2), // 陰影向右偏移 5 像素，向下偏移 5 像素
                        blurRadius: 2, // 陰影的模糊半徑為 10 像素
                        spreadRadius: 2, // 陰影在容器邊緣之外擴展 3 像素
                        blurStyle: BlurStyle.inner, // 正常的模糊效果
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(180, 96, 175, 120),
                        Color.fromARGB(149, 68, 110, 168),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 55 + 70 * _animation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: widget.isChecked,
                                                onChanged:
                                                    widget.onCkeckedChange,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      2), // Spacing between checkbox and title
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  child: Text(
                                                    widget.title,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    overflow: TextOverflow
                                                        .visible, // Ensures text doesn't overflow
                                                    softWrap:
                                                        true, // Allows text to wrap
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        // Icons and Date
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              widget.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Color.fromARGB(66, 0, 0, 0),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: widget.onDelete,
                                              icon: const Icon(
                                                  Icons.delete_outline_rounded),
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     _setExpansion(!_isExpanded);
                                            //   },
                                            //   icon: Icon(
                                            //     _isExpanded
                                            //         ? Icons.arrow_drop_up
                                            //         : Icons.arrow_drop_down,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    )),
                                if (_isExpanded) ...[
                                  AnimatedOpacity(
                                    opacity: _showDetails ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Column(
                                      children: [
                                        const Divider(
                                          thickness: 1,
                                          height: 1,
                                          indent: 2,
                                          endIndent: 2,
                                          color: Color.fromARGB(
                                              115, 158, 158, 158),
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 43),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Note: ${widget.note}",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 78, 77, 77),
                                                  ),
                                                ),
                                                Text(
                                                  "Place: ${widget.place}",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 78, 77, 77),
                                                  ),
                                                ),
                                                Text(
                                                  "Folder: ${widget.folder}",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 78, 77, 77),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
