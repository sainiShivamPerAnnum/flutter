import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:shimmer/shimmer.dart';

class TransactionFAQSection extends StatefulWidget {
  final FaqsType faqsType;

  const TransactionFAQSection({
    this.faqsType = FaqsType.savings,
    super.key,
  });

  @override
  State<TransactionFAQSection> createState() => _TransactionFAQSectionState();
}

class _TransactionFAQSectionState extends State<TransactionFAQSection> {
  GetterRepository? _gettersRepo;
  bool isLoading = false;
  List<FAQDataModel> faqs = [];

  @override
  void initState() {
    super.initState();
    _gettersRepo = locator<GetterRepository>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (faqs.isEmpty) {
      _getFaqs(widget.faqsType);
    }
  }

  Future<void> _getFaqs(FaqsType type) async {
    isLoading = true;
    setState(() {});

    final res = await _gettersRepo?.getFaqs(type: type);
    if (res != null && res.isSuccess()) {
      faqs = res.model ?? [];
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.padding24,
                bottom: SizeConfig.padding16,
              ),
              child: Text(
                'Know more about the asset',
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
            ),
            SizedBox(
              height: 182,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < 8; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          left: i == 0 ? 23 : 16,
                          right: i == 8 - 1 ? 23 : 0,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffD9D9D9).withOpacity(.05),
                          highlightColor:
                              const Color(0xffD9D9D9).withOpacity(.08),
                          direction: ShimmerDirection.ltr,
                          child: AspectRatio(
                            aspectRatio: 1.37,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                            ),
                          ),
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

    if (faqs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.padding24,
              bottom: SizeConfig.padding16,
            ),
            child: Text(
              'Know more about the asset',
              style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  for (var i = 0; i < faqs.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 23 : 16,
                        right: i == faqs.length - 1 ? 23 : 0,
                      ),
                      child: FaqCard(
                        faq: faqs[i],
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FaqCard extends StatelessWidget {
  final FAQDataModel faq;

  const FaqCard({
    required this.faq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.padding16,
        SizeConfig.padding20,
        SizeConfig.padding16,
        SizeConfig.padding16,
      ),
      width: SizeConfig.screenWidth! * .66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: UiConstants.kProfileBorderColor.withOpacity(.09),
        ),
        color: const Color(0xffD9D9D9).withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.title,
            style: TextStyles.rajdhaniSB.body1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            parser.parse(faq.description).documentElement!.text,
            style: TextStyles.sourceSans.body3.colour(
              UiConstants.grey1,
            ),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
