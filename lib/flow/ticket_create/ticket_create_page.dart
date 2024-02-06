import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/flow/ticket_create/ticket_create_controller.dart';
import 'package:radili/flow/ticket_create/widgets/ticket_create_form.dart';
import 'package:radili/generated/assets.gen.dart';
import 'package:radili/hooks/async_action_hook.dart';
import 'package:radili/hooks/async_snapshot_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/show_error_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/navigation/app_router.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class TicketCreatePage extends HookConsumerWidget {
  final int? subsidiaryId;

  const TicketCreatePage({
    super.key,
    @queryParam this.subsidiaryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final theme = useTheme();
    final router = useRouter();
    final showError = useShowError();

    final ticketCreateController = ref.watch(ticketCreateControllerProvider);

    final ticketCreateAction = useAsyncAction();

    void handleSubmit(String email, String? name, String summary) {
      ticketCreateAction.run(() async {
        await ticketCreateController.create(
          email: email,
          name: name,
          summary: summary,
          subsidiaryId: subsidiaryId,
        );
      });
    }

    useAsyncSnapshot(
      ticketCreateAction.snapshot,
      onSuccess: (_) => router.replace(
        SuccessRoute(
          title: t.supportSuccessTitle,
          description: t.suportSuccessDescription,
          image: Assets.images.mailbox.svg(),
        ),
      ),
      onError: showError,
    );

    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          MultiSliver(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  t.supportTitle,
                  style: theme.material.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(t.supportDescription),
              ),
            ],
          ),
          SliverFillRemaining(
            fillOverscroll: false,
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: TicketCreateForm(
                onSubmit: handleSubmit,
                isLoading: ticketCreateAction.snapshot.isWaiting,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
