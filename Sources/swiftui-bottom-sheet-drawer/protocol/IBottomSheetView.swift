//
//  IBottomSheetView.swift
//  
//
//  Created by Igor Shelopaev on 26.07.2022.
//

import SwiftUI

public protocol IBottomSheetView : View{
    
    associatedtype V : View
    
    // MARK: - Builder methods
    
    /// Hide dragging button
    func hideDragButton() -> Self
    
    /// Trun off animation
    func withoutAnimation() -> Self
    
    // MARK: - Event methods
    
    /// Handler for changing the sheet position
    func onPositionChanged(_ fn: @escaping (BottomSheetPosition) -> ()) -> V
        
}
