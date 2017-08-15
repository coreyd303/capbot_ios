//
//  JSONHelper.swift
//  ChatBot
//
//  Created by Corey Davis on 8/8/17.
//  Copyright © 2017 Corey Davis. All rights reserved.
//

public enum JSONProcessorError: Error {
    case protocolNotImplemented
    case parsingError(String)
    case protocolTypeMismatch
}

public func from<T>(_ object: Any?) throws -> T {
    if let result = object as? T {
        return result
    }
    throw JSONProcessorError.parsingError("Could not find result of type \(T.self); instead found \(String(describing: object))")
}
