//
//  AccountView.swift
//  EconomyStock
//
//  Created by 권형일 on 12/7/24.
//

import SwiftUI

struct AccountInfoView: View {
    @Environment(NavigationRouter.self) var navRouter
    @Environment(LoginCapsule.self) var capsule
    @Bindable var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Text("닉네임")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        navRouter.navigate(.UpdateUsernameView(viewModel))
                    } label: {
                        Text("\(viewModel.remoteUser?.username ?? "")")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .padding(.leading, 3)
                            .padding(.trailing)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("시작한 날짜")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Text("\(viewModel.formattedStartDate)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .padding(.trailing, 35)
                }
                
                Divider()
                
                HStack {
                    Text("연동된 소셜 계정")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    switch viewModel.loginType {
                    case .apple:
                        Image("Apple_Logo_Black")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.trailing, 35)
                        
                    case .google:
                        Image("Google_Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.trailing, 35)
                        
                    case .kakao:
                        Image("Kakao_Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.trailing, 35)
                        
                    case .basic:
                        Text("-")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .padding(.trailing, 35)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.gray.opacity(0.3))
            }
            .shadow(color: .gray.opacity(0.1), radius: 3, x: 3, y: 3)
            .padding()
            .padding(.top, 1)
            
            Button {
                viewModel.singOut()
                capsule.isLoginToggle.toggle()
            } label: {
                Text("로그아웃")
                    .font(.system(size: 13))
                    .padding(.top, 50)
            }
        }
        .scrollIndicators(.never)
        .modifier(NavigationBackTitleModifier(title: "계정 정보"))
    }
}

#Preview {
    AccountInfoView(viewModel: ProfileViewModel())
        .environment(NavigationRouter())
        .environment(LoginCapsule())
}
