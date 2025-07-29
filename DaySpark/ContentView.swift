//
//  ContentView.swift
//  DaySpark
//
//  Created by 89 on 2025/7/19.
//

import SwiftUI

// AnniversaryItem 数据结构
struct AnniversaryItem: Identifiable {
    let id: UUID
    let event: String
    let date: Date
    let color: Color
    let icon: String
    var isPinned: Bool = false // 添加置顶状态
}

// HeaderView 组件
struct HeaderView: View {
    let mainGradient: LinearGradient
    let buttonGradient: LinearGradient
    let onAddButtonTapped: () -> Void
    
    var body: some View {
        HStack {
            Text("DaySpark")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.3), radius: 2, x: 0, y: 2)
            Spacer()
            Button(action: onAddButtonTapped) {
                ZStack {
                    buttonGradient
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .frame(height: 56)
        .background(
            mainGradient
                .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.10), radius: 8, x: 0, y: 4)
        )
    }
}

// MainContentView 组件
struct MainContentView: View {
    let anniversaryItems: [AnniversaryItem]
    let cardSpacing: CGFloat
    let cardAreaCornerRadius: CGFloat
    let floatingButtonSize: CGFloat
    let floatingButtonPadding: CGFloat
    let onEdit: (AnniversaryItem) -> Void
    let onDelete: (AnniversaryItem) -> Void
    let onPin: (AnniversaryItem) -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .cornerRadius(cardAreaCornerRadius, corners: [.topLeft, .topRight])
                .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.10), radius: 8, x: 0, y: -4)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: cardSpacing) {
                                            ForEach(anniversaryItems) { item in
                            AnniversaryCardView(
                                item: item,
                                onEdit: { onEdit(item) },
                                onDelete: { onDelete(item) },
                                onPin: { onPin(item) }
                            )
                        }
                }
                .padding(.top, 24)
                .padding(.horizontal)
                .padding(.bottom, floatingButtonSize + floatingButtonPadding + 50)
            }
        }
    }
}

// FloatingButtonView 组件
struct FloatingButtonView: View {
    let buttonGradient: LinearGradient
    let floatingButtonSize: CGFloat
    let floatingButtonPadding: CGFloat
    let isAnimatingButton: Bool
    let onButtonTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: onButtonTapped) {
                    ZStack {
                        buttonGradient
                            .frame(width: floatingButtonSize, height: floatingButtonSize)
                            .clipShape(Circle())
                            .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.18), radius: 10, x: 0, y: 6)
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 8)
                            .frame(width: floatingButtonSize + 16, height: floatingButtonSize + 16)
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                    }
                    .scaleEffect(isAnimatingButton ? 1.25 : 1.0)
                    .rotationEffect(.degrees(isAnimatingButton ? 20 : 0))
                    .opacity(isAnimatingButton ? 0.7 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.45), value: isAnimatingButton)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, floatingButtonPadding)
                .padding(.bottom, 32)
                .accessibilityLabel("抽签")
            }
        }
    }
}

// EncourageCardView 组件
struct EncourageCardView: View {
    let encourageText: String
    let cardAnim: Bool
    let cardGlow: Bool
    let cardContentAppear: Bool
    let buttonOpacity: Double
    let onDismiss: () -> Void
    
