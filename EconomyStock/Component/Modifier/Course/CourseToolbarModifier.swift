//
//  CourseToolbarModifier.swift
//  EconomyStock
//
//  Created by 권형일 on 10/11/24.
//

import SwiftUI

struct CourseToolbarModifier: ViewModifier {
    @Environment(NavigationRouter.self) var navigationRouter
    @Environment(CourseListViewModel.self) var courseListViewModel
    @Bindable var viewModel: CourseViewModel
    
    @State private var alertExit = false
    @State private var loadingBarState = false
    
    let currentPage: Int
    let totalPage: Int
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(currentPage) / \(totalPage)")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        alertExit = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .foregroundStyle(Color.ESTitle)
                    }
                }
            }
            .alert("정말 나가시겠습니까?", isPresented: $alertExit) {
                Button {
                    withAnimation(.smooth(duration: 0.2)) {
                        loadingBarState = true
                    }
                    
                    // 로컬 currentUser의 basicEconomyLastPage 값 바꾸고, CourseViewModel의 updateCourses() 호출
                    switch viewModel.course.type {
                        
                    case .basicEconomy:
                        AuthManager.shared.currentUser?.studyingCourse.basicEconomyLastPage = currentPage
                        courseListViewModel.updateBasicEconomyCourse()
                        
                    case .priceLevel:
                        AuthManager.shared.currentUser?.studyingCourse.priceLevelLastPage = currentPage
                        courseListViewModel.updatePriceLevelCourse()
                    }
                    
                    // DB User의 basicEconomyLastPage 값 바꾸기
                    Task {
                        await AuthManager.shared.updateCourseLastPage(courseType: viewModel.course.type, lastPage: currentPage)
                    }
                    
                    navigationRouter.popToRoot()
                } label: {
                    Text("확인")
                }
            } message: {
                Text("현재까지 진행한 내용은 자동으로 저장됩니다.")
            }
            .overlay {
                if loadingBarState {
                    LottieViewConverter(fileName: "Loading", loopMode: .loop, width: 180, height: 180)
                        .padding(.bottom, 60)
                }
            }
    }
}
