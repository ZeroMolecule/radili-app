import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/workhours_block.dart';
import 'package:radili/generated/assets.gen.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/linker_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/widgets/store_discounts.dart';
import 'package:radili/widgets/support_prompt.dart';

class SubsidiaryItem extends HookWidget {
  final Subsidiary subsidiary;
  final bool isSelected;
  final Function() onSupportPressed;

  const SubsidiaryItem({
    super.key,
    required this.subsidiary,
    required this.onSupportPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = useTranslations();
    final theme = useTheme();
    final linker = useLinker();
    final textTheme = theme.material.textTheme;
    final cover = subsidiary.store.cover?.largeOr;
    final tabController = useTabController(initialLength: 2);

    final tabIndex =
        useListenableSelector(tabController, () => tabController.index);

    void handleOpenCatalogue() async {
      final url = subsidiary.store.catalogueUrl;
      if (url != null) {
        await linker.launch(url);
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cover != null)
            Container(
              constraints: const BoxConstraints(maxHeight: 140),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: cover.toString(),
                fit: BoxFit.fitWidth,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              subsidiary.store.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            subsidiary.address ?? subsidiary.label ?? subsidiary.store.name,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.only(right: 12),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    _Tab(
                      text: t.subsidiaryWorkHours,
                      icon: Icons.access_time_rounded,
                    ),
                    if (subsidiary.store.jelposkupiloSupported)
                      _Tab(
                        text: t.subsidiaryDiscounts,
                        icon: Icons.local_offer_outlined,
                      ),
                  ],
                ),
              ),
              if (subsidiary.store.catalogueUrl != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextButton.icon(
                    style: theme.linkButton,
                    label: Text(t.subsidiaryCatalogue),
                    icon: Assets.icons.book.svg(
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: handleOpenCatalogue,
                  ),
                ),
            ],
          ),
          Builder(builder: (context) {
            switch (tabIndex) {
              case 1:
                return StoreDiscounts(store: subsidiary.store);
              default:
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: WorkHoursBlock(
                    workHours: subsidiary.workHours,
                    expanded: true,
                  ),
                );
            }
          }),
          const SizedBox(height: 24),
          SupportPrompt(onSendPressed: onSupportPressed),
        ],
      ),
    );
  }
}

class _Tab extends HookWidget {
  final String text;
  final IconData icon;

  const _Tab({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
