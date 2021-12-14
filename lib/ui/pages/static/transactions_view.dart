import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      floatingActionButton: keyboardIsOpen && Platform.isIOS
          ? FloatingActionButton(
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: UiConstants.tertiarySolid,
              onPressed: () => FocusScope.of(context).unfocus(),
            )
          : SizedBox(),
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "Transactions",
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.scaffoldMargin),
                    // FelloBriefTile(
                    //   leadingAsset: Assets.bankDetails,
                    //   title: "Bank Account Details",
                    //   trailingIcon: Icons.arrow_forward_ios_rounded,
                    //   onTap: () {
                    //     AppState.delegate.appState.currentAction = PageAction(
                    //       state: PageState.addPage,
                    //       page: EditAugBankDetailsPageConfig,
                    //     );
                    //   },
                    // ),
                    // FelloBriefTile(
                    //   leadingAsset: Assets.txnHistory,
                    //   title: "Transaction History and Invoice",
                    //   trailingIcon: Icons.arrow_forward_ios_rounded,
                    //   onTap: () {
                    //     AppState.delegate.appState.currentAction = PageAction(
                    //       state: PageState.addPage,
                    //       page: TransactionsHistoryPageConfig,
                    //     );
                    //   },
                    // ),
                    EncryptionTest()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EncryptionTest extends StatefulWidget {
  @override
  _EncryptionTestState createState() => _EncryptionTestState();
}

class _EncryptionTestState extends State<EncryptionTest> {
  final _winRepo = locator<WinnersRepository>();

  String ot = "Marry had a little lamb!",
      et = "",
      dt = "",
      priKey = "",
      pubKey = "",
      rd = "";

  String publicKey = """-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAikEuUu/aeJ0AAlorW+99ZWFx6phYItvYGQkY+CKHk+9HZn2fjBxn
/DhMvBf3aWhV5FUQ6RN1Dosp4OfnCutgvPS9g9GG2MNsV5nmjOwuQH86wcIDLL2x
mMelANI21FNnkoOUduqUD7iuH5g/4j5KZv+0W8CdaloSkR765zvA+BffBVBIbdwm
5nRvy/HlNPc40w52ROHtnf9xDT8O9fHdRwIcDeIgsfoncDI+kA3k6YO5f5rtneWF
NejZgGM7VoLgFJj1jnMypwLz0EPf0tNaufYwZCGHjH0vEjRN5p7un/qZBfIVi3bX
S1nfn/3dBYZmm4CeqETmpWGgc3/j2NfDKwIDAQAB
-----END RSA PUBLIC KEY-----""";

//Future to hold our KeyPair
  Future<crypto.AsymmetricKeyPair> futureKeyPair;

//to store the KeyPair once we get data from our future
  crypto.AsymmetricKeyPair keyPair;

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  crypto.PublicKey MyPublicKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text("Original text:   ", style: TextStyles.body3.bold),
              Text("$ot"),
            ],
          ),
          Row(
            children: [
              Text("Encrypted text:  ", style: TextStyles.body3.bold),
              Expanded(
                  child: Text(
                "$et",
                maxLines: 3,
              )),
            ],
          ),
          Row(
            children: [
              Text("Decrypted text:  ", style: TextStyles.body3.bold),
              Text("$dt",
                  style:
                      TextStyles.body3.bold.colour(UiConstants.primaryColor)),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Public Key: ", style: TextStyles.body3.bold),
                      Expanded(child: Text("$pubKey")),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Private Key: ", style: TextStyles.body3.bold),
                      Expanded(child: Text("$priKey")),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    futureKeyPair = getKeyPair();
                    keyPair = await futureKeyPair;
                    setState(() {
                      MyPublicKey =
                          RsaKeyHelper().parsePublicKeyFromPem(publicKey);
                      print(MyPublicKey);
                      priKey = RsaKeyHelper()
                          .encodePrivateKeyToPemPKCS1(keyPair.privateKey);
                      pubKey = RsaKeyHelper()
                          .encodePublicKeyToPemPKCS1(keyPair.publicKey);
                    });
                  },
                  child: Text("Get Pair")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      et = encrypt(ot, MyPublicKey);
                    });
                  },
                  child: Text("Encrypt")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dt = decrypt(et, keyPair.privateKey);
                    });
                  },
                  child: Text("Decrypt")),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> body = {'encrypted': et};
                // ApiResponse<Map<String, dynamic>> result =
                //     await _winRepo.getDecryptedData(body);
                Logger().d(body);
                setState(() {
                  rd = body.toString();
                });
              },
              child: Text("Send data")),
          Row(
            children: [
              Text("Recieved Data: "),
              Expanded(child: Text("$rd")),
            ],
          )
        ],
      ),
    );
  }
}
