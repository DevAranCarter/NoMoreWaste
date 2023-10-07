import 'package:flutter/material.dart';

class FlutterTagView extends StatefulWidget {

  const FlutterTagView({Key? key,
    required this.tags,
    this.tagBackgroundColor = Colors.black12,
    this.selectedTagBackgroundColor = Colors.lightBlue,
    this.deletableTag = true,
    this.maxTagViewHeight = 150,
    this.minTagViewHeight = 0,
  }) : super(key: key);

  final List<String> tags;
  final Color tagBackgroundColor;
  final Color selectedTagBackgroundColor;
  final bool deletableTag;
  final double maxTagViewHeight;
  final double minTagViewHeight;

  @override
  State<FlutterTagView> createState() => _FlutterTagViewState();
}

class _FlutterTagViewState extends State<FlutterTagView> {

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minTagViewHeight,
          maxHeight: widget.maxTagViewHeight,
        ),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 5.0,
            direction: Axis.horizontal,
            children: buildTags(),
          ),
        )
    );
  }

  List<Widget> buildTags() {
    List<Widget> tags = <Widget>[];
    for (int i = 0; i < widget.tags.length; i++) {
      tags.add(createTag(i, widget.tags[i]));
    }
    return tags;
  }

  void deleteTag(int index) {
      setState(() {
        widget.tags.removeAt(index);
      });
  }

  Widget createTag(int index, String tagTitle) {
    return InkWell(
      onTap: () {
        deleteTag(index);
      },
      child: Chip(
        label: Text(tagTitle),
        backgroundColor: widget.tagBackgroundColor,
        avatar: InkWell(
          onTap: () {
            deleteTag(index);
          },
          // IgnorePointer is needed to make onTap work
          child: const IgnorePointer(child: Icon(Icons.close)),
        ),
      ),
    );
  }
}