    var body: some View {
        VisualEffectBlur(blurStyle: .systemMaterial)
            .ignoresSafeArea()
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.25), value: true)
            .onTapGesture {
                onDismiss()
            }
        VStack {
            Spacer()
            // 卡片本体动效
            ZStack {
                // 光晕扩散
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.95, blue: 0.7, opacity: 0.7), Color.clear]), center: .center, startRadius: 0, endRadius: 320)
                    )
                    .frame(width: 420, height: 420)
                    .scaleEffect(cardGlow ? 1.18 : 0.7)
                    .opacity(cardGlow ? 0.8 : 0)
                    .blur(radius: 24)
                    .animation(.easeOut(duration: 0.7), value: cardGlow)
                // 裱起来的画框卡片
                ZStack {
                    // 外层金色描边
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.98, green: 0.85, blue: 0.45),
                                    Color(red: 0.95, green: 0.8, blue: 0.5)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 6
                        )
                        .shadow(color: Color.yellow.opacity(0.18), radius: 8, x: 0, y: 4)
                        .frame(width: 240, height: 180)
                    // 内层卡片本体
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.976, blue: 0.941),
                                    Color(red: 1.0, green: 0.898, blue: 0.705)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color(red: 0.9, green: 0.8, blue: 0.5, opacity: 0.18), radius: 24, x: 0, y: 12)
                        .frame(width: 240, height: 180)
                        .overlay(
                            // 四角装饰
                            ZStack {
                                ForEach(0..<4) { i in
                                    Image(systemName: "leaf.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                                        .rotationEffect(.degrees(Double(i) * 90))
                                        .offset(x: i == 1 ? 110 : (i == 3 ? -110 : 0), y: i == 0 ? -70 : (i == 2 ? 70 : 0))
                                }
                            }
                        )
                    // 卡片内容
                    VStack(spacing: 8) {
                        Text("\u{201C}")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                            .padding(.top, 2)
                        Text(encourageText)
                            .font(.system(size: 26, weight: .semibold, design: .serif))
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.7, green: 0.4, blue: 0.2))
                            .lineSpacing(6)
                            .padding(.horizontal, 8)
                            .opacity(cardContentAppear ? 1 : 0)
                            .animation(.easeIn(duration: 0.45).delay(0.22), value: cardContentAppear)
                        Text("\u{201D}")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                            .padding(.bottom, 2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 10)
                    .frame(width: 240, height: 180)
                }
                .frame(width: 240, height: 180)
                .scaleEffect(cardAnim ? 1 : 0.7)
                .rotationEffect(.degrees(cardAnim ? 0 : -16))
                .opacity(cardAnim ? 1 : 0)
                .animation(.interpolatingSpring(stiffness: 180, damping: 16), value: cardAnim)
            }
            // 按钮只做opacity淡出
            HStack(spacing: 28) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享")
                    }
                    .font(.title3)
                    .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
                .opacity(buttonOpacity)
                .animation(.easeInOut(duration: 0.25), value: buttonOpacity)
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("保存")
                    }
                    .font(.title3)
                    .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
                .opacity(buttonOpacity)
                .animation(.easeInOut(duration: 0.25), value: buttonOpacity)
            }
            .padding(.top, 12)
            Spacer()
        }
        .onAppear {
            // 动画初始化逻辑需要在父组件中处理
        }
    }
}



