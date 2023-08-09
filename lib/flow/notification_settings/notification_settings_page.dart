import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/notification_settings/providers/notification_settings_provider.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/async_callback.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/form_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class NotificationSettingsPage extends HookConsumerWidget {
  final AddressInfo? address;
  const NotificationSettingsPage({
    Key? key,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final colors = useColorScheme();

    final notificationSettingsNotifier = ref.watch(
      notificationSettingsProvider.notifier,
    );
    final form = useForm(
      {
        'email': FormControl<String?>(
          validators: [Validators.required, Validators.email],
        ),
        'pushNotifications': FormControl<bool>(
          value: false,
          validators: [Validators.required],
        ),
        'emailNotifications': FormControl<bool>(
          value: false,
          validators: [Validators.required],
        ),
        'address': FormControl<AddressInfo>(
          value: address,
          validators: [Validators.required],
        ),
      },
    );

    final handleSubmit = useAsyncCallback(
      () async {
        if (form.valid) {
          await notificationSettingsNotifier.saveSettings(
            coords: form.control('address').value!.latLng,
            isPushNotificationsSelected:
                form.control('pushNotifications').value,
            isEmailNotificationsSelected:
                form.control('emailNotifications').value,
            email: form.control('email').value,
          );
        }
      },
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.erroSomethingWentWrong),
          ),
        );
      },
      keys: [form, t],
    );

    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: handleSubmit,
          backgroundColor: AppColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          label: Text(t.saveNotificationSettings),
        ),
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
              sliver: MultiSliver(
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              top: 16,
                              left: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  t.location,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              left: 36,
                              right: 36,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.white,
                              ),
                              child: AddressSearch(
                                address: form.control('address').value,
                                onOptionSelected: (AddressInfo option) {
                                  form.control('address').value = option;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              top: 16,
                              left: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications_none_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  t.notifications,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 36,
                              right: 36,
                            ),
                            child: ReactiveSwitchListTile(
                              formControlName: 'pushNotifications',
                              title: Text(
                                t.pushNotifications,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              left: 36,
                              right: 36,
                            ),
                            child: ReactiveSwitchListTile(
                              onChanged: (value) {
                                form.control('email').value = null;
                              },
                              formControlName: 'emailNotifications',
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          ),
                          form.control('emailNotifications').value == true
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16,
                                    left: 36,
                                    right: 36,
                                  ),
                                  child: ReactiveTextField(
                                    formControlName: 'email',
                                    decoration:
                                        InputDecoration(labelText: t.email),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
