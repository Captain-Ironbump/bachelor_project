import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/presentation/_widgets/tag_widget.dart';

class ObservatioDetailWidget extends StatelessWidget {
  final ObservationDetailEntity observationDetailEntity;
  final List<TagDetailEntity> tags;
  final Function(int eventId) onDeleteCallback;

  const ObservatioDetailWidget({
    super.key,
    required this.observationDetailEntity,
    required this.tags,
    required this.onDeleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.parse(observationDetailEntity.createdDate!));

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.inactiveGray,
                      fontSize: 12.0,
                    ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  child: Row(
                    children: tags.map((tag) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TagWidget(
                          tagName: tag.tag ?? "Unknown",
                          tagColor: tag.tagColor ?? "systemBlue",
                          fontSize: 12.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 24,
                onPressed: () {
                  onDeleteCallback(observationDetailEntity.observationId!);
                },
                child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            observationDetailEntity.observation!,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
