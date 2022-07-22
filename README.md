# Multiplatform (iOS, macOS) SwiftUI bottom sheet drawer

 ## Features
- [x] Customize component with your own specs
- [x] iOS and macOS support
- [x] **dark** and **light** scheme support
- [x] Observing sheet positions on change if you need to react on it
- [x] Responsive for any size change It's important for macOS while window size changing

## 1. Create

Put the component into a absolute coordinate space like ZStack or GeometryReader and 
just pass a content that's it to start with sheet drawer

```swift
        BottomSheet(
            content: ContentView()
        )
```

### Optional

* `shift` - Visible height of the sheet drawer
* `topIndentation` - Space from the very top to the max height drawer can reach
* `showDragButton` - Hide or show drag button
* `draggerHeight` - Space sensitive for dragging
* `dragThresholdToAct` - Dragging length after which trigger move to the next level depends on the direction of moving
* `doAnimation` - Animate move


### Observing sheet positions
Possition is passed with **height** of the sheet 
**height** - is enum associated value of CGFloat

```swift

    @State private var position: BottomSheetPosision
    
        BottomSheet(
            content: SheetCintentView(position: $position)
        )
        .onPreferenceChange(BottomSheetPosisionKey.self) {
            position = $0
        }
```

| Position | Description |
| --- | --- |
|**up**| At the top |
|**middle**| At the middle |
|**down**| At the bottom |

## SwiftUI example of using package

[![click to watch expected UI behavior for the example](https://github.com/The-Igor/d3-stories-instagram/blob/main/img/img_01.gif)](https://youtu.be/jLu7gbzGXTo)

[![click to watch expected UI behavior for the example](https://github.com/The-Igor/d3-stories-instagram/blob/main/img/img_08.gif)](https://youtu.be/jLu7gbzGXTo)



## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

