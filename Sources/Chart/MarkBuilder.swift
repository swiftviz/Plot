//
//  MarkBuilder.swift
//
//
//  Created by Joseph Heck on 4/7/22.
//

import Foundation

// MARK: - collection access to different kinds of 'mark' templates

// reference for result builders:
// https://docs.swift.org/swift-book/ReferenceManual/Attributes.html
// https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630

/// A type-erased Mark.
public struct AnyMark: Mark {
    // TODO(heckj): Might need to change how this type-erasure mechanism is working, shifting to a fully
    // wrapped type erasure in order to allow underlying components to be manipulated in a consistent way.
    //
    // This closure-based type erasure hides everything except for the ability to get symbols out when
    // its provided with a range into which they can be drawn, but there's a use case where we want to
    // align the domains of multiple marks, with different data sets, into a single - broader and combined -
    // domain for the representation. Currently each mark is entirely encapsulated, and there's no way after
    // the type-erasure to "reach in" and manipulate the domains to allow them to be expanded and/or synchronized,
    // let alone read to determine a corrected domain for each symbol.

    private let wrappedSymbolsForMark: (_ rangeLower: CGFloat, _ rangeHigher: CGFloat) -> [MarkSymbol]

    public init<T: Mark>(_ specificMark: T) {
        wrappedSymbolsForMark = specificMark.symbolsForMark(rangeLower:rangeHigher:)
    }

    public func symbolsForMark(rangeLower: CGFloat, rangeHigher: CGFloat) -> [MarkSymbol] {
        wrappedSymbolsForMark(rangeLower, rangeHigher)
    }
}

@resultBuilder
public enum MarkBuilder {
    // DEV NOTE: all of these builder expressions need to be `public static func` - miss
    // the `public` part of it, and that excludes the function from being invoked during
    // the compilation process, resulting in odd type errors (which I learned the hard way).

    public static func buildExpression<T>(_ element: BarMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildExpression<T>(_ element: DotMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildExpression<T>(_ element: LineMark<T>) -> [AnyMark] {
        [AnyMark(element)]
    }

    public static func buildBlock(_ components: [AnyMark]...) -> [AnyMark] {
        Array(components.joined())
    }
}