struct ContentView: View {
    let barCornerRadius: CGFloat = 0 // 标题栏无圆角
    let cardAreaCornerRadius: CGFloat = 16 // 纪念日区域顶部圆角
    let cardSpacing: CGFloat = 20   
    let cardCount = 8 // 用于演示超出滚动
    let floatingButtonSize: CGFloat = 56
    let floatingButtonPadding: CGFloat = 24
    // 温馨奶油渐变色
    let mainGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.855, blue: 0.725), // #FFDAB9 粉橙/蜜桃
            Color(red: 1.0, green: 0.898, blue: 0.705), // #FFE5B4 奶油橙
            Color(red: 1.0, green: 0.968, blue: 0.839)  // #FFF7D6 浅米黄
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 1.0, green: 0.976, blue: 0.941) // #FFF9F0 淡米白
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.855, blue: 0.725), // #FFDAB9
            Color(red: 1.0, green: 0.898, blue: 0.705)  // #FFE5B4
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    @State private var showEncourageCard = false
    @State private var encourageText = ""
    @State private var isAnimatingButton = false
    @State private var cardAnim = false
    @State private var cardGlow = false
    @State private var cardContentAppear = false
    @State private var buttonOpacity: Double = 1
    // 临时鼓励语
    let encourages = [
        "你很棒！",
        "再坚持一下，明天会更好！",
        "相信自己，你值得被爱。",
        "每一天都值得期待。",
        "你的努力终将被看到。",
        "温柔以待自己。",
        "别怕，阳光总在风雨后。"
    ]
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var editingItem: AnniversaryItem?

    @State private var anniversaryItems: [AnniversaryItem] = [
        AnniversaryItem(id: UUID(), event: "生日", date: Date().addingTimeInterval(86400 * 2), color: .orange, icon: "🎂"),
        AnniversaryItem(id: UUID(), event: "元旦", date: Date().addingTimeInterval(86400 * 10), color: .blue, icon: "🎉")
    ]
    func cardAreaHeight(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.height * 0.72, 320)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    // 顶部标题栏
                    HeaderView(
                        mainGradient: mainGradient,
                        buttonGradient: buttonGradient,
                        onAddButtonTapped: {
                            showAddSheet = true
                        }
                    )
                    .padding(.top, geometry.safeAreaInsets.top)
                    // 分割线更淡
                    Rectangle()
                        .fill(Color(red: 1.0, green: 0.976, blue: 0.941, opacity: 0.5))
                        .frame(height: 1)
                        .shadow(color: Color.clear, radius: 0)
                    // 纪念日区域最大化
                    MainContentView(
                        anniversaryItems: anniversaryItems,
                        cardSpacing: cardSpacing,
                        cardAreaCornerRadius: cardAreaCornerRadius,
                        floatingButtonSize: floatingButtonSize,
                        floatingButtonPadding: floatingButtonPadding,
                        onEdit: { item in
                            editingItem = item
                            showEditSheet = true
                        },
                        onDelete: { item in
                            if let index = anniversaryItems.firstIndex(where: { $0.id == item.id }) {
                                anniversaryItems.remove(at: index)
                            }
                        },
                        onPin: { item in
                            // 置顶/取消置顶功能
                            if let index = anniversaryItems.firstIndex(where: { $0.id == item.id }) {
                                var updatedItem = anniversaryItems[index]
                                
                                if updatedItem.isPinned {
                                    // 取消置顶：移除置顶状态，移到列表末尾
                                    updatedItem.isPinned = false
                                    anniversaryItems.remove(at: index)
                                    anniversaryItems.append(updatedItem)
                                } else {
                                    // 置顶：标记为已置顶，移到数组开头
                                    updatedItem.isPinned = true
                                    anniversaryItems.remove(at: index)
                                    anniversaryItems.insert(updatedItem, at: 0)
                                }
                            }
                        }
                    )
                    .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.top)
                // 悬浮抽签按钮
                FloatingButtonView(
                    buttonGradient: buttonGradient,
                    floatingButtonSize: floatingButtonSize,
                    floatingButtonPadding: floatingButtonPadding,
                    isAnimatingButton: isAnimatingButton,
                    onButtonTapped: {
                        if !isAnimatingButton && !showEncourageCard {
                            isAnimatingButton = true
                            // 动效后弹出卡片
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                encourageText = encourages.randomElement() ?? "你很棒！"
                                showEncourageCard = true
                                isAnimatingButton = false
                            }
                        }
                    }
                )
                // 鼓励语卡片弹窗
                if showEncourageCard {
                    EncourageCardView(
                        encourageText: encourageText,
                        cardAnim: cardAnim,
                        cardGlow: cardGlow,
                        cardContentAppear: cardContentAppear,
                        buttonOpacity: buttonOpacity,
                        onDismiss: {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                                cardAnim = false
                                cardGlow = false
                                cardContentAppear = false
                                buttonOpacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                showEncourageCard = false
                            }
                        }
                    )
                    .onAppear {
                        cardAnim = false
                        cardGlow = false
                        cardContentAppear = false
                        buttonOpacity = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.interpolatingSpring(stiffness: 180, damping: 16)) {
                                cardAnim = true
                            }
                            withAnimation(.easeOut(duration: 0.7)) {
                                cardGlow = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                cardContentAppear = true
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddAnniversaryView(
                onDismiss: { showAddSheet = false },
                onSave: { event, date, color, icon in
                    let newItem = AnniversaryItem(id: UUID(), event: event, date: date, color: color, icon: icon)
                    anniversaryItems.append(newItem)
                    showAddSheet = false
                }
            )
        }
                    .sheet(isPresented: $showEditSheet) {
                if let editingItem = editingItem {
                    AddAnniversaryView(
                        onDismiss: { showEditSheet = false },
                        onSave: { event, date, color, icon in
                            if let index = anniversaryItems.firstIndex(where: { $0.id == editingItem.id }) {
                                var updatedItem = AnniversaryItem(
                                    id: editingItem.id,
                                    event: event,
                                    date: date,
                                    color: color,
                                    icon: icon
                                )
                                // 保持置顶状态
                                updatedItem.isPinned = editingItem.isPinned
                                anniversaryItems[index] = updatedItem
                            }
                            showEditSheet = false
                        },
                        editingItem: editingItem
                    )
                }
            }
    }
}

