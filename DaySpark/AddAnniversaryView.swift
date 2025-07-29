import SwiftUI

struct AddAnniversaryView: View {
    var onDismiss: (() -> Void)? = nil
    var onSave: ((_ event: String, _ date: Date, _ color: Color, _ icon: String) -> Void)? = nil
    var editingItem: AnniversaryItem? = nil // 添加编辑项参数
    @Environment(\.presentationMode) var presentationMode
    @State private var event: String
    @State private var date: Date
    @State private var selectedColor: Color
    @State private var selectedIcon: String
    
    // 初始化状态变量
    init(editingItem: AnniversaryItem? = nil, onDismiss: (() -> Void)? = nil, onSave: ((_ event: String, _ date: Date, _ color: Color, _ icon: String) -> Void)? = nil) {
        self.editingItem = editingItem
        self.onDismiss = onDismiss
        self.onSave = onSave
        
        // 根据编辑模式初始化状态
        if let editingItem = editingItem {
            _event = State(initialValue: editingItem.event)
            _date = State(initialValue: editingItem.date)
            _selectedColor = State(initialValue: editingItem.color)
            _selectedIcon = State(initialValue: editingItem.icon)
        } else {
            _event = State(initialValue: "")
            _date = State(initialValue: Date())
            _selectedColor = State(initialValue: .orange)
            _selectedIcon = State(initialValue: "🎂")
        }
    }
    // 10个主题色
    let colors: [Color] = [
        .orange, .yellow, .pink, .blue, .green, .purple, .red, .teal, .mint, .indigo
    ]
    // 15个图标
    let icons: [String] = ["🎂", "🎉", "🌸", "🎁", "🐱", "🍰", "🎈", "🌞", "🌟", "🍀", "🦄", "🍎", "🍩", "🍔", "🍕"]
    
    var body: some View {
        ZStack {
            // 与主界面一致的温暖渐变背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.97, blue: 0.88),
                    Color(red: 1.0, green: 0.93, blue: 0.75),
                    Color(red: 1.0, green: 0.98, blue: 0.95)
                ]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 0) {
                // 标题栏
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.32), Color.yellow.opacity(0.22)]),
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(height: 56)
                    .ignoresSafeArea(edges: .top)
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        Spacer()
                        Text(editingItem != nil ? "编辑" : "添加")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        Spacer()
                        // 小猫点缀
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.orange.opacity(0.25), Color.yellow.opacity(0.18)]),
                                    startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 28, height: 28)
                            Text("🐱")
                                .font(.system(size: 18))
                        }
                        .padding(.trailing, 2)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 56)
                .overlay(
                    Divider()
                        .background(Color(.systemGray5)), alignment: .bottom
                )
                // 表单区域
                VStack(spacing: 22) {
                    // 事件
                    AddCard {
                        HStack(spacing: 0) {
                            Text("事件")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .frame(width: 56, alignment: .leading)
                            Divider()
                                .frame(width: 1, height: 24)
                                .background(Color.orange.opacity(0.18))
                                .padding(.horizontal, 6)
                            Spacer(minLength: 0)
                            TextField("请输入事件", text: $event)
                                .multilineTextAlignment(.trailing)
                                .font(.body)
                                .frame(width: 160)
                        }
                    }
                    .frame(height: 48)
                    // 日期
                    AddCard {
                        HStack(spacing: 0) {
                            Text("日期")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .frame(width: 56, alignment: .leading)
                            Divider()
                                .frame(width: 1, height: 24)
                                .background(Color.orange.opacity(0.18))
                                .padding(.horizontal, 6)
                            Spacer(minLength: 0)
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .frame(width: 160)
                        }
                    }
                    .frame(height: 48)
                    // 主题色
                    AddCard {
                        HStack(alignment: .center, spacing: 0) {
                            Text("主题色")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .frame(width: 56, alignment: .leading)
                            // 竖线分隔
                            Divider()
                                .frame(width: 1, height: 32)
                                .background(Color.orange.opacity(0.18))
                                .padding(.horizontal, 6)
                            Spacer(minLength: 0)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(colors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 28, height: 28)
                                            .overlay(
                                                Circle().stroke(Color.orange, lineWidth: selectedColor == color ? 2.5 : 0)
                                            )
                                            .scaleEffect(selectedColor == color ? 1.18 : 1.0)
                                            .shadow(color: selectedColor == color ? color.opacity(0.18) : .clear, radius: 4, x: 0, y: 2)
                                            .padding(.vertical, 8)
                                            .onTapGesture { selectedColor = color }
                                    }
                                }
                                .padding(.vertical, 2)
                                .padding(.leading, 10) // 增加左侧内边距，防止放大被截断
                                .padding(.trailing, 2)
                            }
                        }
                    }
                    .frame(height: 80)
                    // 图标
                    AddCard {
                        HStack(alignment: .center, spacing: 0) {
                            Text("图标")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .frame(width: 56, alignment: .leading) // 固定宽度，与主题色对齐
                            // 竖线分隔
                            Divider()
                                .frame(width: 1, height: 32)
                                .background(Color.orange.opacity(0.18))
                                .padding(.horizontal, 6)
                            Spacer(minLength: 0)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(icons, id: \.self) { icon in
                                        Text(icon)
                                            .font(.system(size: 22))
                                            .padding(6)
                                            .background(
                                                Circle()
                                                    .fill(selectedIcon == icon ? Color.orange.opacity(0.18) : Color.clear)
                                            )
                                            .scaleEffect(selectedIcon == icon ? 1.18 : 1.0)
                                            .shadow(color: selectedIcon == icon ? Color.orange.opacity(0.18) : .clear, radius: 4, x: 0, y: 2)
                                            .padding(.vertical, 8)
                                            .onTapGesture { selectedIcon = icon }
                                    }
                                }
                                .padding(.vertical, 2)
                                .padding(.leading, 10) // 增加左侧内边距，保证左对齐
                                .padding(.trailing, 2)
                            }
                        }
                    }
                    .frame(height: 80)
                }
                .padding(.top, 36)
                .padding(.horizontal, 24)
                // 保存按钮
                Spacer()
                VStack(spacing: 10) {
                    Button(action: {
                        if let onSave = onSave {
                            onSave(event, date, selectedColor, selectedIcon)
                        }
                        if let onDismiss = onDismiss {
                            onDismiss()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("保存")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .cornerRadius(24)
                            .shadow(color: .orange.opacity(0.12), radius: 6, x: 0, y: 2)
                    }
                    .padding(.horizontal, 48)
                    Text("每一天都值得被记录")
                        .font(.footnote)
                        .foregroundColor(.orange)
                        .padding(.bottom, 8)
                }
                .padding(.bottom, 24)
            }
        }
    }
}

// 温馨圆角卡片
struct AddCard<Content: View>: View {
    let content: () -> Content
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.white.opacity(0.98))
            .shadow(color: Color.orange.opacity(0.07), radius: 6, x: 0, y: 2)
            .overlay(
                content()
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
            )
    }
}