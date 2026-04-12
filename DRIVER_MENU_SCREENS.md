# Driver Menu Management - Screen Flow & Features

## Screen Hierarchy

```
Menu List Screen
├── Shows all menu items in 2-column grid
├── Empty state with "Add First Item" button
├── Action: Tap item → View Menu Screen
└── Action: Tap "Add" button → Add/Edit Menu Screen (Add mode)

View Menu Screen
├── Image carousel (horizontal scroll)
├── Item name and pricing
├── Description section
├── Stock quantity badge
├── Edit button (AppBar) → Add/Edit Menu Screen (Edit mode)
└── Delete button → Confirmation dialog

Add/Edit Menu Screen
├── Image Selection
│   ├── Image grid preview (3 columns)
│   ├── Remove button per image
│   └── "Add Image" button (opens gallery)
├── Form Fields
│   ├── Item Name
│   ├── Price (with $ suffix)
│   ├── Discount Price (optional)
│   ├── Stock Quantity
│   └── Description (multiline)
├── Save/Update button (with loading state)
└── Cancel button
```

## Screens Details

### 1. Menu List Screen
**Purpose:** Browsing and managing all menu items

**Layout:**
```
┌─────────────────────────────────┐
│ ← Menu Management         [+ Add]│  ← AppBar
├─────────────────────────────────┤
│ Manage your ice cream menu      │
├─────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐    │
│  │  Image   │  │  Image   │    │
│  ├──────────┤  ├──────────┤    │
│  │ Classic  │  │Strawberry│    │
│  │ Vanilla  │  │ Ice Cream│    │
│  │ $3.99    │  │ $5.99    │    │
│  │Stock: 50 │  │Stock: 35 │    │
│  └──────────┘  └──────────┘    │
│  ┌──────────┐  ┌──────────┐    │
│  │Chocolate │  │ Sundae   │    │
│  │  Swirl   │  │ Supreme  │    │
│  │ $3.99    │  │ $5.99    │    │
│  │Stock: 40 │  │Stock: 28 │    │
│  └──────────┘  └──────────┘    │
└─────────────────────────────────┘
```

**Features:**
- Tap any card to view details
- Add button opens new item form
- Empty state if no items
- Responsive 2-column grid

---

### 2. View Menu Screen
**Purpose:** Display complete item details with edit/delete options

**Layout:**
```
┌─────────────────────────────────┐
│ ← Menu Details           [✎ Edit]│  ← AppBar
├─────────────────────────────────┤
│  ╔═════════════════════════════╗│
│  ║         [Image]             ║│  ← Image Carousel
│  ║    (swipe for more)         ║│
│  ╚═════════════════════════════╝│
│                                 │
│  Classic Vanilla Cone           │  ← Name
│                                 │
│  ┌─────────────────────────┐   │
│  │ Regular Price    $3.99  │   │  ← Price Card
│  └─────────────────────────┘   │
│                                 │
│  Description                    │  ← Description
│  Creamy vanilla soft serve      │
│  in a crispy cone              │
│                                 │
│  ┌────────────────────────────┐│
│  │ 📦 Stock Quantity: 50 items││  ← Info Card
│  └────────────────────────────┘│
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🗑️  Delete Item          │ │  ← Delete Button
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

**Features:**
- Horizontal scrollable image carousel
- Shows regular and discount prices (if applicable)
- Full description display
- Stock information
- Edit button in top AppBar
- Delete with confirmation

---

### 3. Add/Edit Menu Screen
**Purpose:** Create new or modify existing menu items

**Layout:**
```
┌─────────────────────────────────┐
│ ← Add New Item                  │  ← AppBar (Edit mode: "Edit Menu Item")
├─────────────────────────────────┤
│                                 │
│ Images                          │  ← Section Title
│ ┌────┐ ┌────┐ ┌────┐           │
│ │Img │ │Img │ │Img │           │  ← Image Grid (3 cols)
│ │ ✕  │ │ ✕  │ │    │           │  ← Remove buttons
│ └────┘ └────┘ └────┘           │
│                                 │
│ [+ Add Photo] Button            │  ← Add Image Button
│                                 │
│ Item Name                       │  ← Label
│ ┌─────────────────────────────┐ │
│ │ e.g., Classic Vanilla Cone  │ │  ← Input Field
│ └─────────────────────────────┘ │
│                                 │
│ Price          Discount Price   │  ← Two Column Layout
│ ┌──────────┐   ┌──────────┐    │
│ │ 3.99 $   │   │Optional $│    │
│ └──────────┘   └──────────┘    │
│                                 │
│ Stock Quantity                  │  ← Label
│ ┌─────────────────────────────┐ │
│ │ 50                          │ │  ← Input Field
│ └─────────────────────────────┘ │
│                                 │
│ Description                     │  ← Label
│ ┌─────────────────────────────┐ │
│ │                             │ │  ← Multiline Input (4 lines)
│ │ Describe your ice cream...  │ │
│ │                             │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ 🔄 Add Item                 │ │  ← Save Button (with loading)
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Cancel                      │ │  ← Cancel Button
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**Features:**
- Multiple image selection (one at a time)
- Image preview grid with remove button on each
- Two-column price inputs
- Multiline description (4 line minimum)
- Stock quantity required
- Form validation before submit
- Loading indicator on save
- All fields required (except discount)

