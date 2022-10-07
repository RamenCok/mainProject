//
//  RadioButton.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import UIKit
import Foundation

class RadioButtonManager<T: UIView>
{
    public var onSelected: (T) -> Void
    public var onDeselect: (T) -> Void
    public var buttons: [T]
    
    private let indexOfNoneSelected: Int = -1
    
    public var selectedIndex: Int {
        didSet {
            if (!isOutOfBounds(oldValue)) { onDeselect(buttons[oldValue]) }
            if (!isOutOfBounds(selectedIndex)) { onSelected(buttons[selectedIndex]) }
        }
    }
    
    public var selected: T? {
        get {
            if (isOutOfBounds(selectedIndex)) { return nil }
            return buttons[selectedIndex]
        }
        set {
            guard let newValue = newValue
            else { return }
            selectedIndex = buttons.firstIndex(of: newValue) ?? indexOfNoneSelected
        }
    }
    
    public init(_ buttons: [T], onSelected: @escaping (T) -> Void, onDeselect: @escaping (T) -> Void)
    {
        self.onSelected     = onSelected
        self.onDeselect     = onDeselect
        self.buttons        = buttons
        self.selectedIndex  = indexOfNoneSelected
    }
    
    private func isOutOfBounds(_ index: Int) -> Bool
    {
        return index < 0 || index >= buttons.count
    }
}

