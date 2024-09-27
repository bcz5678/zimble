package com.example.untitled.reader.trigger.domain

class ModelException : Exception {
    constructor()

    constructor(detailMessage: String?) : super(detailMessage)

    constructor(throwable: Throwable?) : super(throwable)

    constructor(detailMessage: String?, throwable: Throwable?) : super(detailMessage, throwable)

    companion object {
        private const val serialVersionUID = 469698280001919043L
    }
}