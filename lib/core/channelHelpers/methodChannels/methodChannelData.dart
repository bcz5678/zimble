import "dart:convert";

class MethodChannelData {
  final Map<String, dynamic> data;

  MethodChannelData(
    this.data
  );

  Map<String, dynamic> encodeSendMap() {

    Map<String, dynamic> methodChannelDataMap = {};
    methodChannelDataMap["messageData"] = {};

    data.forEach((k, v) {
      if (v is Map) {
        methodChannelDataMap["messageData"][k] = json.encode(v);
      } else {
        methodChannelDataMap["messageData"][k] = v;
      }
    });

    return methodChannelDataMap;
  }
}