//
//  CourseIntroView.swift
//  EconomyStock
//
//  Created by 권형일 on 10/10/24.
//

import SwiftUI

struct CourseIntroView: View {
    @Environment(NavigationRouter.self) var navigationRouter
    @Bindable var viewModel: CourseViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LottieViewConverter(fileName: viewModel.course.lottieFileName, loopMode: .loop, width: 200, height: 200)
                
                HStack {
                    Text(viewModel.course.title)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.bottom)
                    
                    ProgressCircleView(progressRate: viewModel.course.progressRate)
                        .padding(.bottom)
                }
                
                Button {
                    var courseDestination: NavigationStackPath
                    
                    switch viewModel.course.number {
                        
                    case "I":
                        courseDestination = .BasicEconomy1View(viewModel)
                    case "II":
                        courseDestination = .PriceLevel1View(viewModel)
                        
                    default:
                        return
                    }
                    
                    navigationRouter.navigate(courseDestination)
                } label: {
                    Text("시작하기")
                        .modifier(ShortButtonModifier())
                        .padding(.bottom, 30)
                }
                
                VStack {
                    Text(viewModel.course.description)
                }
                .modifier(TileModifier(height: 400))
            }
        }
        .modifier(NavigationBackHomeModifier())
        .scrollIndicators(.never)
        .environment(viewModel)
    }
}

#Preview {
    CourseIntroView(viewModel: CourseViewModel(course: .DUMMY_COURSE))
        .environment(NavigationRouter())
        .environment(MainTabCapsule())
}
