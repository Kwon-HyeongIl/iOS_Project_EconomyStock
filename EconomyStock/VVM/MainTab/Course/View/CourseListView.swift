//
//  StudyView.swift
//  EconomyStock
//
//  Created by 권형일 on 10/4/24.
//

import SwiftUI

struct CourseListView: View {
    @Environment(CourseListViewCapsule.self) var capsule
    @State private var viewModel = CourseListViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                HStack {
                    Text("학습")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            .frame(height: 100)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.courses) { course in
                        CourseCoverView(course: course)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 5, y: 5)
                            .padding(.bottom, course.type == CourseType.exchangeRateAndBalanceOfPayment ? 70 : 0)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .ignoresSafeArea(edges: .top)
        .onChange(of: capsule.isUpdate) {
            viewModel.updateAllCourses()
        }
        .onAppear {
            // 임시
            viewModel.updateAllCourses()
        }
    }
}

#Preview {
    CourseListView()
        .environment(NavigationRouter())
        .environment(CourseListViewCapsule())
}
