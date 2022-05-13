//
//  DotMark.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import CoreGraphics
import SwiftUI
import SwiftVizScale

/// A type that represents a series of bars.
///
/// The type infers the number and visual properties of the bars from the data you provide to the visual channels when declaring a bar mark.
public struct PointMark<DataSource>: Mark {
    let data: [DataSource]
    let x: QuantitativeVisualChannel<DataSource>
    let y: QuantitativeVisualChannel<DataSource>
    public var xPropertyType: VisualPropertyType {
        .quantitative
    }

    public var yPropertyType: VisualPropertyType {
        .quantitative
    }

    public let xAxis: Axis?
    public let yAxis: Axis?

    public init(data: [DataSource],
                x xChannel: QuantitativeVisualChannel<DataSource>,
                y yChannel: QuantitativeVisualChannel<DataSource>)
    {
        self.data = data
        x = xChannel.applyDomain(data)
        y = yChannel.applyDomain(data)
        xAxis = nil
        yAxis = nil
    }

    /// Creates a list of symbols to render into a rectangular drawing area that you specify.
    /// - Parameter in: The rectangle into which to scale and draw the symbols.
    /// - Returns: A list of symbol data structures with the information needed to draw them onto a canvas or into CoreGraphics context.
    public func symbolsForMark(in rect: CGRect) -> [MarkSymbol] {
        let xScale = x.range(rangeLower: 0, rangeHigher: rect.size.width)
        let yScale = y.range(rangeLower: 0, rangeHigher: rect.size.height)
        var symbols: [MarkSymbol] = []
        print("Creating symbols within rect: \(rect)")
        print("X scale: \(xScale)")
        print("Y scale: \(yScale)")
        for pointData in data {
            if let xValue = xScale.scaledValue(data: pointData),
               let yValue = yScale.scaledValue(data: pointData)
            {
                let newPoint = IndividualPoint(x: xValue + rect.origin.x, y: rect.height - yValue + rect.origin.y, shape: PlotShape(Circle()), size: 5)
                symbols.append(.point(newPoint))
                print(" .. \(newPoint)")
            }
        }
        return symbols
    }

    public func axisForMark(in _: CGRect) -> [Axis.AxisLocation: Axis] {
        [:]
    }
}
