import 'package:flutter/material.dart';
import '../enums/liveness_action.dart';

class InstructionWidget extends StatelessWidget {
  final LivenessAction? action;

  const InstructionWidget({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    if (action == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getActionMessage(action!),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getActionMessage(LivenessAction action) {
    switch (action) {
      case LivenessAction.blink:
        return 'Blink your eyes';
      case LivenessAction.smile:
        return 'Smile';
      case LivenessAction.turnLeft:
        return 'Turn your head left';
      case LivenessAction.turnRight:
        return 'Turn your head right';
      case LivenessAction.lookUp:
        return 'Look up';
      case LivenessAction.lookDown:
        return 'Look down';
    }
  }
}
