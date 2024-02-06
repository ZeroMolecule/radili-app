import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/dismiss_keyboard_hook.dart';
import 'package:radili/hooks/form_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/widgets/app_button.dart';
import 'package:radili/widgets/section_container.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TicketCreateForm extends HookWidget {
  final bool isLoading;
  final Function(String email, String? name, String summary) onSubmit;

  const TicketCreateForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = useTranslations();
    final handleDismissKeyboard = useDismissKeyboard();

    final form = useForm({
      'email': FormControl<String>(validators: [
        Validators.required,
        Validators.email,
      ]),
      'name': FormControl<String>(validators: []),
      'summary': FormControl<String>(validators: [Validators.required]),
    });

    void handleSubmit() {
      if (form.valid) {
        onSubmit(
          form.control('email').value,
          form.control('name').value,
          form.control('summary').value,
        );
      }
    }

    return ReactiveForm(
      key: ValueKey(form),
      formGroup: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionContainer(
            label: t.supportContactInfo,
            icon: const Icon(Icons.person),
            divider: const SizedBox(height: 16),
            children: [
              ReactiveTextField(
                formControlName: 'email',
                decoration: InputDecoration(hintText: t.supportEmailHint),
                keyboardType: TextInputType.emailAddress,
                onTapOutside: (_) => handleDismissKeyboard(),
              ),
              ReactiveTextField(
                formControlName: 'name',
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: t.supportNameHint),
                onTapOutside: (_) => handleDismissKeyboard(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionContainer(
            label: t.supportSummary,
            icon: const Icon(Icons.description),
            children: [
              ReactiveTextField(
                formControlName: 'summary',
                decoration: InputDecoration(hintText: t.supportSummaryHint),
                textAlignVertical: TextAlignVertical.top,
                maxLines: 100,
                minLines: 4,
                onTapOutside: (_) => handleDismissKeyboard(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Spacer(),
          AppButton(
            isLoading: isLoading,
            onPressed: form.valid ? handleSubmit : null,
            child: Text(t.supportSubmit),
          ),
        ],
      ),
    );
  }
}
