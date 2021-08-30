// import 'dart:math' as math;
// import 'dart:ui' show ImageFilter;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
//
//
// class MyCupertinoAlertDialog extends StatelessWidget {
//   /// Creates an iOS-style alert dialog.
//   ///
//   /// The [actions] must not be null.
//   const MyCupertinoAlertDialog({
//     Key? key,
//     required this.title,
//     required this.content,
//     this.actions = const <Widget>[],
//     this.scrollController,
//     this.actionScrollController,
//     this.insetAnimationDuration = const Duration(milliseconds: 100),
//     this.insetAnimationCurve = Curves.decelerate,
//   })  : assert(actions != null),
//         super(key: key);
//
//   /// The (optional) title of the dialog is displayed in a large font at the top
//   /// of the dialog.
//   ///
//   /// Typically a [Text] widget.
//   final Widget title;
//
//   /// The (optional) content of the dialog is displayed in the center of the
//   /// dialog in a lighter font.
//   ///
//   /// Typically a [Text] widget.
//   final Widget content;
//
//   /// The (optional) set of actions that are displayed at the bottom of the
//   /// dialog.
//   ///
//   /// Typically this is a list of [CupertinoDialogAction] widgets.
//   final List<Widget> actions;
//
//   /// A scroll controller that can be used to control the scrolling of the
//   /// [content] in the dialog.
//   ///
//   /// Defaults to null, and is typically not needed, since most alert messages
//   /// are short.
//   ///
//   /// See also:
//   ///
//   ///  * [actionScrollController], which can be used for controlling the actions
//   ///    section when there are many actions.
//   final ScrollController? scrollController;
//
//   /// A scroll controller that can be used to control the scrolling of the
//   /// actions in the dialog.
//   ///
//   /// Defaults to null, and is typically not needed.
//   ///
//   /// See also:
//   ///
//   ///  * [scrollController], which can be used for controlling the [content]
//   ///    section when it is long.
//   final ScrollController? actionScrollController;
//
//   /// {@macro flutter.material.dialog.insetAnimationDuration}
//   final Duration insetAnimationDuration;
//
//   /// {@macro flutter.material.dialog.insetAnimationCurve}
//   final Curve insetAnimationCurve;
//
//   Widget _buildContent(BuildContext context) {
//     final List<Widget> children = <Widget>[
//       title != null || content != null
//           ? Flexible(
//         flex: 3,
//         child: _CupertinoAlertContentSection(
//           title: title,
//           content: content,
//           scrollController: scrollController,
//         ),
//       )
//           : new Container(),
//     ];
//
//     return Container(
//       color: CupertinoColors.white,
// //      color: CupertinoDynamicColor.resolve(_kDialogColor, context),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: children,
//       ),
//     );
//   }
//
//   Widget _buildActions() {
//     Widget actionSection = Container(
//       height: 0.0,
//     );
//     if (actions.isNotEmpty) {
//       actionSection = _CupertinoAlertActionSection(
//         children: actions,
//         scrollController: actionScrollController,
//       );
//     }
//
//     return actionSection;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final CupertinoLocalizations localizations =
//     CupertinoLocalizations.of(context);
//     final bool isInAccessibilityMode = _isInAccessibilityMode(context);
//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
//     return CupertinoUserInterfaceLevel(
//       data: CupertinoUserInterfaceLevelData.elevated,
//       child: MediaQuery(
//         data: MediaQuery.of(context).copyWith(
//           // iOS does not shrink dialog content below a 1.0 scale factor
//           textScaleFactor: math.max(textScaleFactor, 1.0),
//         ),
//         child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             return AnimatedPadding(
//               padding: MediaQuery.of(context).viewInsets +
//                   const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
//               duration: insetAnimationDuration,
//               curve: insetAnimationCurve,
//               child: MediaQuery.removeViewInsets(
//                 removeLeft: true,
//                 removeTop: true,
//                 removeRight: true,
//                 removeBottom: true,
//                 context: context,
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: _kEdgePadding),
//                     width: isInAccessibilityMode
//                         ? _kAccessibilityCupertinoDialogWidth
//                         : _kCupertinoDialogWidth,
//                     child: CupertinoPopupSurface(
//                       isSurfacePainted: false,
//                       child: Semantics(
//                         namesRoute: true,
//                         scopesRoute: true,
//                         explicitChildNodes: true,
//                         label: localizations.alertDialogLabel,
//                         child: _CupertinoDialogRenderWidget(
//                           contentSection: _buildContent(context),
//                           actionsSection: _buildActions(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _CupertinoAlertContentSection extends StatelessWidget {
//   const _CupertinoAlertContentSection({
//     Key? key,
//     required this.title,
//     required this.content,
//     this.scrollController,
//   }) : super(key: key);
//
//   // The (optional) title of the dialog is displayed in a large font at the top
//   // of the dialog.
//   //
//   // Typically a Text widget.
//   final Widget title;
//
//   // The (optional) content of the dialog is displayed in the center of the
//   // dialog in a lighter font.
//   //
//   // Typically a Text widget.
//   final Widget content;
//
//   // A scroll controller that can be used to control the scrolling of the
//   // content in the dialog.
//   //
//   // Defaults to null, and is typically not needed, since most alert contents
//   // are short.
//   final ScrollController? scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     if (title == null && content == null) {
//       return SingleChildScrollView(
//         controller: scrollController,
//         child: Container(width: 0.0, height: 0.0),
//       );
//     }
//
//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
//     final List<Widget> titleContentGroup = <Widget>[
//       title != null
//           ? Padding(
//         padding: EdgeInsets.only(
//           left: _kEdgePadding,
//           right: _kEdgePadding,
//           bottom: content == null ? _kEdgePadding : 1.0,
//           top: _kEdgePadding * textScaleFactor,
//         ),
//         child: DefaultTextStyle(
//           style: _kCupertinoDialogTitleStyle.copyWith(
//             color: CupertinoDynamicColor.resolve(
//                 CupertinoColors.label, context),
//           ),
//           textAlign: TextAlign.center,
//           child: title,
//         ),
//       )
//           : new Container(),
//       content != null
//           ? Padding(
//         padding: EdgeInsets.only(
//           left: _kEdgePadding,
//           right: _kEdgePadding,
//           bottom: _kEdgePadding * textScaleFactor,
//           top: title == null ? _kEdgePadding : 1.0,
//         ),
//         child: DefaultTextStyle(
//           style: _kCupertinoDialogContentStyle.copyWith(
//             color: CupertinoDynamicColor.resolve(
//                 CupertinoColors.label, context),
//           ),
//           textAlign: TextAlign.center,
//           child: content,
//         ),
//       )
//           : new Container(),
//     ];
//
//     return CupertinoScrollbar(
//       child: SingleChildScrollView(
//         controller: scrollController,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: titleContentGroup,
//         ),
//       ),
//     );
//   }
// }
//
// class _CupertinoAlertActionSection extends StatefulWidget {
//   const _CupertinoAlertActionSection({
//     Key? key,
//     required this.children,
//     this.scrollController,
//   })  : assert(children != null),
//         super(key: key);
//
//   final List<Widget> children;
//
//   // A scroll controller that can be used to control the scrolling of the
//   // actions in the dialog.
//   //
//   // Defaults to null, and is typically not needed, since most alert dialogs
//   // don't have many actions.
//   final ScrollController? scrollController;
//
//   @override
//   _CupertinoAlertActionSectionState createState() =>
//       _CupertinoAlertActionSectionState();
// }
// class _CupertinoAlertActionSectionState
//     extends State<_CupertinoAlertActionSection> {
//   @override
//   Widget build(BuildContext context) {
//     final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
//
//     final List<Widget> interactiveButtons = <Widget>[];
//     for (int i = 0; i < widget.children.length; i += 1) {
//       interactiveButtons.add(
//         _PressableActionButton(
//           child: widget.children[i],
//         ),
//       );
//     }
//
//     return CupertinoScrollbar(
//       child: SingleChildScrollView(
//         controller: widget.scrollController,
//         child: _CupertinoDialogActionsRenderWidget(
//           actionButtons: interactiveButtons,
//           dividerThickness: _kDividerThickness / devicePixelRatio,
//         ),
//       ),
//     );
//   }
// }
// class _PressableActionButton extends StatefulWidget {
//   const _PressableActionButton({
//     @required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   _PressableActionButtonState createState() => _PressableActionButtonState();
// }
//
// class _PressableActionButtonState extends State<_PressableActionButton> {
//   bool _isPressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return _ActionButtonParentDataWidget(
//       isPressed: _isPressed,
//       child: MergeSemantics(
//         // TODO(mattcarroll): Button press dynamics need overhaul for iOS: https://github.com/flutter/flutter/issues/19786
//         child: GestureDetector(
//           excludeFromSemantics: true,
//           behavior: HitTestBehavior.opaque,
//           onTapDown: (TapDownDetails details) => setState(() {
//             _isPressed = true;
//           }),
//           onTapUp: (TapUpDetails details) => setState(() {
//             _isPressed = false;
//           }),
//           // TODO(mattcarroll): Cancel is currently triggered when user moves past slop instead of off button: https://github.com/flutter/flutter/issues/19783
//           onTapCancel: () => setState(() => _isPressed = false),
//           child: widget.child,
//         ),
//       ),
//     );
//   }
// }