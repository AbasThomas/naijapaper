# 📱 Dashboard Visual Guide - Component Breakdown

## Layout Structure

```
┌─────────────────────────────────────────┐
│  🎨 GRADIENT APP BAR (140px)           │
│  Good morning, Student!                 │
│  🔔 ⚙️                                  │
└─────────────────────────────────────────┘
│
├─ 📥 Offline Banner (if needed)
│  ┌───────────────────────────────────┐
│  │ 📥 Offline Mode Available         │
│  │ Download subjects...  [Download]  │
│  └───────────────────────────────────┘
│
├─ 🎯 HERO SECTION (Gradient Card)
│  ┌───────────────────────────────────┐
│  │                                   │
│  │        🔥 STREAK RING             │
│  │          (140px)                  │
│  │                                   │
│  │  ⭐ Level 7                       │
│  │  1,250 / 2,000 XP        [75%]   │
│  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░           │
│  └───────────────────────────────────┘
│
├─ 🤖 AI COACH BUBBLE (if message)
│  ┌───────────────────────────────────┐
│  │ 🤖 AI Study Coach ✓               │
│  │ Great progress today! Keep...     │
│  └───────────────────────────────────┘
│
├─ ⚡ ACTION CARDS ROW
│  ┌─────────────────┐ ┌──────────────┐
│  │ ⚡ Daily Drill  │ │ 📅 JAMB Exam │
│  │ [NEW]           │ │ [7 days]     │
│  │                 │ │              │
│  │ 5 quick         │ │ Upcoming     │
│  │ questions       │ │ Exam         │
│  └─────────────────┘ └──────────────┘
│
├─ 📊 RECENT MOCK SCORE
│  ┌───────────────────────────────────┐
│  │ [A1] Recent Mock Score            │
│  │      Mathematics          85%  >  │
│  │      📅 May 01, 2026              │
│  └───────────────────────────────────┘
│
├─ 📈 TODAY'S PROGRESS
│  ┌────┐ ┌────┐ ┌────┐
│  │ 📝 │ │ ⏱️ │ │ 📈 │
│  │ 15 │ │45m │ │+50 │
│  │Ques│ │Time│ │ XP │
│  └────┘ └────┘ └────┘
│
├─ 📉 WEAK TOPICS
│  ┌───────────────────────────────────┐
│  │ 📉 Algebra                    →   │
│  │    [35%] • 12 attempts            │
│  └───────────────────────────────────┘
│  ┌───────────────────────────────────┐
│  │ 📉 Organic Chemistry          →   │
│  │    [42%] • 8 attempts             │
│  └───────────────────────────────────┘
│
├─ 🏆 LEADERBOARD PEEK
│  ┌───────────────────────────────────┐
│  │ 🏆 Leaderboard      [View All >]  │
│  │ ┌─────────────────────────────┐   │
│  │ │ [#12] Your Rank             │   │
│  │ │       Ranked #12            │   │
│  │ │       Top 5% in Lagos  [COMPETE]│
│  │ └─────────────────────────────┘   │
│  └───────────────────────────────────┘
│
├─ 🚀 QUICK ACTIONS
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐
│  │📝  │ │⚡  │ │🤖  │ │👥  │
│  │Mock│ │Drill│ │AI  │ │Study│
│  │Exam│ │    │ │Tutor│ │Group│
│  └────┘ └────┘ └────┘ └────┘
│
└─ 📅 RECENT ACTIVITY
   ┌───────────────────────────────────┐
   │ 📝 Completed Mock Exam            │
   │    Mathematics - 85%    [2h ago]  │
   └───────────────────────────────────┘
   ┌───────────────────────────────────┐
   │ ⚡ Daily Drill Completed           │
   │    5/5 correct          [5h ago]  │
   └───────────────────────────────────┘
```

---

## Color Coding

### 🎨 App Bar
- **Background:** Gradient (Primary → Primary Dark)
- **Text:** White
- **Icons:** White with notification badge (red dot)

### 🎯 Hero Section
- **Background:** White with subtle gradient
- **Border:** None
- **Shadow:** Soft green shadow (primary color)
- **Streak Ring:** Animated SVG with gradient
- **XP Bar:** Gradient (Primary → Primary Light)

### 🤖 AI Coach Bubble
- **Background:** Gradient (Info color, 8% → 3%)
- **Border:** Info color (20% opacity)
- **Icon Container:** Gradient (Info → Primary) with shadow
- **Badge:** Info color with verified icon

### ⚡ Daily Drill Card
- **Incomplete:**
  - Background: Warning gradient (15% → 8%)
  - Border: Warning (30% opacity)
  - Icon: Warning color
  - Badge: "NEW" in warning color
- **Completed:**
  - Background: Success gradient (10% → 5%)
  - Border: Success (30% opacity)
  - Icon: Success color with checkmark

### 📅 Deadline Card
- **Background:** Error gradient (12% → 6%)
- **Border:** Error (30% opacity)
- **Icon:** Error color
- **Badge:** Error/Warning based on urgency
- **Empty State:** Grey with border

### 📊 Recent Mock Card
- **Background:** White
- **Grade Badge:** Color-coded by score
  - 70%+: Success
  - 50-69%: Warning
  - <50%: Error
- **Border:** Subtle grey

### 📈 Today's Stats
- **Questions:** Primary color
- **Time:** Info color
- **XP:** Success color
- **Background:** White with colored borders
- **Icons:** In colored circular containers

### 📉 Weak Topics
- **Background:** White
- **Border:** Color-coded by accuracy
  - <40%: Red
  - 40-70%: Amber
  - >70%: Green
- **Icon Container:** Gradient matching accuracy color
- **Badge:** Colored percentage badge

