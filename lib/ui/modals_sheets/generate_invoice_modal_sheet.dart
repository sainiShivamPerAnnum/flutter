import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_filex/open_filex.dart';

class GenerateInvoiceModalSheet extends StatefulWidget {
  const GenerateInvoiceModalSheet({Key key}) : super(key: key);

  @override
  State<GenerateInvoiceModalSheet> createState() =>
      _GenerateInvoiceModalSheetState();
}

class _GenerateInvoiceModalSheetState extends State<GenerateInvoiceModalSheet> {
  final TextEditingController _trandIdController = TextEditingController();

  final TextEditingController _uidController = TextEditingController();
  final AugmontService _augmontModel = locator<AugmontService>();
  final DBModel _dbModel = locator<DBModel>();
  final UserRepository _userRepo = locator<UserRepository>();
  bool _isLoading = false;

  get isLoading => this._isLoading;

  set isLoading(value) {
    setState(() {
      this._isLoading = value;
    });
  }

  generatePdf(String tranId, String uid) async {
    isLoading = true;
    BaseUser baseuser;
    try {
      final res = await _userRepo.getUserById(id: uid);
      baseuser = res.model;
      final Map<String, String> userDetails = {
        "name": (baseuser.kycName != null && baseuser.kycName != null)
            ? baseuser.kycName
            : baseuser.name,
        "email": baseuser.email
      };
      if (res.isSuccess())
        await _augmontModel
            .generatePurchaseInvoicePdf(tranId, userDetails)
            .then((generatedPdfFilePath) {
          isLoading = false;
          setState(() {});
          if (generatedPdfFilePath != null) {
            OpenFilex.open(generatedPdfFilePath);
          } else {
            BaseUtil.showNegativeAlert(
                'Invoice could not be loaded', 'Please try again in some time');
          }
        });
    } catch (e) {
      isLoading = false;
      BaseUtil.showNegativeAlert(
          "Something went wrong!", "please try again BP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.pageHorizontalMargins * 1.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Generate Invoice", style: TextStyles.title3.bold),
          Text("Special Feature for Bhargav Prasad",
              style: TextStyles.body3.bold.italic
                  .colour(UiConstants.primaryColor)),
          SizedBox(height: SizeConfig.padding24),
          TextFormField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Transaction Id"),
            textCapitalization: TextCapitalization.none,
            controller: _trandIdController,
            validator: (value) {
              return (value == null || value.isEmpty || value.trim().length < 4)
                  ? 'Please enter a valid Transaction Id'
                  : null;
            },
            onFieldSubmitted: (v) {
              FocusScope.of(context).nextFocus();
            },
          ),
          SizedBox(height: SizeConfig.padding12),
          TextFormField(
            autofocus: true,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "user id"),
            textCapitalization: TextCapitalization.none,
            controller: _uidController,
            validator: (value) {
              return (value == null ||
                      value.isEmpty ||
                      value.trim().length < 10)
                  ? 'Please enter a valid userId'
                  : null;
            },
            onFieldSubmitted: (v) {
              FocusScope.of(context).nextFocus();
            },
          ),
          SizedBox(height: SizeConfig.padding32),
          FelloButtonLg(
            child: isLoading
                ? SpinKitThreeBounce(
                    color: Colors.white, size: SizeConfig.padding24)
                : Text(
                    "Generate PDF",
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
            onPressed: () => generatePdf(
              _trandIdController.text.trim(),
              _uidController.text.trim(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
