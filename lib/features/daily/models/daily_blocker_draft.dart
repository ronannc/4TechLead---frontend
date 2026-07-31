class DailyBlockerDraft {
  const DailyBlockerDraft({required this.text, this.resolved = false});

  final String text;
  final bool resolved;

  DailyBlockerDraft toggleResolved() {
    return DailyBlockerDraft(text: text, resolved: !resolved);
  }
}
