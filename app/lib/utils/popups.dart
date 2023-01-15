import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:typewriter/widgets/filled_button.dart";

class ConfirmationDialogue extends HookWidget {
  const ConfirmationDialogue({
    required this.onConfirm,
    this.title = "Are you sure?",
    this.content = "This action cannot be undone.",
    this.confirmText = "Confirm",
    this.confirmIcon = Icons.check,
    this.confirmColor = Colors.redAccent,
    this.delayConfirm = Duration.zero,
    this.cancelText = "Cancel",
    this.cancelIcon = FontAwesomeIcons.xmark,
    this.onCancel,
    super.key,
  });

  /// The title of the dialogue.
  final String title;

  /// The content of the dialogue. This can be a small piece of text to explain what the user is confirming.
  final String content;

  /// The text of the confirm button
  final String confirmText;

  /// An icon to display on the confirm button
  final IconData confirmIcon;

  /// The color of the confirm button
  final Color confirmColor;

  /// When [delayConfirm] is larger than 0, the confirm button will be disabled for [delayConfirm] seconds.
  /// This may be useful when the user is about to perform an irreversible action.
  final Duration delayConfirm;

  /// The text of the cancel button
  final String cancelText;

  /// An icon to display on the cancel button
  final IconData cancelIcon;

  /// The action to perform when the user confirms the action.
  final Function onConfirm;

  /// An optional action to perform when the user cancels the action.
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    final secondsLeft = useState(delayConfirm.inSeconds);

    useEffect(
      () {
        if (delayConfirm.inSeconds == 0) return null;
        final timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            secondsLeft.value--;
            if (secondsLeft.value == 0) {
              timer.cancel();
            }
          },
        );
        return timer.cancel;
      },
      [delayConfirm],
    );

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton.icon(
          icon: Icon(cancelIcon),
          label: Text(cancelText),
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        FilledButton.icon(
          icon: Icon(confirmIcon),
          label: Text(
            secondsLeft.value == 0 ? confirmText : "$confirmText (${secondsLeft.value})",
          ),
          color: confirmColor,
          onPressed: secondsLeft.value == 0
              ? () {
                  Navigator.of(context).pop();
                  onConfirm();
                }
              : null,
        ),
      ],
    );
  }
}

void showConfirmationDialogue({
  required BuildContext context,
  required Function onConfirm,
  String title = "Are you sure?",
  String content = "This action cannot be undone.",
  String confirmText = "Confirm",
  IconData confirmIcon = Icons.check,
  Color confirmColor = Colors.redAccent,
  Duration delayConfirm = Duration.zero,
  String cancelText = "Cancel",
  IconData cancelIcon = Icons.close,
  Function? onCancel,
}) {
  showDialog(
    context: context,
    builder: (context) => ConfirmationDialogue(
      onConfirm: onConfirm,
      title: title,
      content: content,
      confirmText: confirmText,
      confirmIcon: confirmIcon,
      confirmColor: confirmColor,
      delayConfirm: delayConfirm,
      cancelText: cancelText,
      cancelIcon: cancelIcon,
      onCancel: onCancel,
    ),
  );
}
