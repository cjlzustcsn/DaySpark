//
//  ContentView.swift
//  DaySpark
//
//  Created by 89 on 2025/7/19.
//

import SwiftUI

struct AnniversaryItem: Identifiable, Equatable {
    let id: UUID
    let event: String
    let date: Date
    let color: Color
    let icon: String
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
                    HStack {
                        Text("DaySpark")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2)) // 柔和棕橙
                            .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.3), radius: 2, x: 0, y: 2)
                        Spacer()
                        Button(action: {
                            showAddSheet = true
                        }) {
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
                    .padding(.top, geometry.safeAreaInsets.top)
                    // 分割线更淡
                    Rectangle()
                        .fill(Color(red: 1.0, green: 0.976, blue: 0.941, opacity: 0.5))
                        .frame(height: 1)
                        .shadow(color: Color.clear, radius: 0)
                    // 纪念日区域最大化
                    ZStack {
                        Color(.systemBackground)
                            .cornerRadius(cardAreaCornerRadius, corners: [.topLeft, .topRight])
                            .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.10), radius: 8, x: 0, y: -4)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: cardSpacing) {
                                ForEach(anniversaryItems) { item in
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(item.color.opacity(0.13))
                                        .shadow(color: item.color.opacity(0.10), radius: 6, x: 0, y: 3)
                                        .frame(height: 112)
                                        .overlay(
                                            AnniversaryItemView(
                                                type: item.event,
                                                targetDate: DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none),
                                                daysLeft: Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0,
                                                progress: 0.5, // 可后续完善
                                                isFuture: item.date > Date(),
                                                icon: item.icon,
                                                color: item.color
                                            )
                                        )
                                }
                            }
                            .padding(.top, 24)
                            .padding(.horizontal)
                            .padding(.bottom, floatingButtonSize + floatingButtonPadding + geometry.safeAreaInsets.bottom)
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.top)
                // 悬浮抽签按钮
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            if !isAnimatingButton && !showEncourageCard {
                                isAnimatingButton = true
                                // 动效后弹出卡片
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    encourageText = encourages.randomElement() ?? "你很棒！"
                                    showEncourageCard = true
                                    isAnimatingButton = false
                                }
                            }
                        }) {
                            ZStack {
                                buttonGradient
                                    .frame(width: floatingButtonSize, height: floatingButtonSize)
                                    .clipShape(Circle())
                                    .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.18), radius: 10, x: 0, y: 6)
                                // 光晕效果
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
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 32))
                        .accessibilityLabel("抽签")
                    }
                }
                // 鼓励语卡片弹窗
                if showEncourageCard {
                    VisualEffectBlur(blurStyle: .systemMaterial)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: showEncourageCard)
                        .onTapGesture {
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
                                                Color(red: 0.98, green: 0.85, blue: 0.45), // 金色
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
            .sheet(isPresented: $showAddSheet) {
                AddAnniversaryView()
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

// AnniversaryItemView 需支持icon和color参数
struct AnniversaryItemView: View {
    let type: String
    let targetDate: String
    let daysLeft: Int
    let progress: Double
    let isFuture: Bool
    let icon: String
    let color: Color
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(color.opacity(0.7))
                    .frame(width: 44, height: 44)
                Text(icon)
                    .font(.system(size: 24))
            }
        VStack(alignment: .leading, spacing: 10) {
                    Text(type)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                    Text(targetDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if isFuture {
                        Text("还有")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(daysLeft)天")
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
                }
            }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        ProgressView(value: progress)
            .accentColor(isFuture ? Color(red: 0.9, green: 0.6, blue: 0.3) : Color(red: 0.4, green: 0.7, blue: 0.4))
            .scaleEffect(x: 1, y: 1.5, anchor: .center)
    }
}

#Preview {
    ContentView()
}
