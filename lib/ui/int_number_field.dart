import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Compact integer input for format options (replaces most sliders).
class IntNumberField extends StatelessWidget {
  const IntNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
    this.min,
    this.max,
    this.enabled = true,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final String? helperText;
  final int? min;
  final int? max;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        key: ValueKey('$label-$value-$enabled'),
        initialValue: '$value',
        enabled: enabled,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperMaxLines: 2,
        ),
        onChanged: (raw) {
          final parsed = int.tryParse(raw.trim());
          if (parsed == null) return;
          var next = parsed;
          if (min != null && next < min!) next = min!;
          if (max != null && next > max!) next = max!;
          if (next != value) onChanged(next);
        },
      ),
    );
  }
}
