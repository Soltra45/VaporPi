//
//  PiHoleStats.swift
//  Vapor PiHole
//
//  Created by Brendan Mosby on 5/27/20.
//  Copyright © 2020 Brendan Mosby. All rights reserved.
//

import SwiftUI

struct PiHoleStats: View {
    
    @State private var showingActionSheet = false
    @State private var notificationShouldAnimate = false
    
    @State var notificationMessage = ""
    @State var notificationColor: Color = Color.blue
    
    @State var checkSuccess = false
    
    @State var totalQueries = ""
    @State var queriesBlocked = ""
    @State var percentBlocked = ""
    @State var domainsOnBlockList = ""
    
    var body: some View {
        NavigationView {
            VStack {
                NotificationView(notificationMessage: self.notificationMessage, notificationColor: self.notificationColor)
                .offset(y: self.notificationShouldAnimate ?
                    -UIScreen.main.bounds.height/8 :
                    -UIScreen.main.bounds.height)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100, damping: 17, initialVelocity: 0))
                //Color.white
                //    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
                        .cornerRadius(15)
                    
                    VStack {
                        Text("Total Queries")
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                            .frame(height: 10)
                        Text(totalQueries)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
                        .cornerRadius(15)
                    VStack {
                        Text("Queries Blocked")
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                            .frame(height: 10)
                        Text(queriesBlocked)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                ZStack {
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
                        .cornerRadius(15)
                    VStack {
                        Text("Percent Blocked")
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                            .frame(height: 10)
                        Text("\(percentBlocked)%")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                ZStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
                        .cornerRadius(15)
                    VStack {
                        Text("Domains on Blocklist")
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                            .frame(height: 10)
                        Text(domainsOnBlockList)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
                
                Spacer()
                    .frame(minHeight: 40, maxHeight: 80)
                
                VStack {
                    Button(action: {
                        self.showingActionSheet = true
                    }){
                        HStack {
                            Text("Disable")
                                .font(.body)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50.0)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(15)
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Disable PiHole"), message: Text("Select amount of time to disable your PiHole"), buttons: [
                        .default(Text("30 Seconds")) {
                            ApiManagement().DisablePiHole(seconds: 30) { checkDisable in
                                self.checkSuccess = checkDisable
                                
                                if (self.checkSuccess) {
                                    self.notificationMessage = "PiHole disabled for 30 seconds"
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                                else {
                                    self.notificationMessage = "Unable to disable PiHole"
                                    self.notificationColor = Color.red
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                            }
                            
                        },
                        .default(Text("5 Minutes")) {
                            ApiManagement().DisablePiHole(seconds: 300) { checkDisable in
                                self.checkSuccess = checkDisable
                                
                                if (self.checkSuccess) {
                                    self.notificationMessage = "PiHole disabled for 5 minutes"
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                                else {
                                    self.notificationMessage = "Unable to disable PiHole"
                                    self.notificationColor = Color.red
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                            }
                        },
                        .default(Text("10 Minutes")) {
                            ApiManagement().DisablePiHole(seconds: 600) { checkDisable in
                                self.checkSuccess = checkDisable
                                
                                if (self.checkSuccess) {
                                    self.notificationMessage = "PiHole disabled for 10 minutes"
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                                else {
                                    self.notificationMessage = "Unable to disable PiHole"
                                    self.notificationColor = Color.red
                                    self.notificationShouldAnimate.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.notificationShouldAnimate.toggle()
                                    }
                                }
                            }
                        },
                        .cancel()
                    ])
                }
            }
            .navigationBarTitle(Text("PiHole Stats"))
            .onAppear {
                ApiManagement().GetTotalQueries() { queriesValue in
                    self.totalQueries = queriesValue
                }
                ApiManagement().GetQueriesBlocked() { queriesValue in
                    self.queriesBlocked = queriesValue
                }
                ApiManagement().GetPercentBlocked() { queriesValue in
                    self.percentBlocked = queriesValue
                }
                ApiManagement().GetDomainsOnBlockList() { queriesValue in
                    self.domainsOnBlockList = queriesValue
                }
            }
        }
    }
}

struct PiHoleStats_Previews: PreviewProvider {
    static var previews: some View {
        PiHoleStats()
    }
}
