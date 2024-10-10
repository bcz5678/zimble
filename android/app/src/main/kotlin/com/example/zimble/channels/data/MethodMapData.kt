package com.example.zimble.channels.data

import com.google.gson.Gson

/*
//  Definition: MethodMapData
//   Purpose: Building Return Message Map for MethodChannel.invokeMApMethod from Flutter
//   Return:   Map with messageSuccess and messageData values
//   Notes:  No instances created.  Use the  MethodMaData.create(data) method to return the MethodMapData
 */

class MethodMapData(){
    //Logging TAG for Debugging
    var TAG = "MethodMapData"

    companion object {
        fun create(data: Any?): Map<String, Any?> {
            var methodMapReturn: MutableMap<String, Any?> = mutableMapOf<String, Any?>()

            if (data is String ) {
                //Returns single requests or json Strings
                methodMapReturn.put("messageSuccess", "true")
                methodMapReturn.put("messageData", data)
            } else if (data is Map<*, *>){
                //Returns Map in json string format
                val gson =  Gson()
                methodMapReturn.put("messageSuccess", "true")
                methodMapReturn.put("messageData", gson.toJson(data))
            } else {
                //Returns messageSuccess: false for exceptions
                methodMapReturn.put("messageSuccess", "false")
                methodMapReturn.put("messageData", "none")
            }

            return methodMapReturn
        }
    }
}