//
//  GAmeModel.swift
//  Tic-Tac-Toe
//
//  Created by Валера Черников on 29.08.2022.
//

import SwiftUI

final class GameViewModel : ObservableObject {
    
    let colums : [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    
    @Published  var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published  var isBoardDisabled = false
    @Published  var allertItem : AllertItem?
    
    func processPlayerMove(for position: Int){
        if sqareOcupated(in: moves, for: position) { return }
        moves[position] = Move(player: .human, boarIndex: position)
        
        if checkWinCondition(for: .human, in: moves){
            allertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(im: moves) {
            allertItem = AlertContext.draw
            return
        }
        
        isBoardDisabled = true
        
        //проверить победу или ходить
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determinCompPositionMove(in: moves)
            moves[computerPosition] = Move(player: .comp, boarIndex: computerPosition)
            isBoardDisabled = false
            
            if checkWinCondition(for: .comp, in: moves){
                allertItem = AlertContext.compWin
                return
            }
            
            if checkForDraw(im: moves) {
                allertItem = AlertContext.draw
                return
            }
        }
        
        
        func sqareOcupated(in moves: [Move?], for index: Int) -> Bool {
            return moves.contains(where: {$0?.boarIndex == index})
        }
        
        func determinCompPositionMove(in moves: [Move?]) -> Int {
            
            //If AI can wwin then win
            let winPatterns : Set<Set<Int>> = [[0,1,2], [3, 4, 5], [6, 7, 8] , [0, 3 , 6] , [1, 4, 7], [2, 5, 8] , [2, 4, 6], [0, 4, 8]]
            
            let compMoves = moves.compactMap { $0 }.filter { $0.player == .comp }
            let compPositions = Set(compMoves.map {$0.boarIndex})
            
            for pattern in winPatterns {
                let winPosition = pattern.subtracting(compPositions)
                
                if winPosition.count == 1 {
                    let isAvailable = !sqareOcupated(in: moves, for: winPosition.first!)
                    if isAvailable { return winPosition.first! }
                }
            }
            //if AI cant win than block
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
            let humanPositions = Set(humanMoves.map {$0.boarIndex})
            
            for pattern in winPatterns {
                let winPosition = pattern.subtracting(humanPositions)
                
                if winPosition.count == 1 {
                    let isAvailable = !sqareOcupated(in: moves, for: winPosition.first!)
                    if isAvailable { return winPosition.first! }
                }
            }
            //if cannot block taking middle sqare
            let centerSquare = 4
            if !sqareOcupated(in: moves, for: centerSquare){
                return centerSquare
            }
            
            //if all is not taking random position
            var movePosition = Int.random(in: 0..<9)
            
            while sqareOcupated(in: moves, for: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
            
        }
        
        func checkWinCondition(for player: Player, in moves : [Move?]) -> Bool {
            let winPatterns : Set<Set<Int>> = [[0,1,2], [3, 4, 5], [6, 7, 8] , [0, 3 , 6] , [1, 4, 7], [2, 5, 8] , [1, 4, 7] , [2, 4, 6], [0, 4, 8]]
            
            let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
            let playersPositions = Set(playerMoves.map {$0.boarIndex})
            
            for pattern in winPatterns where pattern.isSubset(of: playersPositions) { return true}
            
            return false
        }
        
        func checkForDraw(im moves: [Move?]) -> Bool {
            return moves.compactMap { $0 }.count == 9
        }
        
    }
    
}
