import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BottomDialog extends StatefulWidget {

  final Widget content;
  final bool barrierDismissible;
  final double? height;
  final Future Function()? onLoad;

  const BottomDialog({
    required this.content,
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
      required Widget content,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      elevation: 5.0,
      builder: (context) => BottomDialog(
        content: content,
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
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.height ?? MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(child: widget.content),
          ),
        ],
      ),
    );
  }
}