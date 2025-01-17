import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hele_app/common/Widget/entry_title.dart';
import 'package:hele_app/common/Widget/network_img.dart';
import 'package:hele_app/common/utils/evaluation_utils.dart';
import 'package:hele_app/model/character_list/character_list.dart';
import 'package:hele_app/model/derivation/related_works_query.dart';
import 'package:hele_app/model/person_career/person_career.dart';
import 'package:hele_app/model/subjects/subjects.dart';
import 'package:hele_app/pages/home/widget/custom_tabs.dart';
import 'package:hele_app/pages/wiki/controllers/wiki_controller.dart';
import 'package:hele_app/pages/wiki/widget/action_item.dart';
import 'package:hele_app/pages/wiki/widget/horizontal_rating.dart';
import 'package:hele_app/pages/wiki/widget/info_subitem.dart';
import 'package:hele_app/pages/wiki/widget/introduction.dart';
import 'package:hele_app/pages/wiki/widget/more_information.dart';
import 'package:hele_app/pages/wiki/widget/popup_header.dart';
import 'package:hele_app/pages/wiki/widget/ratingGraph.dart';
import 'package:hele_app/pages/wiki/widget/tab_selector_horizontal.dart';
import 'package:hele_app/pages/wiki/widget/tag_selection.dart';
import 'package:hele_app/routes/app_pages.dart';
import 'package:hele_app/themes/app_style/colors/app_theme_color_scheme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class Wiki extends StatefulWidget {
  const Wiki({super.key});

  @override
  State<Wiki> createState() => _WikiState();
}

// BUG 该页面在生产模式下会出现空指针解引用（null pointer dereference）
// todo 初始化标记数据
class _WikiState extends State<Wiki> with TickerProviderStateMixin {
  final WikiController _wikiController = Get.find<WikiController>();

  // final WikiController _wikiController = Get.put(WikiController());

  int subjectId = 0; // 条目id
  late Future _future;

