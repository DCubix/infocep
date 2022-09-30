import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BottomDialog extends StatefulWidget {

  final String title;
  final Widget content;
  final List<Widget> Function(BuildContext context)? actionsBuilder;
  final bool barrierDismissible;
  final double? height;
  final Future Function()? onLoad;

  const BottomDialog({
    required this.title,
    required this.content,
    this.actionsBuilder,
    this.barrierDismissible = true,
    this.height,
    this.onLoad,
    super.key
  });

  @override
  State<BottomDialog> createState() => _BottomDialogState();

  static Future<T?> show<T>(
    BuildContext context,
    {
      required String title,
      required Widget content,
      List<Widget> Function(BuildContext context)? actionsBuilder,
      bool barrierDismissible = true,
      double? height,
      Future Function()? onLoad,
    }
  ) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      isDismissible: barrierDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      elevation: 5.0,
      builder: (context) => BottomDialog(
        title: title,
        content: content,
        actionsBuilder: actionsBuilder,
        barrierDismissible: barrierDismissible,
        height: height,
        onLoad: onLoad,
      ),
    );
  }
}

class _BottomDialogState extends State<BottomDialog> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await widget.onLoad?.call();
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actionsBuilder?.call(context) ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.headline5),),
              if (widget.barrierDismissible)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: widget.height ?? MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(child: widget.content),
          ),
          const SizedBox(height: 16),
          if (widget.actionsBuilder != null) Row(
            mainAxisSize: MainAxisSize.max,
            children: actions.map((e) {
              Widget w;
              if (actions.indexOf(e) < actions.length - 1) {
                w = Container(
                  margin: const EdgeInsets.only(right: 6.0,),
                  child: e,
                );
              } else {
                w = Container(child: e);
              }
              return Expanded(child: w);
            }).toList(),
          ),
        ],
      ),
    );
  }
}