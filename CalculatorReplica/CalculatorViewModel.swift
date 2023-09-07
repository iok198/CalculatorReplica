//
//  CalculatorViewModel.swift
//  CalculatorReplica
//
//  Created by Isaac Okura on 7/28/23.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    @Published var value = 0.0
    @Published var answer = 0.0
    @Published var isEditingValue = false
    @Published var isEditingDecimal = false
    @Published var numberOfDecimals = 0

    enum Action {
        case divide, multiply, minus, plus, none
    }

    var currentAction: Action = .none

    var display: Double  {
        currentAction == .none || isEditingValue ? value : answer
    }

    func perform(action: Action) {
        guard isEditingValue else { return }

        switch action {
        case .divide:
            answer /= value
        case .multiply:
            answer *= value
        case .minus:
            answer -= value
        case .plus:
            answer += value
        case .none:
            answer = value
        }

        value = 0
        isEditingValue = false
        isEditingDecimal = false
        numberOfDecimals = 0
    }

    func performButtonPress(for buttonType: ButtonType) {
        switch buttonType {
        case .ac:
            value = 0
            answer = 0
            currentAction = .none
            isEditingValue = false
            isEditingDecimal = false
            numberOfDecimals = 0
        case .negate:
            if isEditingValue {
                value.negate()
            } else {
                answer.negate()
            }
        case .toPercent:
            if isEditingValue {
                value /= 100
            } else {
                answer /= 100
            }
        case .divide:
            perform(action: currentAction)
            currentAction = .divide
        case .multiply:
            perform(action: currentAction)
            currentAction = .multiply
        case .minus:
            perform(action: currentAction)
            currentAction = .minus
        case .plus:
            perform(action: currentAction)
            currentAction = .plus
        case .equals:
            perform(action: currentAction)
        case .decimal:
            isEditingDecimal = true
        case .digit(let int):
            isEditingValue = true
            print("Pre: \(value)")
            if isEditingDecimal {
                numberOfDecimals += 1
                value += Double(int) / pow(10, Double(numberOfDecimals))
            } else {
                value = (value * 10) + Double(int)
            }
            print("Post: \(value)")
        }
    }
}
