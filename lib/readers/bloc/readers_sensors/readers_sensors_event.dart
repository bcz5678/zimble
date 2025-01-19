part of 'readers_sensors_bloc.dart';

abstract class ReadersSensorsEvent extends Equatable{
  const ReadersSensorsEvent();

  @override
  List<Object> get props => [];
}


//Previously Paired SubTab
class StartSensorStream extends ReadersSensorsEvent {
  const StartSensorStream();
}

//Previously Paired SubTab
class StopSensorStream extends ReadersSensorsEvent {
  const StopSensorStream();
}