import 'package:flutter/material.dart';

/// Standard primary action button used across the app instead of a raw
/// [ElevatedButton] per screen — sizing/shape/color all come from
/// [ElevatedButtonThemeData] (see `AppTheme`), never set inline here. Shows
/// a spinner and disables tapping while [loading] is true.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}

/// Standard secondary action button for cancel/skip/back flows. It mirrors
/// [AppPrimaryButton]'s sizing but uses the app's outlined button theme.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}
