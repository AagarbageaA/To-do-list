import 'package:flutter/material.dart';

class ExtensionCard extends StatefulWidget {
  const ExtensionCard({
    super.key,
    required this.isChecked,
    required this.title,
    required this.date,
    this.note,
    this.place,
    this.folder,
    required this.onCkeckedChange,
    required this.onEdit,
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<ExtensionCard> createState() => _ExtensionCardState();
}

class _ExtensionCardState extends State<ExtensionCard>
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
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(97, 101, 6, 6),
                        Color.fromARGB(146, 4, 34, 75),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 80 + 70 * _animation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          value: widget.isChecked,
                                          onChanged: widget.onCkeckedChange),
                                      const SizedBox(width: 5),
                                      Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  12, 3, 12, 3),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    39, 201, 113, 144),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Text(
                                                widget.title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              widget.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Color.fromARGB(66, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: widget.onEdit, // 修改
                                            icon: const Icon(Icons
                                                .drive_file_rename_outline_outlined),
                                          ),
                                          IconButton(
                                            onPressed: widget.onDelete, // 修改
                                            icon: const Icon(
                                                Icons.delete_outline_rounded),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _setExpansion(!_isExpanded);
                                            },
                                            icon: Icon(_isExpanded
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
