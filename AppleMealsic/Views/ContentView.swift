//
//  ContentView.swift
//  AppleMealsic
//
//  Created by 이진 on 7/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var network: Network
    
    @State var today = Date()
    @State var tomorrow = Date()
    @State var dayAfterTomorrow = Date()
    
    @State var selectedDay: [[Menu]] = []
    
    var body: some View {
        ZStack {
            if selectedDay.isEmpty {
                ProgressView()
            } else {
                ShowDataView(selectedDay: $selectedDay, today: $today, tomorrow: $tomorrow, dayAfterTomorrow: $dayAfterTomorrow)
            }
        }
        .onAppear {
            today = Calendar.current.date(byAdding: .second, value: 32400, to: Date())!
            tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!
            network.getMenus(of: today)
            network.getMenus(of: tomorrow)
            network.getMenus(of: dayAfterTomorrow)
            // 위 함수들의 작업 시간이 조금 걸리기때문에 2초동안 시간을 준다. 1초로 설정하면 그 안에 못불러오기때문에 무한 프로세스뷰
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                selectedDay = [network.todaysMenus, network.tomorrowsMenus, network.dayAfterTomorrowMenus]
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