### 🏆 Leaderboard
- **Background:** Warning gradient (10% → 5%)
- **Border:** Warning (30% opacity)
- **Rank Badge:** Warning gradient with shadow
- **Inner Card:** White
- **Button:** Warning color

### 🚀 Quick Actions
- **Mock Exam:** Primary gradient
- **Daily Drill:** Warning gradient
- **AI Tutor:** Info gradient
- **Study Group:** Success gradient
- **Background:** Gradient (10% opacity)
- **Icons:** White in gradient containers

### 📅 Recent Activity
- **Background:** White
- **Border:** Light grey
- **Icons:** Gradient containers (color-coded)
- **Time Badge:** Grey background

---

## Spacing Guide

### Vertical Spacing
```
App Bar: 140px height
↓ 20px
Offline Banner (if shown)
↓ 20px
Hero Section
↓ 20px
AI Coach Bubble (if shown)
↓ 20px
Action Cards Row
↓ 20px
Recent Mock (if shown)
↓ 20px
Today's Progress Section
↓ 24px
Weak Topics Section
↓ 24px
Leaderboard Section
↓ 24px
Quick Actions Section
↓ 24px
Recent Activity Section
↓ 32px (bottom padding)
```

### Horizontal Spacing
```
Screen Edges: 16px padding
Card Internal: 16-20px padding
Between Cards: 12px gap
Between Stats: 12px gap
```

---

## Typography Scale

### Headers
```dart
Section Headers: 20px, Bold, with 4px colored bar
Card Titles: 18px, Bold
Subsection: 16px, Bold
```

### Body Text
```dart
Primary: 14px, Regular
Secondary: 13px, Medium
Tertiary: 12px, Regular
```

### Small Text
```dart
Badges: 11px, Bold, Uppercase
Timestamps: 10px, Semi-bold
Labels: 11px, Medium
```

---

## Interactive Elements

### Buttons
```dart
Primary Button:
- Background: Solid color
- Text: White, 12-13px, Bold
- Padding: 16h × 10-12v
- Border Radius: 12px
- Elevation: 0

Secondary Button (Outlined):
- Border: 1.5px solid
- Text: Colored, 12-13px, Bold
- Padding: 16h × 10-12v
- Border Radius: 12px

Text Button:
- Text: Colored, 13px, Semi-bold
- Icon: 16px
- No background
```

### Cards
```dart
Tappable Cards:
- Ripple effect on tap
- Border radius: 16-20px
- Elevation: Subtle shadow
- Hover: Slight scale (1.02)

Static Cards:
- No interaction
- Same styling as tappable
```

---

## Animation Timing

### Entrance Animations
```dart
Hero Section: 600ms (elastic curve)
Cards: 400-500ms (ease out)
Sections: Staggered 100ms delays
```

### Interaction Animations
```dart
Button Tap: 150ms
Card Press: 200ms
Progress Bar: 800ms
```

### Loading States
```dart
Shimmer: 1500ms loop
Fade In: 300ms
```

---

## Responsive Breakpoints

### Mobile (< 600px)
- Single column layout
- Full-width cards
- Horizontal scroll for actions
- 16px side margins

### Tablet (600-900px)
- Same as mobile (optimized for portrait)
- Larger touch targets
- More generous spacing

### Desktop (> 900px)
- Not optimized (mobile-first app)
- Consider max-width constraint

---

## Accessibility

### Color Contrast
```
Text on White: 4.5:1 minimum
Text on Primary: 4.5:1 (white text)
Text on Colored Backgrounds: 4.5:1
```

### Touch Targets
```
Minimum: 44×44 px
Buttons: 48×48 px
Icons: 44×44 px (with padding)
```

### Focus States
```
Keyboard Focus: 2px outline
Tab Order: Logical top-to-bottom
```

---

## Loading States

### Shimmer Placeholders
```
Hero Section: 200×200 circle
XP Card: Full width × 100px
Action Cards: 2 cards × 160px
Stats: 3 cards × 100px
```

### Skeleton Screens
- Match final layout structure
- Use grey shimmer effect
- Rounded corners match final design

---

## Error States

### Error Display
```
Icon: 64px in colored circle
Title: 20px, Bold
Message: 14px, Regular, Grey
Buttons: Primary + Secondary
```

### Empty States
```
Icon: 40px in grey circle
Title: 16px, Bold
Message: 13px, Regular, Grey
CTA: Optional button
```

---

## Best Practices

### Do's ✅
- Use consistent spacing (16px base)
- Apply gradients for depth
- Add subtle shadows for elevation
- Use color-coding for status
- Provide clear CTAs
- Show loading states
- Handle errors gracefully

### Don'ts ❌
- Don't use flat colors everywhere
- Don't overcrowd the screen
- Don't use tiny touch targets
- Don't hide important actions
- Don't use too many colors
- Don't forget empty states
- Don't skip animations

---

## Component Checklist

### Every Card Should Have:
- [ ] Rounded corners (16-20px)
- [ ] Subtle shadow or border
- [ ] Adequate padding (16-20px)
- [ ] Clear hierarchy
- [ ] Tappable feedback (if interactive)
- [ ] Loading state
- [ ] Error state (if applicable)

### Every Section Should Have:
- [ ] Clear header with accent bar
- [ ] Consistent spacing (24px)
- [ ] Entrance animation
- [ ] Empty state (if applicable)
- [ ] "View All" link (if truncated)

---

**Status:** ✅ Complete Visual Guide
**Usage:** Reference for maintaining design consistency
**Updates:** Keep in sync with dashboard changes

---

*Visual guide created for NaijaPaper dashboard v2.0*
