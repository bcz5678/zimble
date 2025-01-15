import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/readers/readers.dart';

class ConnectNewReadersScreen extends StatefulWidget {
  const ConnectNewReadersScreen({super.key});

  @override
  State<ConnectNewReadersScreen> createState() =>
      _ConnectNewReadersScreenState();
}

class _ConnectNewReadersScreenState extends State<ConnectNewReadersScreen>
    with TickerProviderStateMixin {

  late TabController _tabControllerConnect;
  double? scrolledUnderElevation;
  bool shadowColor = false;
  late List<Tab> connectNavTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    connectNavTabs = _buildConnectNavTabsList(context);
    _tabControllerConnect = TabController(
        vsync: this,
        length: connectNavTabs.length
    );
  }

  @override
  void dispose() {
    _tabControllerConnect.dispose();
    super.dispose();
  }

  List<Tab> _buildConnectNavTabsList(BuildContext context) {
    return [
      Tab(
        text: context.l10n.readersConnectTabPairedDevices,
      ),
      Tab(
        text: context.l10n.readersConnectTabScanDevices,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    late ReaderRepository _readerRepository = context.read<ReaderRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ReadersBloc>(
          create: (_) => ReadersBloc(
            readerRepository: _readerRepository,
          ),
        ),
        BlocProvider<ReadersConnectBloc>(
          create: (_) => ReadersConnectBloc(
            readerRepository: _readerRepository,
          ),
        ),
      ],
      child: Column(
        children: [
          Container(
            color: AppColors.lingoWhite,
            child: TabBar(
              controller: _tabControllerConnect,
              indicatorColor: AppColors.lingoOrange_100,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              labelStyle: TextStyle(
                color: AppColors.lingoOrange_100,
              ),
              unselectedLabelStyle: TextStyle(
                color: AppColors.grey,
              ),
              tabs: connectNavTabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabControllerConnect,
              children: [
                PairedReadersScreen(),
                ScanReadersScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
