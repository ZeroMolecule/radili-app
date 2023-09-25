import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/notification_subscription/providers/notification_subscription_provider.dart';
import 'package:radili/hooks/async_callback.dart';
import 'package:radili/hooks/form_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/show_error_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/util/extensions/form_extensions.dart';
import 'package:radili/widgets/section_container.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class NotificationSubscriptionPage extends HookConsumerWidget {
  final AddressInfo? address;

  const NotificationSubscriptionPage({
    Key? key,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final showError = useShowError();
    final router = useRouter();

    final notifier = ref.watch(notificationSubscriptionProvider.notifier);
    final subscription = ref.watch(notificationSubscriptionProvider);

    final form = useForm(
      {
        'email': FormControl<String?>(
          value: subscription.valueOrNull?.email,
          validators: [Validators.email],
        ),
        'pushNotifications': FormControl<bool>(
          value: subscription.valueOrNull?.pushToken != null,
          validators: [Validators.required],
        ),
        'emailNotifications': FormControl<bool>(
          value: subscription.valueOrNull?.email != null,
          validators: [Validators.required],
        ),
        'address': FormControl<AddressInfo>(
          value: subscription.valueOrNull?.address ?? address,
          validators: [Validators.required],
        ),
      },
      keys: [subscription.valueOrNull, address],
    );

    final handleSubmit = useAsyncCallback(
      () async {
        form.throwIfInvalid({'address': t.errorAddressRequired});
        await notifier.save(
          isPushNotificationsSelected: form.control('pushNotifications').value,
          email: form.control('email').value,
          address: form.control('address').value,
        );
      },
      onError: showError,
      onDone: router.pop,
      keys: [form, notifier, showError, t],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.backButton),
        centerTitle: false,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: ReactiveForm(
              key: ValueKey(form),
              formGroup: form,
              child: MultiSliver(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      t.notifyMeTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      t.notifyMeDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SectionContainer(
                    icon: const Icon(Icons.location_on_outlined),
                    label: t.location,
                    children: [
                      AddressSearch(
                        isLoading: false,
                        showSearchIcon: false,
                        address: form.control('address').value,
                        onOptionSelected: (AddressInfo option) {
                          form.control('address').value = option;
                        },
                        padding: const EdgeInsets.all(16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SectionContainer(
                    icon: const Icon(Icons.notifications_none_outlined),
                    label: t.notifications,
                    children: [
                      ReactiveSwitchListTile(
                        formControlName: 'pushNotifications',
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          t.pushNotifications,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReactiveSwitchListTile(
                            formControlName: 'emailNotifications',
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              form.control('email').value = null;
                            },
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  t.emailNotifications,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  t.emailNotificationsDescription,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          if (form.control('emailNotifications').value == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ReactiveTextField(
                                formControlName: 'email',
                                keyboardType: TextInputType.emailAddress,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                decoration: InputDecoration(
                                  hintText: t.email,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 50),
                      ),
                      onPressed: handleSubmit,
                      child: Text(t.saveNotificationSettings),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
