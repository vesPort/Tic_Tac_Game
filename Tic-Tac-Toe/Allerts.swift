//
//  Allerts.swift
//  Tic-Tac-Toe
//
//  Created by Валера Черников on 28.08.2022.
//

import SwiftUI

struct AllertItem : Identifiable {
    let id = UUID()
    var title : Text
    var message : Text
    var buttonTitle : Text
    
}

struct AlertContext {
    static let humanWin = AllertItem(title: Text("You win"),
                              message: Text("You beat your own AI"),
                              buttonTitle: Text("Hell yeah"))
    
    static let compWin = AllertItem(title: Text("AI win"),
                              message: Text("Looser"),
                              buttonTitle: Text("Rematch"))
    
    static let draw = AllertItem(title: Text("Draw"),
                              message: Text("You beat your own AI"),
                              buttonTitle: Text("Try again"))
}
