import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/readers/readers.dart';

class CurrentReadersScreen extends StatefulWidget {
  const CurrentReadersScreen({super.key});

  @override
  State<CurrentReadersScreen> createState() => _CurrentReadersScreenState();
}

class _CurrentReadersScreenState extends State<CurrentReadersScreen>
    with TickerProviderStateMixin  {

  late TabController _tabControllerCurrent;
  double? scrolledUnderElevation;
  bool shadowColor = false;
  late List<Tab> currentNavTabs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentNavTabs = _buildCurrentNavTabsList(context);
    _tabControllerCurrent = TabController(
        vsync: this,
        length: currentNavTabs.length
    );
  }

  @override
  void dispose() {
    _tabControllerCurrent.dispose();
    super.dispose();
  }

  List<Tab> _buildCurrentNavTabsList(BuildContext context) {
    return [
      Tab(
        text: context.l10n.readersCurrentTabAttached,
      ),
      Tab(
        text: context.l10n.readersCurrentTabSensors,
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
        BlocProvider<ReadersCurrentBloc>(
          create: (_) => ReadersCurrentBloc(
            readerRepository: _readerRepository,
          ),
        ),
        BlocProvider<ReadersAttachedBloc>(
          create: (_) => ReadersAttachedBloc(
            readerRepository: _readerRepository,
          ),
        ),
        BlocProvider<ReadersSensorsBloc>(
          create: (_) => ReadersSensorsBloc(
            readerRepository: _readerRepository,
          ),
        ),
      ],
      child: Column(
        children: [
          Container(
            color: AppColors.lingoWhite,
            child: TabBar(
              controller: _tabControllerCurrent,
              indicatorColor: AppColors.lingoOrange_100,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              labelStyle: TextStyle(
                color: AppColors.lingoOrange_100,
              ),
              unselectedLabelStyle: TextStyle(
                color: AppColors.grey,
              ),
              tabs: currentNavTabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabControllerCurrent,
              children: [
                AttachedReadersScreen(),
                SensorsReadersScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}