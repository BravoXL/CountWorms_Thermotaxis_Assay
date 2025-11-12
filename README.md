# CountWorms_Thermotaxis_Assay
Fiji/ImageJ macro for high-throughput worm counting across 8 zones in thermotaxis assays

---

## Author  
Shangguan Pingchuan  
zxlearly@gmail.com  
Last update: 2025-11-12

---

## 1. What it does  
- Splits any rectangular image into 8 equal-width horizontal regions.  
- Automatically detects *C. elegans* (or any dark objects) after interactive thresholding.  
- Lets you manually add/delete ROIs before final counting.  
- Exports:  
  - Region-by-region worm numbers  
  - XY centroid list per region  
  - CSV for Excel/R analysis  
  - Full ImageJ log (txt) for reproducibility  

---

## 2. How to run (quick start)  
1. Close all Fiji windows (Results, Log, ROI Manager).  
2. **Drag your image into Fiji** → click **Run** on this macro.  
3. Follow the pop-up instructions step-by-step:  
   1. Open image  
   2. Set threshold (worms = red) → **Apply**  
   3. *Analyze Particles* (suggested: size 30–∞, circularity 0)  
   4. Clean ROI list (add missed, delete false)  
   5. Pick output folder → done  

---

## 3. Output files (saved in chosen folder)  
| File name pattern | Content |
|-------------------|---------|
| `worm_count_results_<timestamp>.csv` | 9 rows: 8 regions + Total |
| `worm_count_results_<timestamp>Log.txt` | Complete ImageJ log (settings, coordinates, counts) |

CSV preview:  
```
Region,Count  
1,12  
2,15  
...  
8,7  
Total,84
```

---

## 4. Parameters you may want to tweak  
Open the macro in Fiji’s **Script Editor**, edit these lines, and save:  

| Variable | Default | Meaning |
|----------|---------|---------|
| `nDiv = 8;` | 8 | Number of horizontal zones |
| size filter | *(interactive)* | *Analyze Particles* dialog |
| `dir = ...` | hard-coded path | Default save folder |

---

## 5. Requirements  
- Fiji (latest) with **ImageJ 1.54c+**  
- Built-ins: ROI Manager, Analyze Particles, Convert to Mask  

---

## 6. Troubleshooting  
| Problem | Fix |
|---------|-----|
| Zero objects detected | Lower threshold or decrease size limit in *Analyze Particles* |
| Wrong zone order | Ensure image orientation (top = region 1) before Step 2 |
| CSV not saved | Check write permission of chosen folder; macro will pause if invalid |

---

## 7. Citation  
If you use this macro in a publication please cite:  
Shangguan P. Count_Worms_8Regions_TTX_zxl_Ver1 macro, 2025.  
Available upon request or from `zxlearly@gmail.com`.

---

## 8. License  
MIT License – feel free to modify and redistribute with attribution.
