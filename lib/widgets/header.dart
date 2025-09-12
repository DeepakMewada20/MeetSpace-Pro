// import 'package:flutter/material.dart';

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({
//     super.key,
//     required this.title,
//     required this.leddingIcon,
//     required this.actionIcon,
//     this.subtitle,
//     this.actionsFunction,
//   });
//   final String title;
//   final String? subtitle;
//   final void Function()? actionsFunction;
//   final Widget actionIcon;
//   final IconData leddingIcon;

//   @override
//   Widget build(context) {
//     return Padding(
//       padding: EdgeInsets.all(20),
//       child: Row(
//         children: [
//           Container(
//             width: 47,
//             height: 47,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(leddingIcon, color: Colors.white, size: 20),
//           ),
//           SizedBox(width: 16),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               if (subtitle != null)
//                 Text(
//                   subtitle!,
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: actionsFunction,
//             child: Container(
//               width: 47,
//               height: 47,
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: actionIcon,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
