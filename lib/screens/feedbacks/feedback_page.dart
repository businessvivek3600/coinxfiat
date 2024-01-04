import 'package:coinxfiat/utils/my_logger.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../constants/constants_index.dart';
import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../utils/utils_index.dart';
import '../../widgets/widget_index.dart';
import '../screen_index.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, this.id});
  final String? id;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  ValueNotifier<List<AdFeedback>> feedbacks =
      ValueNotifier<List<AdFeedback>>([]);
  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      getFeedbacks(isRefresh: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.f('feedback page didChangeDependencies: ${widget.id} ');
  }

  Future<void> getFeedbacks({bool isRefresh = false}) async {
    isLoading.value = isRefresh;
    if (isRefresh) feedbacks.value = [];
    await Apis.getFeedbacksApi(1, widget.id.validate()).then((value) {
      if (value.$1) {
        List<AdFeedback> list = tryCatch<List<AdFeedback>>(() =>
                (value.$2['data']?['ads']?['data'] ?? [])
                    .map<AdFeedback>((e) => AdFeedback.fromJson(e))
                    .toList()) ??
            [];
        if (isRefresh) {
          feedbacks.value = list;
        } else {
          feedbacks.value = [...feedbacks.value, ...list];
        }
      }
    });
    pl('feadbacks: ${feedbacks.value.length}', 'Trade List Page');
    isLoading.value = false;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, isLoading, __) {
          return Scaffold(
            appBar: AppBar(title: const Text('Feedbacks')),
            body: Column(
              children: [
                /// list
                Expanded(child: isLoading ? _loadingList() : _buildList())
              ],
            ),
          );
        });
  }

  Widget _loadingList() {
    return AnimatedListView(
      itemCount: 10,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (_, index) =>
          feedbackCard(AdFeedback(), context, false, index == 9, loading: true),
    );
  }

  Widget _buildList() {
    return ValueListenableBuilder<List<AdFeedback>>(
        valueListenable: feedbacks,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return EmptyListWidget(
              message: 'There are no feadbacks yet',
              width: 300,
              height: 300,
              refresh: () => getFeedbacks(isRefresh: true),
            );
          }
          return AnimatedListView(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: list.length,
            listAnimationType: ListAnimationType.FadeIn,
            itemBuilder: (context, index) {
              AdFeedback trade = list[index];
              bool last = index == list.length - 1;
              bool liked =
                  trade.position.validate().toLowerCase().contains('like');
              return feedbackCard(trade, context, liked, last);
            },
          );
        });
  }

  Widget feedbackCard(
      AdFeedback trade, BuildContext context, bool liked, bool last,
      {bool loading = false}) {
    return UserFeedBackCard(
        loading: loading, liked: liked, last: last, trade: trade);
  }
}

class UserFeedBackCard extends StatelessWidget {
  const UserFeedBackCard({
    super.key,
    required this.loading,
    required this.liked,
    required this.last,
    required this.trade,
  });
  final bool loading;
  final bool liked;
  final bool last;
  final AdFeedback trade;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(3)),
      child: Container(
          padding: const EdgeInsetsDirectional.all(DEFAULT_PADDING),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color: last ? Colors.transparent : Colors.grey.shade300,
                      width: 1))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Badge(
                    isLabelVisible: true,
                    alignment: Alignment.bottomRight,
                    smallSize: DEFAULT_PADDING / 2,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                        radius: DEFAULT_PADDING,
                        backgroundColor: Colors.transparent,
                        backgroundImage: assetImages(MyPng.dummyUser).image),
                  ),
                  width10(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bodyLargeText(
                          loading
                              ? '---------------'
                              : (trade.reviewer?.fullname ?? ''),
                          context,
                          style: boldTextStyle()),
                      FaIcon(
                          liked
                              ? FontAwesomeIcons.thumbsUp
                              : FontAwesomeIcons.thumbsDown,
                          size: 12,
                          color: liked ? Colors.green : Colors.red),
                    ],
                  ),
                ],
              ),
              10.height,
              Text(
                  loading
                      ? 'Lorem ipsum dolor sit amet consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'
                      : trade.feedback ?? '',
                  style: secondaryTextStyle()),
              10.height,
              Text(MyDateUtils.formatDateAsToday(trade.createdAt),
                  style: secondaryTextStyle()),
              10.height,
            ],
          )),
    );
  }
}
