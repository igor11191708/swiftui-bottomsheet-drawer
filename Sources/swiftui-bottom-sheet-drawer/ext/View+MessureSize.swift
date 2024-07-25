//
//  View+MessureSize.swift
//  
//
//  Created by Igor Shelopaev on 22.07.2022.
//

import SwiftUI



public extension View {
    
    /// Messure a container size
    /// - Parameter fn: callback
    /// - Returns: View
    @available(iOS 15.0, macOS 12.0, watchOS 10.0, *)
    func messureSize(_ fn: @escaping (CGSize) -> Void) -> some View {
        overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                    .onPreferenceChange(SizePreferenceKey.self, perform: {
                        fn($0)
                    })
            }, alignment: .topLeading
        )
    }
}
