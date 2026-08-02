import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'app_primary_button.dart';

/// Two-button modal action row: secondary action on the left, primary flow on
/// the right. Use this inside [AlertDialog.actions] or bottom-sheet footers.
class AppDialogActions extends StatelessWidget {
  const AppDialogActions({
    super.key,
    required this.secondaryLabel,
    required this.onSecondaryPressed,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.primaryLoading = false,
  });

  final String secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: secondaryLabel,
              onPressed: onSecondaryPressed,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppPrimaryButton(
              label: primaryLabel,
              loading: primaryLoading,
              onPressed: onPrimaryPressed,
            ),
          ),
        ],
      ),
    );
  }
}
