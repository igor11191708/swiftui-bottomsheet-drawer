//
//  BottomSheetPosisionKey.swift
//  
//
//  Created by Igor Shelopaev on 22.07.2022.
//

import SwiftUI

/// Key for emerging drawer sheet position
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public struct BottomSheetPosisionKey: PreferenceKey {
    
    static public var defaultValue: BottomSheetPosision = .down(0)

    static public func reduce(value: inout BottomSheetPosision, nextValue: () -> BottomSheetPosision) {
        value = nextValue()
    }
}
