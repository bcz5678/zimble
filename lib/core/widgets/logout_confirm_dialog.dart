import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zimble/login/login.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  Future<void> authSignUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const LoginPage();
        },
      ),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          child: Container(
            width: (constraints.maxWidth < 800) ? constraints.maxWidth : 800,
            height: (constraints.maxWidth < 800) ? 700 : 500,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      30.0, 10.0, 30.0, 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,)
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      (constraints.maxWidth < 800) ? 20.0 : 80.0,
                      30.0,
                      (constraints.maxWidth < 800) ? 20.0 : 80.0,
                      (constraints.maxWidth < 800) ? 20.0 : 10.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: AutoSizeText(
                                  'Are you sure you want to logout?',
                                  maxLines: 2,
                                  minFontSize: 15.0,
                                  style: const TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.0,
                                    color: Colors.black,
                                    height: 1.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: (constraints.maxWidth < 800) ? 30.0 : 30.0,
                        ),

                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 300,
                            minHeight: 80,
                            //maxWidth: 500,
                            maxHeight: 120,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF5BE44),
                                //fixedSize: const Size(600, 60),
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              onPressed: () => authSignUserOut(context),
                              child: Text(
                                'Yes, I want to Logout',
                                style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontFamily: 'Ubuntu',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
