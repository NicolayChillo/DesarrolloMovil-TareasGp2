import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_styles.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/custom_elevated_button.dart';
import '../core/widgets/custom_icon.dart';
import '../core/widgets/custom_text.dart';
import '../viewmodel/pin_viewmodel.dart';
import 'main_page.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PinViewModel>().loadPin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PinViewModel>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'PIN de Acceso'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomText(
                text: 'Ingresa el PIN',
                style: AppStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _pinCircle(viewModel.pinLength, 0),
                    _pinCircle(viewModel.pinLength, 1),
                    _pinCircle(viewModel.pinLength, 2),
                    _pinCircle(viewModel.pinLength, 3),
                    const SizedBox(width: 18),
                    IconButton(
                      onPressed: viewModel.deleteNumber,
                      icon: const CustomIcon(icon: Icons.backspace_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _numberRow(['1', '2', '3']),
              const SizedBox(height: 12),
              _numberRow(['4', '5', '6']),
              const SizedBox(height: 12),
              _numberRow(['7', '8', '9']),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _numberButton('0'),
                ],
              ),
              const SizedBox(height: 18),
              CustomText(
                text: viewModel.mensaje,
                style: viewModel.esCorrecto
                    ? AppStyles.subtitle.copyWith(color: AppColors.secondary)
                    : AppStyles.subtitle.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      text: 'Olvidé mi PIN',
                      onPressed: _isProcessing ? () {} : _showForgotPinDialog,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _numberButton(number)).toList(),
    );
  }

  Widget _numberButton(String number) {
    final viewModel = context.read<PinViewModel>();

    return SizedBox(
      width: 85,
      child: CustomButton(
        text: number,
        onPressed: _isProcessing
            ? () {}  // Si está procesando, no hace nada
            : () {
          final isCorrect = viewModel.addNumber(number);
          if (isCorrect) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          }
        },
      ),
    );
  }

  Widget _pinCircle(int length, int index) {
    final isFilled = index < length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? AppColors.primary : Colors.transparent,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );
  }

  // ====== OLVIDÉ MI PIN (diálogo) ======
  void _showForgotPinDialog() {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restablecer PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa un nuevo PIN de 4 dígitos:'),
              const SizedBox(height: 10),
              TextField(
                controller: pinController,
                autofocus: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nuevo PIN',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPin = pinController.text.trim();
                if (newPin.length != 4) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('El PIN debe tener 4 dígitos')),
                  );
                  return;
                }
                Navigator.pop(dialogContext);
                setState(() => _isProcessing = true);
                final viewModel = context.read<PinViewModel>();
                await viewModel.changePinAsync(newPin);
                if (mounted) {
                  setState(() => _isProcessing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN cambiado exitosamente')),
                  );
                }
              },
              child: const Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }
}