import 'package:flutter/material.dart';

class ShowDilogWidget extends StatefulWidget {
  const ShowDilogWidget(this.tital, this.warningMassage, this.function, {super.key});
  final String tital;
  final String warningMassage;
  final void Function() function;
  @override
  State<StatefulWidget> createState() {
    return _ShowDilogWidgetState();
  }
}

class _ShowDilogWidgetState extends State<ShowDilogWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.warning_outlined, color: colorScheme.error),
          const SizedBox(width: 10),
          Text(
            '${widget.tital}?',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
      content: Text(
        '${widget.warningMassage}?',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        TextButton(
          onPressed: () async{
            widget.function();
            Navigator.pop(context);
          },
          child: Text(widget.tital, style: TextStyle(color: colorScheme.error)),
        ),
      ],
    );
  }
}
  // static void dialog(
  //   String tital,
  //   String message,
  //   void Function() function,
  // ) {
  //   final colorScheme = Get.theme.colorScheme;
  //   final context = Get.context;

  //   showDialog(
  //     context: context!,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: colorScheme.surface,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: Row(
  //         children: [
  //           Icon(Icons.warning_outlined, color: colorScheme.error),
  //           const SizedBox(width: 10),
  //           Text('$tital?', style: TextStyle(color: colorScheme.onSurface)),
  //         ],
  //       ),
  //       content: Text(
  //         '$message?',
  //         style: TextStyle(color: colorScheme.onSurfaceVariant),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(color: colorScheme.onSurfaceVariant),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             function;
  //           },
  //           child: Text(tital, style: TextStyle(color: colorScheme.error)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
