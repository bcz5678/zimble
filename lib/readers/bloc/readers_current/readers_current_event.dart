part of 'readers_current_bloc.dart';

abstract class ReadersCurrentEvent extends Equatable{
  const ReadersCurrentEvent();

  @override
  List<Object> get props => [];
}


//Previously Paired SubTab
class StartSensorStream extends ReadersCurrentEvent {
  const StartSensorStream();
}

//Previously Paired SubTab
class StopSensorStream extends ReadersCurrentEvent {
  const StopSensorStream();
}