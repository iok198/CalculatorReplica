//
//  ContentView.swift
//  CalculatorReplica
//
//  Created by Isaac Okura on 7/27/23.
//

import SwiftUI

struct CalculatorButtonStyleViewModifier: ViewModifier {
    let textColor: Color
    let backgroundColor: Color
    let isCircle: Bool

    func innerBody<T: View>(content: T) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Capsule().fill(backgroundColor)
            }
    }

    func body(content: Content) -> some View {
        Group {
            if isCircle {
                innerBody(content: content)
                    .aspectRatio(1, contentMode: .fit)
            } else {
                innerBody(content: Color.clear)
                    .overlay(alignment: .leading) {
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    }
            }
        }
        .font(.largeTitle.weight(.medium))
        .foregroundStyle(textColor)
    }
}

extension View {
    func calculatorButtonStyle(textColor: Color, backgroundColor: Color, isCircle: Bool) -> some View {
        modifier(CalculatorButtonStyleViewModifier(textColor: textColor, backgroundColor: backgroundColor, isCircle: isCircle))
    }
}

enum ButtonType: Hashable {
    case ac, negate, toPercent, divide, multiply, minus, plus, equals, decimal, digit(Int)

    private var text: String? {
        switch self {
        case .ac: "AC"
        case .digit(let int): String(int)
        case .decimal: "."
        default: nil
        }
    }

    private var systemImageName: String? {
        switch self {
        case .negate: "plus.forwardslash.minus"
        case .divide: "divide"
        case .multiply: "multiply"
        case .minus: "minus"
        case .plus: "plus"
        case .equals: "equal"
        case .toPercent: "percent"
        default: nil
        }
    }

    var columnSpan: Int {
        self == .digit(0) ? 2 : 1
    }

    var textColor: Color {
        switch self {
        case .ac, .negate, .toPercent: .black
        default: .white
        }
    }

    var backgroundColor: Color {
        switch self {
        case .ac, .negate, .toPercent: .gray
        case .divide, .multiply, .minus, .plus, .equals: .orange
        default: .secondary
        }
    }

    @ViewBuilder
    var body: some View {
        if let text {
            Text(text)
        } else if let systemImageName {
            Image(systemName: systemImageName)
        }
    }
}

struct ContentView: View {
    static let buttons: [[ButtonType]] = [
        [.ac, .negate, .toPercent, .divide],
        [.digit(7), .digit(8), .digit(9), .multiply],
        [.digit(4), .digit(5), .digit(6), .minus],
        [.digit(1), .digit(2), .digit(3), .plus],
        [.digit(0), .decimal, .equals],
    ]

    static let decimalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter
    }()

    static let scientificNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        return formatter
    }()

    @ObservedObject var viewModel: CalculatorViewModel

    func button(for buttonType: ButtonType) -> some View {
        Button {
            viewModel.performButtonPress(for: buttonType)
        } label: {
            buttonType.body
                .calculatorButtonStyle(textColor: buttonType.textColor, backgroundColor: buttonType.backgroundColor, isCircle: buttonType.columnSpan == 1)
        }
        .gridCellColumns(buttonType.columnSpan)
        .gridCellUnsizedAxes(buttonType.columnSpan > 1 ? .vertical : [])
    }

    var numberFormatter: NumberFormatter {
        viewModel.display >= 1_000_000_000 ? Self.scientificNumberFormatter : Self.decimalNumberFormatter
    }

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(viewModel.display as NSNumber, formatter: numberFormatter)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.system(size: 90, weight: .light))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)

            Grid(horizontalSpacing: 12, verticalSpacing: 10) {
                ForEach(Self.buttons, id: \.self) { buttonRow in
                    GridRow {
                        ForEach(buttonRow, id: \.self) { buttonType in
                            button(for: buttonType)
                        }
                    }
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    ContentView(viewModel: .init())
}
