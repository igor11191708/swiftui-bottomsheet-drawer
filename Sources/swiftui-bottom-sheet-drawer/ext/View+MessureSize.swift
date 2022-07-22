//
//  View+MessureSize.swift
//  
//
//  Created by Igor Shelopaev on 22.07.2022.
//

import SwiftUI



public extension View {
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
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
