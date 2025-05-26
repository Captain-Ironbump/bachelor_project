import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/presentation/_widgets/tag_widget.dart';
import 'package:student_initializer/presentation/cubits/tag/get_tags/get_tags_cubit.dart';
import 'package:student_initializer/providers/tag_use_case_provider.dart';
import 'package:student_initializer/util/tag_color_mapper.dart';
import 'package:student_initializer/presentation/cubits/tag/save_tag/save_tag_cubit.dart';

class TagsSettingEditView extends StatelessWidget {
  final Function(TagDetailEntity?) onTagSaved;
  const TagsSettingEditView({
    super.key, required this.onTagSaved,
  });

  void _showAddTagDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    Color selectedColor = CupertinoColors.activeBlue;
    final List<Color> colorOptions = TagColorMapper.allCupertinoColors;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            } else {
              currentFocus.unfocus();
            }
          },
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
              builder: (context, setState) {
                return CupertinoPopupSurface(
                  isSurfacePainted: false,
                  child: CupertinoActionSheet(
                    title: const Text("Add Tag"),
                    message: Column(
                      children: [
                        CupertinoTextField(
                          controller: _controller,
                          placeholder: "Tag-Name",
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: colorOptions.map((color) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedColor = color),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedColor == color
                                        ? CupertinoColors.black
                                        : CupertinoColors.systemGrey4,
                                    width: 2,
                                  ),
                                ),
                                child: selectedColor == color
                                    ? const Icon(CupertinoIcons.check_mark,
                                        size: 18, color: CupertinoColors.white)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          TagDetailEntity? tagDetailEntity = TagDetailEntity(
                            tag: _controller.text,
                            tagColor: TagColorMapper.toDb(selectedColor),
                          );
                          onTagSaved(tagDetailEntity);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Save"),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocListener<SaveTagCubit, SaveTagState>(
        listener: (context, state) {
          if (state is SaveTagLoading) {
            showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const CupertinoAlertDialog(
                content: CupertinoActivityIndicator(),
              ),
            );
          } else if (state is SaveTagSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Success'),
                content: const Text('Tag was successfully saved!'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('OK'),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            );
          } else if (state is SaveTagError) {
            Navigator.of(context, rootNavigator: true).pop();
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Error'),
                content: Text(state.message ?? 'Unknown error'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('OK'),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            );
          }
        },
        child: Container(
          color: CupertinoColors.systemGrey6,
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            navigationBar: CupertinoNavigationBar(
              middle: const Text("Tags"),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _showAddTagDialog(context);
                  //Navigator.of(context).pop(true);
                },
                child: const Icon(CupertinoIcons.plus_circle_fill),
              ),
            ),
            child: BlocBuilder<GetTagsCubit, GetTagsState>(
              builder: (context, state) {
                if (state is GetTagsLoading) {
                  return CupertinoFormSection.insetGrouped(
                    children: const [
                      BaseIndicator(),
                    ],
                  );
                }
                if (state is GetTagsLoaded) {
                  if (state.tags!.isEmpty) {
                    return CupertinoFormSection.insetGrouped(
                      children: [
                        const Text("No tags available"),
                        CupertinoButton(
                          onPressed: () {
                            context.read<GetTagsCubit>().fetchAllTags();
                          },
                          child: const Text("Reload Tags"),
                        ),
                      ],
                    );
                  }
                  return CupertinoFormSection.insetGrouped(
                    children: state.tags!.map((tag) {
                      return CupertinoListTile(
                        title: TagWidget(
                            tagName: tag.tag!, tagColor: tag.tagColor!),
                        additionalInfo: Text(tag.tagColor!),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  }
}
