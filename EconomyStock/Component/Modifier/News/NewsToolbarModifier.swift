//
//  NewsToolbarModifier.swift
//  EconomyStock
//
//  Created by 권형일 on 1/12/25.
//

import SwiftUI

struct NewsToolbarModifier: ViewModifier {
    @Environment(NavigationRouter.self) var navRouter
    @Environment(NewsListCapsule.self) var newsListCapsule
    @Bindable var viewModel: NewsViewModel
    
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
                        .font(.system(size: 21))
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            switch viewModel.news.type {
                            case .basicEconomy:
                                navRouter.navigate(.ChatbotView(.basicEconomyNews))
                            case .priceLevel:
                                navRouter.navigate(.ChatbotView(.priceLevelNews))
                            case .unEmployment:
                                navRouter.navigate(.ChatbotView(.unEmploymentNews))
                            case .moneyAndFinance:
                                navRouter.navigate(.ChatbotView(.moneyAndFinanceNews))
                            case .exchangeRateAndBalanceOfPayment:
                                navRouter.navigate(.ChatbotView(.exchangeRateAndBalanceOfPaymentNews))
                            }
                        } label: {
                            ZStack {
                                LottieView(fileName: "AIOrb", loopMode: .loop, speed: 1.4, width: 50, height: 50)
                                    .blur(radius: 1.5)
                                
                                Text("AI")
                                    .font(.system(size: 20, design: .rounded).bold())
                                    .foregroundStyle(.white)
                                    .shadow(color: .gray.opacity(0.8), radius: 1, x: 1, y: 1)
                            }
                        }
                        
                        Button {
                            alertExit = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .foregroundStyle(Color.ESTitle)
                        }
                    }
                }
            }
            .alert("정말 나가시겠습니까?", isPresented: $alertExit) {
                Button {
                    loadingBarState = true
                    
                    NewsManager.updateUserNewsPageRoute(type: viewModel.news.type, isEnd: false, currentPage: currentPage)
                    
                    // NewsListViewModel의 updateAllCourses 메서드 호출 (중간 인터페이스로 연결)
                    newsListCapsule.isUpdateToggle.toggle()
        
                    navRouter.popToRoot()
                } label: {
                    Text("확인")
                }
            } message: {
                Text("현재까지 진행한 내용은 자동으로 저장됩니다.")
            }
            .overlay {
                if loadingBarState {
                    LottieView(fileName: "Loading", loopMode: .loop, width: 200, height: 200)
                        .padding(.bottom, 60)
                }
            }
    }
}

