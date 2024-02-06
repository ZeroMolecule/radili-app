import 'package:radili/domain/remote/support_api.dart';

class SupportRepository {
  final SupportApi _supportApi;

  SupportRepository(this._supportApi);

  Future<void> createTicket({
    required String email,
    required String? name,
    required String summary,
    required int? subsidiaryId,
  }) async {
    await _supportApi.createTicket(
      email: email,
      name: name,
      summary: summary,
      subsidiaryId: subsidiaryId,
    );
  }
}
