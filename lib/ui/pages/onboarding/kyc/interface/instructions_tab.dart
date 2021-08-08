import 'package:felloapp/ui/elements/buttons/contact_us_button.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboard_data.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

class InstructionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(shrinkWrap: true, children: [
        getInstruction(
            "PAN",
            "Upload your PAN card image. We will automatically fetch the required details from it.",
            "images/PAN_card.png"),
        getInstruction(
            "Aadhar Card",
            "Upload the front and back image of your Aadhaar card. We will read the aadhaar number and address from it automatically,",
            Assets.dummyAadhaarCard),
        getInstruction(
            "Cancelled Cheque",
            "Upload a cancelled cheque of your primary bank account. This will be used to fetch your bank details and perform a deposit to your account for confirmation",
            Assets.dummyCancelledCheque),
        getInstruction(
            "Signature",
            "Provide your signature that is used by you for all official purposes",
            null),
        getInstruction(
            "Basic Details",
            "This step asks for a few important details like you date of birth and so",
            null),
        getInstruction(
            "Location",
            "Your location is automatically fetched during this step. You do have to be present at a defined specific location for verification.",
            null),
        getInstruction(
            "Profile Picture",
            "You can either click a selfie or upload a profile picture for this step.",
            null),
        getInstruction(
            "Video Verification",
            "This step simply requires you to record a video of yourself, where you have to speak the OTP that is shared with you as soon as you click on the step. The video should be less than 20 seconds and the entire process can be done inside the app itself.",
            null),
        getInstruction(
            "Application Review",
            "For this you’re redirected to the official NSDL url, where you can review your application and submit it by using an OTP sent to your Aadhaar linked mobile number.",
            null),
        ContactUsBtn(),
      ]),
    );
  }

  getInstruction(
    String title,
    String subtitle,
    String image,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: KycOnboardData.getTitleStyle(),
        ),
        subtitle: Wrap(
          children: [
            KycOnboardData.getNotes(subtitle),
            image != null ? KycOnboardData.getNotes("Example:") : Container(),
            image != null
                ? Container(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
