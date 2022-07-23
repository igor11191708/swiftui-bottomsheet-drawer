//
//  SizePreferenceKey.swift
//  
//
//  Created by Igor Shelopaev on 22.07.2022.
//

import SwiftUI

/// Key for emerging size
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public struct SizePreferenceKey: PreferenceKey {
    
    public static var defaultValue = CGSize(width: 0, height: 0)
    
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
