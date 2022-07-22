//
//  BottomSheetPosision.swift
//  
//
//  Created by Igor Shelopaev on 22.07.2022.
//

import SwiftUI


/// Three level positions for sheet drawer
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public enum BottomSheetPosision: Comparable{
    
    case up(CGFloat)
    
    case middle(CGFloat)
    
    case down(CGFloat)
    
    public func update(height : CGFloat) -> Self{
        switch self{
        case .up(_): return .up(height)
        case .middle(_): return .middle(height)
        case .down(_): return .down(height)
        }
    }
    
    /// Check is up position
    public var isUp: Bool{
        if case .up(_) = self{
            return true
        }
        
        return false
    }
       
    /// Check is middle position
    public var isModdle: Bool{
        if case .middle(_) = self{
            return true
        }
        
        return false
    }
           
    /// Check is down position
    public var isDown: Bool{
        if case .down(_) = self{
            return true
        }
        
        return false
    }
        
    /// Get currently avalable height
    public var getHeight : CGFloat{
        switch self{
        case .up(let height): return height
        case .middle(let height): return height
        case .down(let height): return height
        }
    }
}
