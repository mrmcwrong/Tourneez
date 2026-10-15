import 'package:flutter/material.dart';

/// Collapsed color control. Open it for a saturation square, hue slider, and hex.
class HsvColorPicker extends StatefulWidget {
  const HsvColorPicker({
    super.key,
    required this.colorArgb,
    required this.onChanged,
  });

  final int colorArgb;
  final ValueChanged<int> onChanged;

  @override
  State<HsvColorPicker> createState() => _HsvColorPickerState();
}

class _HsvColorPickerState extends State<HsvColorPicker> {
  bool _open = false;
  late HSVColor _hsv;
  late final TextEditingController _hex;
  final _hexFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(Color(widget.colorArgb));
    _hex = TextEditingController(text: _hexText(_hsv));
  }

  @override
  void didUpdateWidget(covariant HsvColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.colorArgb & 0xFFFFFF) == (_argb & 0xFFFFFF)) return;
    _hsv = HSVColor.fromColor(Color(widget.colorArgb));
    if (!_hexFocus.hasFocus) _hex.text = _hexText(_hsv);
  }

  @override
  void dispose() {
    _hex.dispose();
    _hexFocus.dispose();
    super.dispose();
  }

  int get _argb => _hsv.toColor().toARGB32();

  void _commit(HSVColor next) {
    setState(() => _hsv = next);
    if (!_hexFocus.hasFocus) _hex.text = _hexText(next);
    widget.onChanged(next.toColor().toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final selected = _hsv.toColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _open = !_open),
            icon: CircleAvatar(radius: 10, backgroundColor: selected),
            label: Text(_open ? 'Hide colors' : 'Choose color'),
          ),
        ),
        if (_open) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ColoredBox(color: selected),
                ),
                Expanded(
                  flex: 5,
                  child: _SaturationSquare(
                    hsv: _hsv,
                    onChanged: (saturation, value) {
                      _commit(
                        _hsv.withSaturation(saturation).withValue(value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _HueSlider(
            hue: _hsv.hue,
            onChanged: (hue) => _commit(_hsv.withHue(hue)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _hex,
            focusNode: _hexFocus,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'HEX',
              floatingLabelAlignment: FloatingLabelAlignment.center,
              hintText: '#449441',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) {
              final parsed = _parseHex(value);
              if (parsed == null) return;
              setState(() {
                _hsv = HSVColor.fromColor(Color(parsed));
              });
              widget.onChanged(parsed);
            },
          ),
        ],
      ],
    );
  }
}

class _SaturationSquare extends StatelessWidget {
  const _SaturationSquare({required this.hsv, required this.onChanged});

  final HSVColor hsv;
  final void Function(double saturation, double value) onChanged;

  void _apply(Offset local, double width, double height) {
    final saturation = (local.dx / width).clamp(0.0, 1.0);
    final value = (1 - (local.dy / height)).clamp(0.0, 1.0);
    onChanged(saturation, value);
  }

  @override
  Widget build(BuildContext context) {
    final hue = HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final dx = hsv.saturation * width;
        final dy = (1 - hsv.value) * height;
        return GestureDetector(
          onPanDown: (d) => _apply(d.localPosition, width, height),
          onPanUpdate: (d) => _apply(d.localPosition, width, height),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.white, hue]),
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (dx - 11).clamp(0, width - 22),
                top: (dy - 11).clamp(0, height - 22),
                child: IgnorePointer(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HueSlider extends StatelessWidget {
  const _HueSlider({required this.hue, required this.onChanged});

  final double hue;
  final ValueChanged<double> onChanged;

  static double _hueFromX(double dx, double width) =>
      (dx / width).clamp(0.0, 1.0) * 359.999;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final x = (hue / 360) * width;
          return GestureDetector(
            onPanDown: (d) => onChanged(_hueFromX(d.localPosition.dx, width)),
            onPanUpdate: (d) => onChanged(_hueFromX(d.localPosition.dx, width)),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF0000),
                        Color(0xFFFFFF00),
                        Color(0xFF00FF00),
                        Color(0xFF00FFFF),
                        Color(0xFF0000FF),
                        Color(0xFFFF00FF),
                        Color(0xFFFF0000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (x - 12).clamp(0.0, width - 24),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _hexText(HSVColor hsv) =>
    '#${(hsv.toColor().toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

int? _parseHex(String raw) {
  var text = raw.trim();
  if (text.startsWith('#')) text = text.substring(1);
  if (text.length == 3) {
    text = text.split('').map((c) => '$c$c').join();
  }
  if (text.length != 6) return null;
  final rgb = int.tryParse(text, radix: 16);
  if (rgb == null) return null;
  return 0xFF000000 | rgb;
}