  @override
  void initState() {
    super.initState();
    subjectId = _wikiController.subjectId;
    List<Future<dynamic>> futureList = [
      _wikiController.querySubjectDetails(subjectId),
      _wikiController.querySubjectCharacterList(subjectId),
      _wikiController.querySubjectPersons(subjectId),
      _wikiController.querySubjectDerivation(subjectId)
    ];
    try {
      _future = Future.wait(futureList);
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _wikiController.dispose();
    super.dispose();
  }

  // todo 评论吐槽（无接口） HTML解析转实体
  // todo 剧中相关地点，景点展示
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: Stack(children: [
      // 背景图片
      _buildBackgroundImage(),
      _buildAppBar(),
      Padding(
        padding: EdgeInsets.fromLTRB(40.w, 162.h, 40.w, 0.h),
        child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Subjects s = snapshot.data[0]; // 条目信息
                List<CharacterList> characters = snapshot.data[1]; // 角色列表
                List<PersonCareer> persons = snapshot.data[2]; // 演员信息
                List<RelatedWorksQuery> derivation = snapshot.data[3]; // 衍生条目
                List<Widget> slivers = [];
                // 封面介绍
                slivers.addAll([
                  SliverGap(16.h),
                  SliverToBoxAdapter(
                      child: Introduction(
                    s: s,
                    imgUrl: _wikiController.imgUrl,
                    title: _wikiController.title,
                    production: _wikiController.production.value,
                    tags: _wikiController.tags,
                  )),
                  // 功能列表
                  SliverToBoxAdapter(
                    child: actionGrid(context, s),
                  ),
                  SliverGap(16.h),
                ]);

                // 简介
                if (s.summary != "") {
                  slivers.add(SliverToBoxAdapter(
                      child: Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ExpandText(
                            s.summary,
                            maxLines: 4,
                            style: TextStyle(color: colorScheme.secondary.withOpacity(0.85)),
                          ))));
                }

                // 剧集
                if ((s.eps != 0 && s.eps < 60) || (s.totalEpisodes != 0 && s.totalEpisodes < 60)) {
                  slivers.addAll([
                    EntryTitle(
                      title: "剧集",
                      size: 42.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SliverGap(16.h),
                    contentGrid(s.totalEpisodes != 0 ? s.totalEpisodes : s.eps),
                    SliverGap(24.h),
                  ]);
                }

                // 评分信息
                if (s.rating.total >= 10) {
                  slivers.addAll([
                    SliverToBoxAdapter(
                      child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '评分',
                                  style: TextStyle(
                                      fontSize: 42.sp, fontWeight: FontWeight.bold, color: colorScheme.secondary)),
                              if (s.rating.score != 0)
                                TextSpan(
                                    text: " ${s.rating.score}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: AppThemeColorScheme.top, fontSize: 40.sp)),
                            ])),
                            if (s.rating.rank != 0)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 28.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      AppThemeColorScheme.top3,
                                      AppThemeColorScheme.top,
                                      AppThemeColorScheme.top2,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  "${s.rating.rank} 名",
                                  style: TextStyle(
                                      color: colorScheme.onPrimary, fontSize: 28.sp, fontWeight: FontWeight.bold),
                                ),
                              )
                          ]),
                    ),
                    SliverGap(16.h),
                    SliverToBoxAdapter(child: SizedBox(height: 250.h, child: RatingGraph(count: s.rating.count))),
                    SliverGap(8.h),
                    SliverToBoxAdapter(
                        child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                          AutoSizeText(
                            "共计 ${s.rating.total} 条评分",
                            style: TextStyle(
                              fontSize: 27.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondaryContainer.withOpacity(0.85),
                            ),
                          ),
                          AutoSizeText("当前评价：${_wikiController.dispute}",
                              style: TextStyle(
                                fontSize: 26.5.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondaryContainer.withOpacity(0.85),
                              ))
                        ])),
                    SliverGap(24.h),
                  ]);
                }

                // 角色信息
                if (characters.isNotEmpty) {
                  slivers.addAll([
                    EntryTitle(
                        title: "角色",
                        fontWeight: FontWeight.bold,
                        size: 42.sp,
                        child: MoreInformation(
                          onTap: () {
                            Get.toNamed(Routes.WIKI_EXTENDED, arguments: {"type": 1, "list": characters});
                          },
                        )),
                    SliverGap(16.h),
                    SliverToBoxAdapter(
                        child: SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return InfoSubitem(
                                  src: characters[index].images?.medium,
                                  radius: 5,
                                  fit: BoxFit.fitHeight,
                                  title: characters[index].name,
                                  subtitle: EvaluationUtils.getSubTitle(
                                      characters[index].relation, characters[index].actors ?? []),
                                  onTap: () {
                                    Get.toNamed(Routes.WIKI_DETAIL, arguments: {
                                      "id": characters[index].id,
                                      "type": 1,
                                      "name": characters[index].name
                                    });
                                  },
                                );
                              },
                              itemCount: characters.length,
                              scrollDirection: Axis.horizontal,
                            ))),
                    SliverGap(24.h),
                  ]);
                }

                // 制作人员
                if (persons.isNotEmpty) {
                  slivers.addAll([
                    EntryTitle(
                        title: "制作人员",
                        fontWeight: FontWeight.bold,
                        size: 42.sp,
                        child: MoreInformation(
                          onTap: () {
                            Get.toNamed(Routes.WIKI_EXTENDED, arguments: {"type": 2, "list": persons});
                          },
                        )),
                    SliverGap(16.h),
                    SliverToBoxAdapter(
                        child: SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return InfoSubitem(
                                  src: persons[index].images?.medium,
                                  title: persons[index].name,
                                  subtitle: persons[index].relation,
                                  onTap: () {
                                    Get.toNamed(Routes.WIKI_DETAIL,
                                        arguments: {"id": persons[index].id, "type": 2, "name": persons[index].name});
                                  },
                                );
                              },
                              itemCount: persons.length,
                              scrollDirection: Axis.horizontal,
                            ))),
                    SliverGap(24.h),
                  ]);
                }

                // 关联作品
                if (derivation.isNotEmpty) {
                  slivers.addAll([
                    EntryTitle(
                        title: "相关作品",
                        fontWeight: FontWeight.bold,
                        size: 42.sp,
                        child: MoreInformation(
                          onTap: () {
                            Get.toNamed(Routes.WIKI_EXTENDED, arguments: {"type": 3, "list": derivation});
                          },
                        )),
                    SliverGap(16.h),
                    SliverToBoxAdapter(
                        child: SizedBox(
                            height: 330.h,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                String? title = derivation[index].nameCn != "" && derivation[index].nameCn != null
                                    ? derivation[index].nameCn
                                    : derivation[index].name;
                                return InfoSubitem(
                                  containerWidth: 200.w,
                                  src: derivation[index].images?.medium,
                                  width: 200.w,
                                  height: 230.h,
                                  fit: BoxFit.cover,
                                  title: title,
                                  subtitle: derivation[index].relation,
                                  onTap: () {},
                                );
                              },
                              itemCount: derivation.length,
                              scrollDirection: Axis.horizontal,
                            ))),
                    SliverGap(60.h),
                  ]);
                }

                return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: slivers);
              } else if (snapshot.hasError) {
                // todo 网络重试点击事件
                return Center(
                    child: InkWell(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText("网络异常，请稍后重试！",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40.sp, color: colorScheme.secondary)),
                            Gap(8.w),
                            AutoSizeText(":(", style: TextStyle(fontSize: 70.sp, color: colorScheme.secondary)),
                          ],
                        )));
              } else {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: colorScheme.primary,
                    size: 140.sp,
                  ),
                );
              }
            }),
      )
    ]));
  }

  // 功能模块
  Widget actionGrid(BuildContext context, Subjects subject) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 4),
        height: constraints.maxWidth * 0.17,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          padding: EdgeInsets.zero,
          crossAxisCount: 4,
          childAspectRatio: 1.5,
          children: [
            Obx(() => ActionItem(
                icon: const Icon(FontAwesomeIcons.thumbsUp),
                selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
                onTap: () {
                  _wikiController.recommendation.value = !_wikiController.recommendation.value;
                },
                selectStatus: _wikiController.recommendation.value,
                text: "推荐")),
            Obx(() => ActionItem(
                  icon: const Icon(FontAwesomeIcons.faceGrinWide),
                  selectIcon: const Icon(FontAwesomeIcons.faceSmileWink),
                  onTap: () {
                    _show(subject, colorScheme);
                  },
                  selectStatus: _wikiController.mark.value,
                  text: "标记",
                )),
            Obx(() => ActionItem(
                  icon: const Icon(FontAwesomeIcons.star),
                  selectIcon: const Icon(FontAwesomeIcons.solidStar),
                  onTap: () {
                    // todo 收藏逻辑与后续逻辑冲突
                    if (_wikiController.mark.value) {
                      _wikiController.favorite.value = !_wikiController.favorite.value;
                      _wikiController.save(subject, _wikiController.favorite.value);
                    } else {
                      SmartDialog.showToast('请先标注');
                    }
                  },
                  selectStatus: _wikiController.favorite.value,
                  text: "收藏",
                )),
            ActionItem(
              icon: const Icon(FontAwesomeIcons.shareFromSquare),
              onTap: () {
                Share.share('''我正在关注《${_wikiController.title}》,快来一起吧！
海报图片：${_wikiController.imgUrl}
                ''');
              },
              selectStatus: false,
              text: '分享',
            ),
          ],
        ),
      );
    });
  }

  // 提交弹框
  void _show(Subjects subject, ColorScheme colorScheme) async {
    await SmartDialog.show(
        clickMaskDismiss: true,
        usePenetrate: false,
        debounce: true,
        onDismiss: () => SmartDialog.config.attach = SmartConfigAttach(),
        builder: (_) => _popupBody(subject, colorScheme));
  }

  Widget _popupBody(Subjects subject, ColorScheme colorScheme) {
    return Container(
      width: Get.width * 0.85,
      height: Get.height * 0.55,
      padding: EdgeInsets.fromLTRB(36.w, 36.h, 36.w, 24.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 标题
          PopupHeader(
            title: _wikiController.title,
            subtitle: subject.name,
            showClose: true,
          ),

          // 评分项
          Obx(() => HorizontalRating(
                score: subject.rating.score / 2,
                qualityRating: _wikiController.qualityRating.value,
                onChanged: (double rating) {
                  _wikiController.userRating.value = rating * 2;
                  _wikiController.qualityRating.value = EvaluationUtils.getRecommendation(rating);
                },
              )),

          // 标签选择
          if (_wikiController.tags.isNotEmpty) const TagSelection(),

          // 状态
          const TabSelectorHorizontal(),

          // 提交
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: MaterialButton(
                      height: 65.h,
                      elevation: 0,
                      color: colorScheme.primaryContainer,
                      // colorScheme.tertiaryContainer.withOpacity(0.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      textTheme: ButtonTextTheme.primary,
                      onPressed: () {
                        _wikiController.save(subject, _wikiController.favorite.value);
                        SmartDialog.dismiss(force: true);
                      },
                      child: const AutoSizeText("确定"))),
              Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Obx(
                    () => MaterialButton(
                      height: 65.h,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      color: _wikiController.isHidden.value
                          ? colorScheme.secondary.withOpacity(0.9)
                          : colorScheme.primary.withOpacity(0.65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      textTheme: ButtonTextTheme.primary,
                      onPressed: () {
                        _wikiController.isHidden.value = !_wikiController.isHidden.value;
                      },
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FaIcon(
                            _wikiController.isHidden.value ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 35.sp,
                            color: colorScheme.onPrimary,
                          ),
                          Gap(20.w),
                          AutoSizeText(
                            _wikiController.isHidden.value ? "私密" : "公开",
                            minFontSize: 12,
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  // 剧集列表
  Widget contentGrid(int eps) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 5.w,
          crossAxisCount: 6,
          mainAxisExtent: 52.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return CustomChip(
              onTap: () {},
              label: (index + 1).toString(),
              selected: false,
              isPadding: false,
              isTranslucent: true,
            );
          },
          childCount: eps,
        ));
  }

  // AppBar
  Widget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: true,
      forceMaterialTransparency: true,
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.SEARCH),
          icon: const Icon(Icons.search_outlined),
        ),
        PopupMenuButton<String>(
          onSelected: (String type) {
            // todo 处理菜单项选择的逻辑
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[],
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // 背景图
  Widget _buildBackgroundImage() {
    return Opacity(
        opacity: 0.2,
        child: ClipRect(
            child: Stack(alignment: Alignment.bottomCenter, children: [
          // 图片组件
          AspectRatio(
            aspectRatio: 1.5,
            child: NetworkImg(
              src: _wikiController.imgUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),

          // 模糊滤镜
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: const SizedBox(),
          ),

          // 渐变遮罩
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
            Theme.of(context).colorScheme.primary.withOpacity(0.5),
            Theme.of(context).colorScheme.surface,
          ]))))
        ])));
  }
}
