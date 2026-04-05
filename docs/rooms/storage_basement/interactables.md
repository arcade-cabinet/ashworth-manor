# Storage Basement — Interactables

## 1. Scratched Family Portrait — KEY NARRATIVE (EXISTS)

```yaml
id: scratched_portrait
type: photo
position: (-3, 1.2, 2)
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Scratched Portrait**
> "A stern-looking family stands before the mansion. Four figures — but the youngest child's face has been scratched out. Not carefully removed. Gouged. With something sharp. Whoever did this wasn't erasing a mistake. They were destroying a memory."

**After `knows_full_truth`:**
> **Scratched Portrait**
> "Elizabeth's face, destroyed. Lord Ashworth did this himself — the scratches match the frantic handwriting in his diary. He couldn't bear to look at what he'd done to her."

### Flags Set
- `seen_scratched_portrait`
- `knows_fourth_child_erased`

---

## 2. Old Mirror (NEW)

```yaml
id: storage_mirror
type: mirror
position: (3, 1.5, 3)
collision: BoxShape3D(1.0, 2.0, 0.5)
```

### Text — All Variants

**Default:**
> **Cracked Mirror**
> "Cracked down the center. Your reflection splits into two — each half at a slightly different angle. Two of you. One looking left, one looking right. Neither looking where you expect."

**After `elizabeth_aware`:**
> **Cracked Mirror**
> "Both halves of your reflection are looking at the same spot now. Behind you. To the left. You don't turn around."

---

## 3. Covered Furniture (NEW)

```yaml
id: storage_covered
type: observation
position: (0, 0.8, -2)
collision: BoxShape3D(2.0, 1.5, 1.5)
```

### Text

> **Dust Cloths**
> "Shapes under white sheets. Chairs, a rocking horse, a crib. Children's furniture — but not from three children. This is a fourth set. Elizabeth's things. Stored, not destroyed. Someone couldn't bring themselves to burn it."

---

## 4. Sealed Trunk (NEW)

```yaml
id: storage_trunk
type: observation
position: (-2, 0.4, -3)
collision: BoxShape3D(1.5, 1.0, 1.0)
```

### Text

> **Sealed Trunk**
> "Locked without a keyhole — sealed with wax and iron bands. Whatever is inside was meant to stay inside forever. The wax bears a sigil you've seen in the binding book."

---

## Summary

| ID | Type | Status |
|----|------|--------|
| `scratched_portrait` | photo | EXISTS — update content |
| `storage_mirror` | mirror | NEW |
| `storage_covered` | observation | NEW |
| `storage_trunk` | observation | NEW |
