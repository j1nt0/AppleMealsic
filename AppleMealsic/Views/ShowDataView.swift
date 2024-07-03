//
//  ShowDataView.swift
//  AppleMealsic
//
//  Created by 이진 on 7/4/24.
//

import SwiftUI

struct ShowDataView: View {
    
    @EnvironmentObject var network: Network
    
    @State private var isFavorite: Bool = false
    @State private var timeValue: Double = 0
    
    @Binding var selectedDay: [[Menu]]
    @Binding var today: Date
    @Binding var tomorrow: Date
    @Binding var dayAfterTomorrow: Date
    
    @State private var volumeValue: Double = 40
    @State var selectedNumber = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Color("MusicBasicBackgroundColor")
                VStack(spacing: 0) {
                    // 상단 공백
                    Spacer().frame(height: height*0.15)
                    // 상단 뷰
                    TopView(width: width)
                    // 메뉴 뷰
                    ScrollViewReader { proxy in
                        MenuView(width: width, height: height, time: $timeValue)
                            .onChange(of: timeValue) { newValue in
                                withAnimation {
                                    if newValue == 0 {
                                        proxy.scrollTo("BREAKFAST_A", anchor: .top)
                                    } else if newValue == 1 {
                                        proxy.scrollTo("LUNCH", anchor: .top)
                                    } else if newValue == 2 {
                                        proxy.scrollTo("DINNER", anchor: .top)
                                    }
                                }
                            }
                        // 시간 뷰
                        TimeView(time: $timeValue)
                    }
                    Spacer().frame(height: height*0.05)
                    // 재생 뷰
                    PlayView()
                    Spacer().frame(height: height*0.05)
                    // 음량 뷰
                    SoundView(sound: $volumeValue)
                    Spacer()
                }
                .padding(.horizontal, 32)
                
            }
            .onAppear {
                
                // ex) 20:18
                let nowTime = Calendar.current.date(byAdding: .second, value: 32400, to: Date())!.description.suffix(14).prefix(5)
                print(nowTime)
                // ex) 20.18
                let time2Double = {
                    var temp: Double = 0
                    let tempArray: Array = nowTime.split(separator: ":")
                    temp = Double(tempArray.joined(separator: "."))!
                    
                    return temp
                }()
                
                // 19:30~09:29 조식
                // 9:30~13:29 중식
                // 13:30~19:29 석식
                if time2Double >= 13.30 && time2Double <= 19.29 {
                    timeValue = 2
                } else if time2Double >= 9.30 && time2Double <= 13.29 {
                    timeValue = 1
                } else {
                    timeValue = 0
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func TopView(width: CGFloat) -> some View {
        return HStack(spacing: 0) {
            // image
            RoundedRectangle(cornerRadius: 7)
                .frame(width: 72, height: 72)
            // space
            Spacer().frame(width: width*0.03)
            // name
            VStack(alignment: .leading) {
                switch formatDateString(selectedDay[selectedNumber][0].date.description) {
                case today.description.prefix(10):
                    Text("오늘의 식단")
                        .font(.system(size: 17, weight: .semibold))
                        .lineLimit(1)
                case tomorrow.description.prefix(10):
                    Text("내일의 식단")
                        .font(.system(size: 17, weight: .semibold))
                        .lineLimit(1)
                case dayAfterTomorrow.description.prefix(10):
                    Text("모레의 식단")
                        .font(.system(size: 17, weight: .semibold))
                        .lineLimit(1)
                default:
                    Text("식단")
                        .font(.system(size: 17, weight: .semibold))
                        .lineLimit(1)
                }
                Text("\(formatDateString(selectedDay[selectedNumber][0].date.description))")
                    .font(.system(size: 15, weight: .semibold))
                    .opacity(0.65)
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
            Spacer()
            HStack(spacing: 0) {
                // favorite button
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28)
                        .foregroundStyle(.white)
                        .opacity(isFavorite ? 0.65 : 0.15)
                }
                Spacer().frame(width: width*0.04)
                // etc button
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28)
                        .foregroundStyle(.white)
                        .opacity(0.15)
                }
            }
        }
    }

    func MenuView(width: CGFloat, height: CGFloat, time: Binding<Double>) -> some View {
        return ScrollView {
                VStack(alignment: .listRowSeparatorLeading, spacing: 0) { //network.todaysMenus
                    ForEach(selectedDay[selectedNumber]) { todaysMenu in
                        if time.wrappedValue == 0 {
                            SubView(height: height, todaysMenu: todaysMenu, mealTime: "BREAKFAST_A")
                        } else if time.wrappedValue == 1 {
                            SubView(height: height, todaysMenu: todaysMenu, mealTime: "LUNCH")
                        } else if time.wrappedValue == 2 {
                            SubView(height: height, todaysMenu: todaysMenu, mealTime: "DINNER")
                        }
                    }
                    Spacer().frame(height: height*0.1)
                }
            }
            .foregroundStyle(.white)
            .font(.system(size: 35, weight: .bold))
            .frame(width: width-64, height: height*0.5, alignment: .leading)
            .scrollIndicators(.hidden)
    }
    
    func TimeView(time: Binding<Double>) -> some View {
        return VStack(spacing: 12) {
            Slider(
                    value: time,
                    in: 0...2,
                    step: 1
            )
            .tint(Color(.white).opacity(0.4))
            HStack {
                Text("조식")
                Spacer()
                Text("중식")
                Spacer()
                Text("석식")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
            .opacity(0.4)
        }
    }
    
    func PlayView() -> some View {
        return HStack(spacing: 66) {
            Button {
                if selectedNumber > 0 {
                    selectedNumber -= 1
                }
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            }
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            Button {
                if selectedNumber < 2 {
                    selectedNumber += 1
                }
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            }
        }
        .foregroundStyle(.white)
    }
    
    func SoundView(sound: Binding<Double>) -> some View {
        return VStack {
            HStack {
                Image(systemName: "speaker.fill")
                    .foregroundStyle(.white.opacity(0.4))
                Slider(
                    value: sound,
                    in: 0...100,
                    step: 1
                    
                )
                .tint(.white.opacity(0.4))
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func SubView(height: CGFloat, todaysMenu: Menu, mealTime: String) -> some View {
        Spacer().frame(height: height*0.1)
            .id(todaysMenu.type)
        if todaysMenu.type == mealTime {
            VStack(alignment: .leading) {
                ForEach(todaysMenu.foods) { food in
                    Text(food.name_kor)
                        .blur(radius: 0)
                        .opacity(1)
                    Spacer().frame(height: height*0.03)
                }
            }
        } else {
            VStack(alignment: .leading) {
                ForEach(todaysMenu.foods) { food in
                    Text(food.name_kor)
                        .blur(radius: 2)
                        .opacity(0.5)
                    Spacer().frame(height: height*0.03)
                }
            }
        }
    }
}
