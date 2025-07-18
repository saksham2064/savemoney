import 'package:flutter/material.dart';

class DangerEmoji extends StatefulWidget {
  final TextEditingController amountController;
  final String Function() getEmojiForAmount;

  const DangerEmoji({
    super.key,
    required this.amountController,
    required this.getEmojiForAmount,
  });

  @override
  State<DangerEmoji> createState() => _DangerEmojiState();
}

class _DangerEmojiState extends State<DangerEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    widget.amountController.addListener(_handleChange);
  }

  void _handleChange() {
    final amount = double.tryParse(widget.amountController.text);
    final isDangerous = amount != null && amount > 10000;

    if (isDangerous && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!isDangerous && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    widget.amountController.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.getEmojiForAmount(),
        style: const TextStyle(fontSize: 48),
      ),
    );
  }
}
