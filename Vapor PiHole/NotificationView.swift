//
//  NotificationView.swift
//  Vapor PiHole
//
//  Created by Brendan Mosby on 5/28/20.
//  Copyright © 2020 Brendan Mosby. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    var notificationMessage: String
    var notificationColor: Color
    
    var body: some View {
        Text(notificationMessage)
            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
            .foregroundColor(Color.white)
            .background(notificationColor)
            .cornerRadius(15)
    }
}
