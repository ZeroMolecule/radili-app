import 'package:radili/domain/repository/support_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ticket_create_controller.g.dart';

class TicketCreateController {
  final SupportRepository _supportRepository;

  const TicketCreateController(this._supportRepository);

  Future<void> create({
    required String email,
    required String? name,
    required String summary,
    required int? subsidiaryId,
  }) async {
    await _supportRepository.createTicket(
      email: email,
      name: name,
      summary: summary,
      subsidiaryId: subsidiaryId,
    );
  }
}

@riverpod
TicketCreateController ticketCreateController(TicketCreateControllerRef ref) {
  return TicketCreateController(ref.watch(supportRepositoryProvider));
}
