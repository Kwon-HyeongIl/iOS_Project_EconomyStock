//
//  ChatbotAIView.swift
//  EconomyStock
//
//  Created by 권형일 on 12/7/24.
//

import SwiftUI
import Combine

struct ChatbotView: View {
    @Environment(NavigationRouter.self) var navRouter
    @State private var viewModel: ChatbotViewModel
    
    @State private var position = ScrollPosition()
    @State private var isAtBottom = false
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var userChatIndex = 0
    @State private var bottomHeight: CGFloat = 0
    
    @State private var alertLogin = false
    
    init(type: ChatbotEntranceType) {
        self.viewModel = ChatbotViewModel(type: type)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ZStack {
                                LottieView(fileName: "AIOrb", loopMode: .loop, speed: 1.4, width: 160, height: 160)
                                    .blur(radius: 1.5)
                                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5)
                                
                                Image("Chatbot_Toktok")
                                    .resizable()
                                    .frame(width: 95, height: 90)
                            }
                            
                            VStack(spacing: 20) {
                                ForEach(viewModel.messages) { message in
                                    HStack {
                                        if message.isUser {
                                            Spacer()
                                            
                                            ChatBubbleView(text: message.text, isUser: true)
                                                .padding(.trailing)
                                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
                                                .id(message.id)
                                                .onAppear {
                                                    self.bottomHeight = min(self.bottomHeight + 500, 500)
                                                    withAnimation {
                                                        proxy.scrollTo(message.id, anchor: .top)
                                                    }
                                                }
                                            
                                        } else {
                                            ChatBubbleView(text: message.text, isUser: false)
                                                .padding(.leading)
                                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
                                                .onChange(of: viewModel.isChatEnd) {
                                                    withAnimation {
                                                        self.bottomHeight = max(self.bottomHeight - 500, 0)
                                                    }
                                                }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onChange(of: geometry.frame(in: .named("scroll")).maxY) {
                                            let scrollViewHeight = UIScreen.main.bounds.height - keyboardHeight - 20
                                            
                                            let isCurrentlyAtBottom = geometry.frame(in: .global).maxY <= scrollViewHeight
                                            
                                            isAtBottom = isCurrentlyAtBottom
                                        }
                                }
                            )
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: bottomHeight)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .coordinateSpace(name: "scroll")
                    .scrollIndicators(.never)
                    .scrollPosition($position)
                }
                
                VStack {
                    Spacer()
                    
                    if !isAtBottom {
                        Button {
                            withAnimation {
                                position.scrollTo(edge: .bottom)
                            }
                        } label: {
                            Image(systemName: "arrowshape.down.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.regularMaterial)
                                .padding(.bottom, 5)
                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            HStack {
                TextField(viewModel.isLogin ? "질문을 입력해주세요" : "로그인이 필요한 서비스입니다", text: $viewModel.prompt, axis: .vertical)
                    .font(.system(size: 15))
                    .padding(.vertical)
                    .padding(.leading)
                
                Button {
                    if viewModel.isLogin {
                        Task {
                            await viewModel.requestChatbot()
                        }
                        
                    } else {
                        self.alertLogin = true
                    }
                } label: {
                    Circle()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color.ESTitle)
                        .overlay {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.white)
                                .fontWeight(.black)
                                .scaleEffect(1.1)
                                .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
                        }
                        .padding(.leading, 5)
                        .padding(.trailing)
                        .padding(.vertical, 5)
                        .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .alert("경고", isPresented: $alertLogin) {
                    Button {
                        navRouter.navigate(.LoginView)
                    } label: {
                        Text("확인")
                    }
                } message: {
                    Text("로그인이 필요한 서비스입니다.")
                }
            }
            .background(.regularMaterial)
            .cornerRadius(20, corners: .allCorners)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
            
        }
        .modifier(NavigationBackModifier())
        .background(LottieView(fileName: "AIBackground", loopMode: .loop, scale: 1.8, width: 300, height: 530)
            .opacity(0.4))
        .onReceive(Publishers.keyboardHeight) { height in
            self.keyboardHeight = height
        }
        .onTapGesture {
            // 키보드 내리기
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    ChatbotView(type: .main)
        .environment(NavigationRouter())
}
