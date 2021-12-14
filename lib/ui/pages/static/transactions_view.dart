import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/asymmetric/api.dart';
// import 'package:pointycastle/api.dart' as crypto;
// import 'package:rsa_encrypt/rsa_encrypt.dart';

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
                    RSAFinal()
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

class RSAFinal extends StatefulWidget {
  @override
  _RSAFinalState createState() => _RSAFinalState();
}

class _RSAFinalState extends State<RSAFinal> {
  Map<String, dynamic> ot = {
    "name": "Pikachu",
    "age": 4,
    "friends": ["Ash", "Koko"]
  };
  String et = "";

  Future<T> parseWithRootBundle<T extends RSAAsymmetricKey>(
      String filename) async {
    final key = await rootBundle.loadString(filename);
    final parser = RSAKeyParser();
    return parser.parse(key) as T;
  }

  encrypt() async {
    final data = json.encode(ot);
    final publicKey =
        await parseWithRootBundle<RSAPublicKey>("assets/public.key");
    final encrypter = Encrypter(RSA(
      publicKey: publicKey,
    ));
    final encrypted = encrypter.encrypt(data);
    setState(() {
      et = encrypted.base64;
    });
    Logger().d(encrypted.base64);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UiConstants.tertiaryLight,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          Row(
            children: [
              Text("Original text:   ", style: TextStyles.body3.bold),
              Text(ot.toString()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Encrypted text:  ", style: TextStyles.body3.bold),
              Expanded(
                  child: SelectableText(
                "$et",
                //maxLines: 3,
              )),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: SizeConfig.screenWidth,
            child: FelloButtonLg(
              child: Text(
                "Encrypt",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: encrypt,
            ),
          )
        ],
      ),
    );
  }
}


// class EncryptionTest extends StatefulWidget {
//   @override
//   _EncryptionTestState createState() => _EncryptionTestState();
// }

// class _EncryptionTestState extends State<EncryptionTest> {
//   final _winRepo = locator<WinnersRepository>();
//   bool isLoading = false;
//   String ot = "Marry had a little lamb!",
//       et = "",
//       dt = "",
//       priKey = "",
//       pubKey = "",
//       rd = "";

//   String publicKey = """-----BEGIN RSA PUBLIC KEY-----
// MIIBCgKCAQEAkqJW5OgVEeMcedOo8rsInRmwwc6qNsO+QuhNdZicPuXJR9VvrDdY
// VELMpO2kKXZGoV/Gs9VbvQKDphEFrgEwsTf7m259h6qLd7YqituOygicA7kjjxEj
// J1PwcrBuS8l/XAlcLRtU089NYOYkFuPtgintHDZZ3e/NCoCYnpOTGnMdAn5f9B03
// Y2LdXUnUf9UaCfbaJW7egJoEKZNXUynEeQcyKCN15QHBDyE6S3bCGxlWYpzSDWN9
// H7VOboskegpMjU3KpOyw47wXmljXs4RsNI+UUUzgUjRmnZeUmJo6w5Ku4VCTf2oe
// oD6AUhmU8RVWDuOWOyA+ivllDBaEemZCGQIDAQAB
// -----END RSA PUBLIC KEY-----""";

// // //Future to hold our KeyPair
// //   Future<crypto.AsymmetricKeyPair> futureKeyPair;

// // //to store the KeyPair once we get data from our future
// //   crypto.AsymmetricKeyPair keyPair;

// //   Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
// //       getKeyPair() {
// //     var helper = RsaKeyHelper();
// //     return helper.computeRSAKeyPair(helper.getSecureRandom());
// //   }

// //   crypto.PublicKey MyPublicKey;

//   generateKeyPair() async {
//     // futureKeyPair = getKeyPair();
//     // keyPair = await futureKeyPair;
//     // setState(() {
//     //   priKey = RsaKeyHelper().encodePrivateKeyToPemPKCS1(keyPair.privateKey);
//     //   pubKey = RsaKeyHelper().encodePublicKeyToPemPKCS1(keyPair.publicKey);
//     // });
//   }

//   sendData() async {
//     // Codec<String, String> stringToBase64 = utf8.fuse(base64);
//     // MyPublicKey = RsaKeyHelper().parsePublicKeyFromPem(publicKey);
//     // Logger().d("${RsaKeyHelper().encodePublicKeyToPemPKCS1(MyPublicKey)}");

//     // et = encrypt(ot, MyPublicKey);
//     // String base46Converted = stringToBase64.encode(et);
//     // Map<String, dynamic> body = {'encrypted': base46Converted};
//     // // ApiResponse<Map<String, dynamic>> result =
//     // //     await _winRepo.getDecryptedData(body);
//     // Logger().d(body);
//     // setState(() {
//     //   rd = body.toString();
//     // });
//   }

//   Future<T> parseWithRootBundle<T extends RSAAsymmetricKey>(
//       String filename) async {
//     final key = await rootBundle.loadString(filename);
//     final parser = RSAKeyParser();
//     return parser.parse(key) as T;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: SizeConfig.screenWidth,
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text("Original text:   ", style: TextStyles.body3.bold),
//               Text("$ot"),
//             ],
//           ),
//           Row(
//             children: [
//               Text("Encrypted text:  ", style: TextStyles.body3.bold),
//               Expanded(
//                   child: Text(
//                 "$et",
//                 maxLines: 3,
//               )),
//             ],
//           ),
//           Row(
//             children: [
//               Text("Decrypted text:  ", style: TextStyles.body3.bold),
//               Text("$dt",
//                   style:
//                       TextStyles.body3.bold.colour(UiConstants.primaryColor)),
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 10),
//             width: SizeConfig.screenWidth,
//             height: SizeConfig.screenHeight * 0.2,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text("Public Key: ", style: TextStyles.body3.bold),
//                       Expanded(child: Text("$pubKey")),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text("Private Key: ", style: TextStyles.body3.bold),
//                       Expanded(child: Text("$priKey")),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                   onPressed: generateKeyPair, child: Text("Get Pair")),
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       // et = encrypt(ot, MyPublicKey);
//                     });
//                   },
//                   child: Text("Encrypt")),
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       // dt = decrypt(et, keyPair.privateKey);
//                     });
//                   },
//                   child: Text("Decrypt")),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(onPressed: sendData, child: Text("Send data")),
//               ElevatedButton(
//                   onPressed: () async {
//                     final data = json.encode({
//                       "name": "Pikachu",
//                       "age": 4,
//                       "friends": ["Ash", "Koko"]
//                     });
//                     final publicKey = await parseWithRootBundle<RSAPublicKey>(
//                         "assets/public.key");
//                     final encrypter = Encrypter(RSA(
//                       publicKey: publicKey,
//                     ));
//                     final encrypted = encrypter.encrypt(data);

//                     Logger().d(encrypted.base64);
//                   },
//                   child: Text("New Test")),
//             ],
//           ),
//           Row(
//             children: [
//               Text("Recieved Data: "),
//               Expanded(
//                   child: Text(
//                 "$rd",
//                 maxLines: 4,
//               )),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
