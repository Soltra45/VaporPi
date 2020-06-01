//
//  PiHoleInfo.swift
//  Vapor PiHole
//
//  Created by Brendan Mosby on 5/27/20.
//  Copyright © 2020 Brendan Mosby. All rights reserved.
//

import Combine
import SwiftUI

class ServerInfo: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()

    var ipAddress = "" { didSet {didChange.send()} }
    var apiKey = "" { didSet {didChange.send()} }
}

struct PiHoleInfo: View {
    
    @ObservedObject var serverInfo = ServerInfo()
    
    @State var checkSuccess = false
    @State private var shouldAnimate = false
    @State private var errorShouldAnimate = false
    
    @State var notificationMessage = ""
    @State var notificationColor: Color = Color.red
    
    var body: some View {
        ZStack {
        NavigationView {
                    VStack {
                        NotificationView(notificationMessage: self.notificationMessage, notificationColor: self.notificationColor)
                        .offset(y: self.errorShouldAnimate ?
                            -UIScreen.main.bounds.height/8 :
                            -UIScreen.main.bounds.height)
                            .animation(.interpolatingSpring(mass: 1.0, stiffness: 100, damping: 17, initialVelocity: 0))
                        
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        TextField("IP Address", text: $serverInfo.ipAddress)
                            .font(.title)
                            .padding(.all)
                            .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                            .frame(maxWidth: 350, maxHeight: 40)
                            .cornerRadius(15)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        TextField("API Key", text: $serverInfo.apiKey)
                        .font(.title)
                        .padding(.all)
                        .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                        .frame(maxWidth: 350, maxHeight: 40)
                        .cornerRadius(15)
                        
                        Spacer()
                            .frame(height: 300)
                        
                        Button(action: {
                            self.shouldAnimate = true
                            if (self.serverInfo.ipAddress == "" || self.serverInfo.apiKey == "") {
                                self.notificationMessage = "Empty Field"
                                self.errorShouldAnimate.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.errorShouldAnimate.toggle()
                                    self.shouldAnimate.toggle()
                                }
                            }
                            ApiManagement().CheckForValidIP(ip: self.serverInfo.ipAddress, apiKey: self.serverInfo.apiKey) { checkValue in
                                self.checkSuccess = checkValue
                            }
                            if (self.checkSuccess == false) {
                                self.notificationMessage = "Server Validation Failed"
                                self.errorShouldAnimate.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.errorShouldAnimate.toggle()
                                    self.shouldAnimate.toggle()
                                }
                            }
                        }){
                            HStack {
                                if (shouldAnimate) {
                                    ActivityIndicator(shouldAnimate: self.$shouldAnimate)
                                }
                                else {
                                    Text("Check")
                                    .font(.body)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50.0)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(15)
                        }
                        .sheet(isPresented: $checkSuccess) {PiHoleStats()}
                        
                        Spacer()
                        .frame(height: 20)
                    }
                    .navigationBarTitle(Text("PiHole Info"))
                    .onAppear {
                        if (ApiManagement().LoadUserDefaults()) {
                            self.checkSuccess = true
                            
                    }
                }
            }
        }
    }
}



struct PiHoleInfo_Previews: PreviewProvider {
    static var previews: some View {
        PiHoleInfo()
    }
}
