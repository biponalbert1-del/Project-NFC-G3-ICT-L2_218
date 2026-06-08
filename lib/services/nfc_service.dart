import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  Future<bool> isAvailable() async {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  Future<void> startPaymentSession({
    required void Function(String payload) onPayload,
  }) async {
    final available = await isAvailable();
    if (!available) {
      onPayload('NFC non disponible sur cet appareil.');
      return;
    }

    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (tag) async {
        onPayload('Terminal NFC detecte. Verification autorisation...');
        await NfcManager.instance.stopSession();
      },
    );
  }

  Future<void> stop() {
    return NfcManager.instance.stopSession();
  }
}
