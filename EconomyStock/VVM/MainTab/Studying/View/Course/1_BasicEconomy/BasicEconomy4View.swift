//
//  BasicEconomyPage4.swift
//  EconomyStock
//
//  Created by 권형일 on 10/10/24.
//

import SwiftUI

struct BasicEconomy4View: View {
    @Environment(NavigationRouter.self) var navigationRouter
    @Bindable var viewModel: CourseViewModel
    
    var body: some View {
        VStack {
            
        }
        .modifier(CourseToolbarModifier(viewModel: viewModel, currentPage: viewModel.currentPage, totalPage: viewModel.course.totalPage))
    }
}

#Preview {
    BasicEconomy4View(viewModel: CourseViewModel(course: .DUMMY_COURSE))
        .environment(NavigationRouter())
}
