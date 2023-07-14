import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FoundBug extends StatefulWidget {
  const FoundBug({super.key});

  @override
  State<FoundBug> createState() => _FoundBugState();
}

class _FoundBugState extends State<FoundBug> {
  /// Create a text controller. Later, use it to retrieve the
  /// current value of the TextField.
  late TextEditingController _bugReasonController;

  /// Form Keys For Validating
  final _bugReasonFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  bool value = false;
  String? dropDownValue;
  String reason = "";
  String? errorMsg;
  String? dropDownErrorMsg;

  @override
  void initState() {
    super.initState();
    _bugReasonController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.pageHorizontalMargins,
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff39393C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness16),
            topRight: Radius.circular(SizeConfig.roundness16),
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x29000000),
                offset: Offset(0, -3),
                blurRadius: 6,
                spreadRadius: 0)
          ],
          // color: Colors.white,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Report a Bug", style: TextStyles.sourceSansSB.title5),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Text("Please select a category of the issue",
                  style: TextStyles.sourceSans.body3),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    dropdownColor: UiConstants.kSecondaryBackgroundColor,
                    iconSize: SizeConfig.padding20,
                    decoration: InputDecoration(
                      border: (dropDownErrorMsg == null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          : const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding10),
                      enabledBorder: (dropDownErrorMsg == null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                          : const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                      filled: true,
                      fillColor: const Color(0xff1A1A1A),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
                              height: -10,
                              color: Colors.transparent,
                              fontSize: 0),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                    iconEnabledColor: UiConstants.kTextColor,
                    elevation: 0,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    hint: Text(
                      'Select One',
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor),
                    ),
                    value: dropDownValue,
                    items: [
                      DropdownMenuItem(
                        value: 'Gold',
                        child: Text(
                          'Gold',
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Flo',
                        child: Text(
                          'Flo',
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Referrals',
                        child: Text(
                          'Referrals',
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          dropDownValue = val;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        dropDownErrorMsg = "Please Choose One Option";
                        print("dropDownErrorMsg $dropDownErrorMsg");
                        return dropDownErrorMsg;
                      }
                      return null;
                    },
                  ),
                  if (dropDownErrorMsg != null)
                    const CommonInputErrorLabel(
                      errorMessage: "Please Choose One Option",
                    )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Text(
                "How would you describe the bug?",
                style: TextStyles.sourceSans.body3,
              ),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              Column(
                children: [
                  Container(
                    // width: SizeConfig.screenWidth,
                    // height: SizeConfig.padding104,
                    decoration: BoxDecoration(
                      color: const Color(0xff1A1A1A),
                      borderRadius: BorderRadius.circular(SizeConfig.padding8),
                    ),
                    child: TextFormField(
                      controller: _bugReasonController,
                      maxLines: 5,
                      onChanged: (val) {
                        if (_bugReasonFormKey.currentState?.validate() ??
                            false) {}
                        setState(() {
                          reason = val;
                        });
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          errorMsg = "Please be more descriptive";
                          return errorMsg;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Start typing here...',
                        hintStyle: TextStyles.sourceSans.body3
                            .colour(Colors.white.withOpacity(0.5)),
                        focusedBorder: InputBorder.none,
                        border: (errorMsg == null)
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )
                            : const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.all(SizeConfig.padding16),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        errorStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(
                                height: -10,
                                color: Colors.transparent,
                                fontSize: 0),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyles.sourceSans.body3.colour(
                        UiConstants.kTextColor,
                      ),
                    ),
                  ),
                  if (errorMsg != null)
                    const CommonInputErrorLabel(
                      errorMessage: 'Please be more descriptive',
                    )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding18,
              ),
              Text(
                "Attach a screenshot (Optional)",
                style: TextStyles.sourceSans.body3,
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Container(
                width: SizeConfig.padding72,
                height: SizeConfig.padding72,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: const Color(0xffcacaca), width: 1),
                  color: const Color(0xff1A1A1A),
                ),
                child: const Center(
                  child:
                      // (state is ImageCollectSuccessState)
                      //     ? Image.memory(base64Decode(state.file))
                      //     :
                      Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding18,
              ),
              AppPositiveBtn(
                btnText: 'SUBMIT',
                onPressed: () {
                  setState(() {});
                  if (_formKey.currentState!.validate() &&
                      _bugReasonFormKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  }
                  // submitted.value = true;

                  // locator<AnalyticsService>().track(
                  //   eventName: AnalyticsEvents.reviewPopupSuccess,
                  //   properties: {
                  //     "Rating given": selected.value + 1,
                  //     "Reason": textController.text,
                  //   },
                  // );
                },
              ),
              SizedBox(
                height: SizeConfig.padding18,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommonInputErrorLabel extends StatelessWidget {
  final String? errorMessage;

  const CommonInputErrorLabel({Key? key, this.errorMessage = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFfa6400),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        padding: const EdgeInsets.all(5),
        child: Text(
          errorMessage!,
          style: const TextStyle(
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
              fontFamily: "Inter-Regular_",
              fontStyle: FontStyle.normal,
              fontSize: 10),
        ),
      ),
    );
  }
}
