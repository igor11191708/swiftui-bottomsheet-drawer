//
//  Comparable+clamped.swift
//  
//
//  Created by Igor Shelopaev on 21.07.2022.
//

import Foundation

extension Comparable {
    
    /// Restrain value to range limits
    /// - Parameters:
    ///   - lower: lower limit
    ///   - upper: upper limit
    /// - Returns: Clammed value
    func clamped(_ lower: Self, _ upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
}
