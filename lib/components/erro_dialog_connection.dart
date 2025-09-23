import 'package:flutter/material.dart';

class ErroDialogConnection extends StatelessWidget {
  final VoidCallback onRetry;
  const ErroDialogConnection({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Conectando stream'),
      content: const Text('Erro de conexão com o servidor de stream'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onRetry();
          },
          child: Text('Reconectar'),
        ),
      ],
    );
  }
}
