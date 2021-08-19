//
//  TimerBootcamp.swift
//  MissionValleySwiftUI
//
//  Created by Paul Grovum on 8/18/21.
//

import SwiftUI

struct TimerBootcamp: View {
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.5, green: 0.9, blue: 0.9), Color(red: 0.1, green: 0.1, blue: 0.9)]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 500)
                    .ignoresSafeArea()
            
            Text("Hi")
                .font(.system(size:88, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
    }
}

struct TimerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TimerBootcamp()
    }
}
