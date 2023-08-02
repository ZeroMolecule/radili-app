import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/subsidiary_item.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';

class SubsidiariesSidebar extends HookWidget {
  final List<Subsidiary> subsidiaries;
  final Subsidiary? selectedSubsidiary;
  final Function(Subsidiary subsidiary) onSubsidiarySelected;

  const SubsidiariesSidebar({
    Key? key,
    required this.subsidiaries,
    required this.onSubsidiarySelected,
    this.selectedSubsidiary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = useTranslations();
    final textTheme = useTheme().material.textTheme;
    final colors = useColorScheme();
    return Container(
      color: colors.background,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: 5,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                t.resultsCount(subsidiaries.length),
                style: textTheme.bodyLarge,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final subsidiary = subsidiaries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: RawMaterialButton(
                    onPressed: () => onSubsidiarySelected(subsidiary),
                    child: SubsidiaryItem(
                      subsidiary: subsidiary,
                      isSelected: subsidiary.id == selectedSubsidiary?.id,
                    ),
                  ),
                );
              },
              childCount: subsidiaries.length,
            ),
          )
        ],
      ),
    );
  }
}
