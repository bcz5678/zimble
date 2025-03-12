import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/app/view/app.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/login/view/login_modal.dart';
import 'package:zimble/navigation/navigation.dart';
import 'package:zimble/user_profile/user_profile.dart';

import 'package:zimble/tag_scan/tag_scan.dart';

class TagScanView extends StatefulWidget {
  const TagScanView({super.key});

  @override
  State<TagScanView> createState() => _TagScanViewState();
}

class _TagScanViewState extends State<TagScanView> {
  double? scrolledUnderElevation;
  bool shadowColor = false;


  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
      previous.showLoginOverlay != current.showLoginOverlay,
      listener: (context, state) {
        if (state.showLoginOverlay) {
          showAppModal<void>(
            context: context,
            builder: (context) => const LoginModal(),
            routeSettings: const RouteSettings(name: LoginModal.name),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppRoutes.tagScan.title ?? 'Tag Scan'),
          titleTextStyle: UITextStyle.headline1,
          scrolledUnderElevation: scrolledUnderElevation,
          centerTitle: true,
          backgroundColor: AppColors.lingoDark_100,
          leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
          actions: const [
            UserProfileButton()
          ],
        ),
        drawer: Drawer(
          width: MediaQuery
              .of(context)
              .size
              .width * .85,
          child: const NavDrawer(),
        ),

        body: Container(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<TagScanBloc, TagScanState>(
              builder: (context, state) {
                return Center(
                  child: TagScanScreen(),
                );
              },
            )
        ),
      ),
    );
  }
}


class TagScanScreen extends StatefulWidget {
  const TagScanScreen({super.key});

  @override
  State<TagScanScreen> createState() => _TagScanScreenState();
}

class _TagScanScreenState extends State<TagScanScreen> {
  late bool _scanButtonState = false;
  late List<Map<String, dynamic>> tagDataScanList;

  @override
  void initState() {
    tagDataScanList = [];
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _scanButtonState
                  ? context.read<TagScanBloc>().add(TagScanStop())
                  : context.read<TagScanBloc>().add(TagScanStart());

              setState(() {
                _scanButtonState = !_scanButtonState;
              });
            },
            child: _scanButtonState
                ? Text(
              context.l10n.tagScanButtonStopScan,
            )
                : Text(
              context.l10n.tagScanButtonStartScan,
            )
        ),
        BlocBuilder<TagScanBloc, TagScanState>(
          builder: (context, state) {
            if(state.stateStatus == TagScanStatus.scanUpdated) {
              return Expanded(
                child: CustomScrollView(
                  slivers: [
                    if(state.currentScanTagDataList!.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index){
                              return TagScanDataCard(
                                  tagScanDataItem: state.currentScanTagDataList![index],
                              );
                            },
                          childCount: state.currentScanTagDataList!.length
                        ),
                      ),
                  ]
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class TagScanDataCard extends StatefulWidget {
  const TagScanDataCard({
    required this.tagScanDataItem,
    super.key
  });

  final Map<String, dynamic> tagScanDataItem;

  @override
  State<TagScanDataCard> createState() => _TagDataCardState();

}

class _TagDataCardState extends State<TagScanDataCard> {
  late TagScanData _tagScanData;
  late int _numberTimesSeen;

  get math => null;

  @override
  void initState() {
    _tagScanData = widget.tagScanDataItem["tagScanData"] as TagScanData;
    _numberTimesSeen = widget.tagScanDataItem["numberTimesSeen"] as int;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.lingoDark_20,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 8,
                child: Text(
                  _tagScanData.epc.toString(),
                  style: TextStyle(
                    color: AppColors.lingoBlack_80,
                    fontSize: 10.0,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                 _tagScanData.rssi.toString(),
                  style: TextStyle(
                    color: AppColors.lingoBlack_80,
                    fontSize: 10.0,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  _numberTimesSeen.toString(),
                  style: TextStyle(
                    color: AppColors.lingoBlack_80,
                    fontSize: 10.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