// 毛玻璃封装
import UIKit
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// 让 cornerRadius 只作用于底部圆角
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 三角形形状 - 用于置顶角标
fileprivate struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// AnniversaryCardView 组件
struct AnniversaryCardView: View {
    let item: AnniversaryItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onPin: () -> Void // 添加置顶功能
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    var body: some View {
        ZStack {
            // 背景操作按钮区域 - 编辑区域
            HStack(spacing: 0) {
                Spacer()
                // 置顶/取消置顶按钮 - 左侧与纪念日卡片贴合
                Button(action: onPin) {
                    ZStack {
                        Rectangle()
                            .fill(item.isPinned ? Color.gray : Color.blue)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: item.isPinned ? "pin.slash" : "pin")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text(item.isPinned ? "取消" : "置顶")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(22, corners: [.topLeft, .bottomLeft]) // 左侧圆角与纪念日卡片贴合
                
                // 编辑按钮
                Button(action: onEdit) {
                    ZStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text("编辑")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // 删除按钮
                Button(action: onDelete) {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text("删除")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .cornerRadius(22, corners: [.topRight, .bottomRight]) // 整体右侧圆角
            .offset(x: offset < 0 ? 0 : 180) // 编辑区域初始隐藏，左划时出现
            
            // 纪念日卡片 - 宽度不变，只移动位置
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    item.isPinned ? 
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.15),
                            Color.blue.opacity(0.08)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) : 
                    LinearGradient(
                        gradient: Gradient(colors: [
                            item.color.opacity(0.13),
                            item.color.opacity(0.13)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // 置顶标识 - 左下角
                    Group {
                        if item.isPinned {
                            VStack {
                                Spacer()
                                HStack {
                                    // 简洁的向上箭头角标
                                    ZStack {
                                        // 三角形背景
                                        Triangle()
                                            .fill(Color.blue.opacity(0.9))
                                            .frame(width: 20, height: 16)
                                        // 向上箭头
                                        Image(systemName: "chevron.up")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(y: -1)
                                    }
                                    .padding(.bottom, 8)
                                    .padding(.leading, 8)
                                    Spacer()
                                }
                            }
                        }
                    }
                )
                .shadow(color: item.isPinned ? Color.blue.opacity(0.15) : item.color.opacity(0.10), radius: 6, x: 0, y: 3)
                .frame(height: 112)
                .overlay(
                    AnniversaryItemView(
                        type: item.event,
                        targetDate: DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none),
                        daysLeft: Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0,
                        progress: 0.5,
                        isFuture: item.date > Date(),
                        icon: item.icon,
                        color: item.color,
                        isPinned: item.isPinned
                    )
                )
                .offset(x: offset) // 纪念日卡片跟随左划移动
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                // 只允许向左滑动，纪念日卡片跟手平移
                                offset = max(value.translation.width, -180) // 三个按钮总共180px
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if value.translation.width < -90 {
                                    // 滑动超过一半，显示编辑区域
                                    offset = -180
                                    isSwiped = true
                                } else {
                                    // 滑动不足，隐藏编辑区域
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
                .onTapGesture {
                    // 点击时隐藏编辑区域
                    if isSwiped {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            offset = 0
                            isSwiped = false
                        }
                    }
                }
        }
        .clipped() // 确保超出部分被截断
    }
}

// AnniversaryItemView 需支持icon和color参数
struct AnniversaryItemView: View {
    let type: String
    let targetDate: String
    let daysLeft: Int
    let progress: Double
    let isFuture: Bool
    let icon: String
    let color: Color
    let isPinned: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.7))
                    .frame(width: 44, height: 44)
                Text(icon)
                    .font(.system(size: 24))
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(type)
                        .font(.headline)
                        .foregroundColor(isPinned ? Color.blue : Color(red: 0.8, green: 0.5, blue: 0.2))
                    if isPinned {
                        Text("置顶")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.1))
                            )
                    }
                }
                Text(targetDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer(minLength: 0)
                ProgressView(value: progress)
                    .accentColor(isFuture ? Color(red: 0.9, green: 0.6, blue: 0.3) : Color(red: 0.4, green: 0.7, blue: 0.4))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing, spacing: 4) {
                if daysLeft == 0 {
                    Text("已经抵达")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                } else if isFuture {
                    Text("还有")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(abs(daysLeft))天")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.9, green: 0.6, blue: 0.3))
                } else {
                    Text("已陪伴")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(abs(daysLeft))天")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.4, green: 0.7, blue: 0.4))
                }
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}