---

## User Flows

### Flow 1: Adding New Menu Item
```
Menu List → [Add] → Add Menu Screen
            ↓
    [Add Photo] → Select Image
            ↓
    Fill Form → Validate
            ↓
    [Add Item] → Save & Return to List
            ↓
    New item appears in grid
```

### Flow 2: Viewing & Editing Item
```
Menu List → [Tap Card] → View Menu Screen
                    ↓
        [Edit] → Add/Edit Screen (Edit Mode)
                    ↓
        Modify Fields & Images
                    ↓
        [Update Item] → Save & Return
                    ↓
        Updated details shown
```

### Flow 3: Deleting Item
```
View Menu Screen → [Delete] → Confirmation Dialog
                        ↓
        [Yes, Delete] → Item Deleted
                        ↓
        Return to List (item gone)
```

---

## Form Validation Rules

| Field | Required | Type | Format | Example |
|-------|----------|------|--------|---------|
| Item Name | ✅ | Text | Any | Classic Vanilla Cone |
| Price | ✅ | Number | Decimal (2 places) | 3.99 |
| Discount Price | ❌ | Number | Decimal (2 places) | 2.99 |
| Stock Quantity | ✅ | Number | Integer | 50 |
| Description | ✅ | Text | 4+ lines | Creamy vanilla... |
| Images | ✅ | File | JPG/PNG/etc | Multiple allowed |

---

## Button States & Actions

### Menu List Screen
- **[+ Add]** AppBar: Opens Add Menu Screen
- **Item Card Tap**: Opens View Menu Screen
- **Empty State [Add First Item]**: Opens Add Menu Screen

### View Menu Screen
- **[✎ Edit]** AppBar: Opens Add/Edit Screen in edit mode
- **[🗑️ Delete Item]**: Shows confirmation dialog

### Add/Edit Menu Screen
- **[+ Add Photo]**: Opens image picker
- **Image Remove (✕)**: Removes image from list
- **[Add/Update Item]**: Validates & saves (loading state)
- **[Cancel]**: Returns to previous screen, clears images

---

## Design System Integration

### Colors (Blue Theme - Drivers)
- **Primary**: AppColors.primaryBlue (#4A5FD9)
- **Background**: AppColors.bgBlue
- **Gradient**: AppColors.blueGradient
- **Text Dark**: AppColors.textDark
- **Text Gray**: AppColors.textGray
- **Shadows**: AppColors.shadowBlack

### Spacing
- Container padding: 20px
- Element spacing: 12-16px
- Card padding: 16px
- Input padding: 14px H, 14px V

### Border Radius
- Cards & Containers: 16px
- Buttons: 50px (full round)
- Input fields: 12px
- Images: 16px
- Badges: 6px

### Shadows
- Default: blurRadius: 4, offset: (0, 2)
- Large: blurRadius: 8, offset: (0, 2)

---

## Data Flow

```
GetX Controller (DriverMenuController)
    ↓
Observables:
    - menuItems<MenuItem>[]
    - selectedImages<String>[]
    - isLoading<bool>
    ↓
Methods:
    - pickImage()
    - removeImage(index)
    - saveMenuItem(item)
    - deleteMenuItem(id)
    - getMenuItemById(id)
    ↓
Views:
    - MenuListScreen (Obx → menuItems)
    - ViewMenuScreen (getMenuItemById)
    - AddEditMenuScreen (Obx → selectedImages, isLoading)
```

---

## Mock Data Structure

```dart
MenuItem(
  id: '1',
  name: 'Classic Vanilla Cone',
  price: 3.99,
  discountPrice: null,
  quantity: 50,
  description: 'Creamy vanilla soft serve in a crispy cone',
  imagePaths: ['assets/ice_cream_1.jpg'],
)
```

---

## Status & Notes

✅ **Complete Implementation**
- All 3 screens fully implemented
- GetX state management
- Form validation
- Image handling
- Navigation routing
- Blue theme styling
- Error handling

🔄 **Ready For:**
1. API Integration (replace mock data)
2. Real image upload
3. Database storage
4. Advanced filtering
5. Analytics tracking

---

**Last Updated:** December 2, 2025
**Status:** Production Ready (Mock Data)
