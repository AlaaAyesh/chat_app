import 'package:flutter/material.dart';
import '../../../data/repositories/status_repository.dart';

class StatusInput extends StatefulWidget {
  final List<String> contactIds;

  const StatusInput({super.key, required this.contactIds});

  @override
  _StatusInputState createState() => _StatusInputState();
}

class _StatusInputState extends State<StatusInput> {
  final TextEditingController _statusController = TextEditingController();
  final StatusRepository _statusRepository = StatusRepository();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _statusController,
      decoration: InputDecoration(
        hintText: "What's on your mind?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            await _statusRepository.postStatus(_statusController.text, widget.contactIds);
            _statusController.clear();
          },
        ),
      ),
    );
  }
}
