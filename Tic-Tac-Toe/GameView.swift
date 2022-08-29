//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Валера Черников on 28.08.2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.colums, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            GameCircleView(proxy: geometry)
                            PlayerIndicator(systemImageName:  viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i )
                        }
                        
                    }
                }
                Spacer()
            }
        }
        .disabled(viewModel.isBoardDisabled)
        .padding()
        .alert(item: $viewModel.allertItem, content: { allertItem in
            Alert(title: allertItem.title,
                  message: allertItem.message,
                  dismissButton: .default(allertItem.buttonTitle, action: { viewModel.moves = Array(repeating: nil, count: 9) }))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
enum Player{
    case human, comp
}

struct Move{
    let player : Player
    let boarIndex : Int
    
    var indicator : String {
        player == . human ? "xmark" : "circle"
    }
}


struct GameCircleView: View {
    
    var proxy : GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.black)
            .frame(width: proxy.size.width/3 - 15 , height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName : String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(.white)
    }
}
