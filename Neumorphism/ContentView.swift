//
//  ContentView.swift
//  NeumorphicButton
//
//  Created by Noah Perkins on 10/23/20.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

extension LinearGradient{
    init(_ colors: Color...){
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct NeumorphicView<S: Shape>: View {
    var isHightlight: Bool
    var shape: S
    var bgColor: Color
    
    var body: some View {
        ZStack {
            if isHightlight{
                shape
                    .fill(bgColor)
                    .overlay(
                        shape
                            .stroke(Color.black, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(shape.fill(LinearGradient(Color.black, Color.clear)))
                            .blendMode(.overlay)
                    )
                    .overlay(
                        shape
                            .stroke(Color.white, lineWidth: 6)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(shape.fill(LinearGradient(Color.clear, Color.black)))
                            .blendMode(.overlay)
                    )
            }
            else{
                shape
                    .shadow(color: Color.black, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white, radius: 10, x: -5, y: -5)
                    .blendMode(.overlay)
                shape
                    .fill(bgColor)
            }
        }
    }
}

struct NeuButtonStyle<S: Shape>: ButtonStyle{
    var color: Color
    var shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(NeumorphicView(isHightlight: configuration.isPressed, shape: shape, bgColor: color))
            .animation(.easeIn(duration: 0.25))
    }
}

struct NeuTextFieldStyle: TextFieldStyle{
    var color: Color
    
    func _body(configuration: TextField<_Label>) -> some View {
            configuration
                .padding(30)
                .accentColor(.blue)
                .background(NeumorphicView(isHightlight: false, shape: RoundedRectangle(cornerRadius: 25), bgColor: color))
        }
}

struct ContentView: View {
    @State var hexColor: String = ""
    @State var color: Color = Color(hex: "ececec")
    
    var body: some View {
        ZStack{
            color
            
            VStack(spacing: 60){
                Button(action: {
                    self.hideKeyboard()
                    if self.hexColor == "" {
                        self.hexColor = "ececec"
                    }
                    self.color = Color(hex: hexColor)
                }, label: {
                    Image(systemName: "touchid")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.blue)
                })
                .buttonStyle(NeuButtonStyle(color: color, shape: Circle()))
                
                
                TextField("Enter Hex Here", text: self.$hexColor)                    .frame(width: 200, height: 25, alignment: .center)
                    .textFieldStyle(NeuTextFieldStyle(color: color))
                    .keyboardType(.default)
            }
        }.edgesIgnoringSafeArea(.all)
        .onTapGesture(count: 1, perform: {
            self.hideKeyboard()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
