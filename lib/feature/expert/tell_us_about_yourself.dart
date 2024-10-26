import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/expert/bloc/tell_us_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TellUsAboutYourselfView extends StatelessWidget {
  const TellUsAboutYourselfView({required this.bookingId, super.key});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TellUsBloc(
        locator(),
      ),
      child: _TellUsAboutYourselfScreen(bookingId: bookingId),
    );
  }
}

class _TellUsAboutYourselfScreen extends StatefulWidget {
  const _TellUsAboutYourselfScreen({required this.bookingId});
  final String bookingId;

  @override
  State<_TellUsAboutYourselfScreen> createState() =>
      _TellUsAboutYourselfScreenState();
}

class _TellUsAboutYourselfScreenState
    extends State<_TellUsAboutYourselfScreen> {
  String? selectedIncome;
  final TextEditingController investmentController = TextEditingController();
  final TextEditingController financialGoalsController =
      TextEditingController();
  final TextEditingController expectationsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    investmentController.dispose();
    financialGoalsController.dispose();
    expectationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: UiConstants.kTextColor,
        ),
        title: Text(
          'Tell us about yourself',
          style: TextStyles.rajdhaniSB.body1,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.padding18),
              _buildHeading('What is your Annual Personal Income?'),
              SizedBox(height: SizeConfig.padding12),
              _buildDropdownButton(),
              SizedBox(height: SizeConfig.padding24),
              _buildHeading('Where all have you already invested?'),
              SizedBox(height: SizeConfig.padding12),
              _buildTextField("Start typing here", investmentController),
              SizedBox(height: SizeConfig.padding24),
              _buildHeading('What are your Financial Goals?'),
              SizedBox(height: SizeConfig.padding12),
              _buildTextField("Start typing here", financialGoalsController),
              SizedBox(height: SizeConfig.padding24),
              _buildHeading('What are your Expectations from this Call?'),
              SizedBox(height: SizeConfig.padding12),
              _buildTextField("Start typing here", expectationsController),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildHeading(String heading) {
    return Text(
      heading,
      style: TextStyles.sourceSansSB.body2,
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        color: UiConstants.greyVarient,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: UiConstants.greyVarient,
          hint: Text(
            'Click to select',
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.kTextColor5,
            ),
          ),
          value: selectedIncome,
          isExpanded: true,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: UiConstants.kTextColor,
            size: SizeConfig.body4,
          ),
          items: _getIncomeOptions(),
          onChanged: (newValue) {
            setState(() {
              selectedIncome = newValue; // Update selected income
            });
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getIncomeOptions() {
    final List<String> incomeOptions = [
      'Below ₹1 Lakh',
      '₹1 Lakh - ₹5 Lakh',
      '₹5 Lakh - ₹10 Lakh',
      '₹10 Lakh - ₹20 Lakh',
      'Above ₹20 Lakh',
    ];

    return incomeOptions.map((income) {
      return DropdownMenuItem<String>(
        value: income,
        child: Text(
          income,
          style: TextStyles.sourceSans.body4.colour(
            UiConstants.kTextColor,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyles.sourceSans.body4.colour(
        UiConstants.kTextColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.sourceSans.body4.colour(
          UiConstants.kTextColor5,
        ),
        filled: true,
        fillColor: UiConstants.greyVarient,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          borderSide: const BorderSide(color: UiConstants.greyVarient),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          borderSide: const BorderSide(color: UiConstants.greyVarient),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
      ).copyWith(
        bottom: SizeConfig.padding20,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UiConstants.greyVarient,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyles.sourceSans.body3,
              ),
            ),
          ),
          SizedBox(width: SizeConfig.padding12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _submitForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UiConstants.kTextColor,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
              ),
              child: Text(
                'Confirm',
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (selectedIncome == null ||
        investmentController.text.isEmpty ||
        financialGoalsController.text.isEmpty ||
        expectationsController.text.isEmpty) {
      BaseUtil.showNegativeAlert(
        'Form Submit failed',
        'Please fill in all the fields.',
      );
      return;
    }
    final income = selectedIncome ?? 'N/A';
    final investments = investmentController.text;
    final financialGoals = financialGoalsController.text;
    final expectations = expectationsController.text;

    List<Map<String, String>> questionAnswerArray = [
      {
        "question": "What is your Annual Personal Income?",
        "answer": income,
      },
      {
        "question": "Where all have you already invested?",
        "answer": investments,
      },
      {
        "question": "What are your Financial Goals?",
        "answer": financialGoals,
      },
      {
        "question": "What are your Expectations from this Call?",
        "answer": expectations,
      },
    ];

    // Dispatch the event to submit the form
    BlocProvider.of<TellUsBloc>(context).add(
      SubmitQNA(questionAnswerArray, widget.bookingId),
    );
  }
}
