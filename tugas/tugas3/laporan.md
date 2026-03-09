# Laporan Tugas 4: Point Processing dan Operasi Aritmatika-Logika pada Citra Digital

**Mata Kuliah:** Pengolahan Citra Digital
**Referensi:** *Digital Image Processing*, 4th Edition, Chapter 2–3

---

## 1. Pendahuluan

Laporan ini menyajikan implementasi berbagai teknik *point processing* dan operasi aritmatika-logika pada citra digital. Seluruh transformasi diimplementasikan secara manual menggunakan iterasi pixel (*nested loop*) dalam bahasa C++ dengan library OpenCV, tanpa menggunakan fungsi bawaan OpenCV untuk proses transformasinya.

Dua image input digunakan dalam percobaan ini:

- **Image OG** — image berwarna dengan variasi warna yang kaya, digunakan sebagai input utama untuk seluruh transformasi.
- **Image PG** — image gelap (*underexposed*), digunakan untuk mendemonstrasikan efek transformasi pada image dengan intensity rendah.

| Image Input                         | Deskripsi           |
| ----------------------------------- | ------------------- |
| ![Image OG](output/gamma_10.png)    | Image OG (original) |
| ![Image PG](output/pg_gamma_10.png) | Image PG (dark)     |

---

## 2. Grayscale Conversion

Grayscale conversion mengubah image berwarna (BGR) menjadi image satu channel dengan intensity abu-abu. Setiap pixel dalam image grayscale merepresentasikan intensity kecerahan pada titik spasial tersebut. Tiga method conversion diimplementasikan:

### 2.1 Lightness Method

Method ini menghitung rata-rata dari nilai maximum dan minimum di antara ketiga color channel:

$$z = \frac{\max(R, G, B) + \min(R, G, B)}{2}$$

```cpp
int z1 = (max({p[2], p[1], p[0]}) + min({p[2], p[1], p[0]})) / 2;
gLightness.at<uchar>(y, x) = saturate_cast<uchar>(z1);
```

![Grayscale Lightness](output/grayscale_lightness.png)

### 2.2 Average Method

Method ini menghitung rata-rata aritmatika dari seluruh color channel:

$$z = \frac{R + G + B}{3}$$

```cpp
int z2 = (p[2] + p[1] + p[0]) / 3;
gAverage.at<uchar>(y, x) = saturate_cast<uchar>(z2);
```

![Grayscale Average](output/grayscale_average.png)

### 2.3 Luminosity Method

Method ini menggunakan weighted sum berdasarkan persepsi visual manusia, di mana mata manusia lebih sensitif terhadap warna hijau:

$$z = 0.21R + 0.71G + 0.07B$$

```cpp
int z3 = (0.21 * p[2]) + (0.71 * p[1]) + (0.07 * p[0]);
gLuminosity.at<uchar>(y, x) = saturate_cast<uchar>(z3);
```

![Grayscale Luminosity](output/grayscale_luminosity.png)

**Analisis:** Dari ketiga method, luminosity menghasilkan grayscale paling natural — transisi antara area terang dan gelap terasa halus dan sesuai persepsi visual. Average method menghasilkan tone yang sedikit lebih terang karena seluruh channel dibobot rata. Lightness method cenderung kehilangan contrast pada area yang memiliki variasi warna signifikan karena hanya memperhitungkan extreme value.

---

## 3. Image Negative

Transformation function untuk image negative didefinisikan sebagai:

$$s = (L - 1) - r$$

di mana $L$ adalah jumlah intensity level (256 untuk image 8-bit) dan $r$ adalah intensity pixel input. Transformasi ini membalik seluruh intensity value sehingga area gelap menjadi terang dan sebaliknya.

```cpp
gNegative.at<Vec3b>(y, x) = Vec3b(L - p[0], L - p[1], L - p[2]);
```

| Image OG                   | Hasil Negative                   |
| -------------------------- | -------------------------------- |
| ![OG](output/gamma_10.png) | ![Negative](output/negative.png) |

**Analisis:** Pada hasil negative, seluruh warm color (coklat, merah, kuning) berubah menjadi cool color (biru, cyan, hijau) dan sebaliknya. Area yang semula terang menjadi gelap, background gelap menjadi terang. Setiap channel dibalik independen — high red value menjadi low red, sehingga area bermata merah misalnya berubah menjadi cyan. Transformasi ini berguna untuk mengungkapkan detail tersembunyi pada region yang terlalu terang atau terlalu gelap.

---

## 4. Log Transformation

Log transformation didefinisikan sebagai:

$$s = c \cdot \log(1 + r)$$

di mana $c$ adalah scaling constant yang dihitung sebagai:

$$c = \frac{L}{\log(1 + L)}$$

Penambahan $1$ pada argumen logaritma mencegah kondisi $\log(0)$ yang undefined. Transformasi ini memetakan rentang intensity rendah yang sempit ke rentang yang lebih lebar pada output, sementara mengkompresi nilai-nilai intensity tinggi.

```cpp
double c = 255.0 / std::log(1 + 255.0);
gLogT.at<Vec3b>(y, x) =
    Vec3b(saturate_cast<uchar>(c * std::log(1.0 + p[0])),
          saturate_cast<uchar>(c * std::log(1.0 + p[1])),
          saturate_cast<uchar>(c * std::log(1.0 + p[2])));
```

| Image OG                   | Hasil Log Transform              |
| -------------------------- | -------------------------------- |
| ![OG](output/gamma_10.png) | ![Log](output/log_transform.png) |

**Pada dark image (PG):**

| Image PG                      | Hasil Log Transform PG                 |
| ----------------------------- | -------------------------------------- |
| ![PG](output/pg_gamma_10.png) | ![Log PG](output/pg_log_transform.png) |

**Analisis:** Terlihat bahwa log transformation membuat keseluruhan image menjadi lebih terang dan washed-out — shadow kehilangan kedalaman dan warna menjadi lebih pucat. Ini karena log curve menarik dark pixel ke atas secara agresif sambil mengkompresi bright pixel. Efeknya jauh lebih dramatis pada image PG yang gelap, di mana detail shadow yang sebelumnya tersembunyi menjadi visible. Penggunaan utama log transformation adalah untuk menampilkan Fourier spectrum dengan dynamic range jutaan level.

---

## 5. Power-Law (Gamma) Transformation

Power-law transformation didefinisikan sebagai:

$$s = c \cdot r^\gamma$$

Dalam implementasi, formula ini dinormalisasi menjadi:

$$s = L \cdot \left(\frac{r}{L}\right)^\gamma$$

untuk menjaga pixel value dalam valid range $[0, L]$. Tiga gamma value digunakan:

```cpp
double gammas[3] = {0.4, 1.0, 3.0};
gGamma[g].at<Vec3b>(y, x) =
    Vec3b(saturate_cast<uchar>(L * std::pow(p[0] / L, gammas[g])),
          saturate_cast<uchar>(L * std::pow(p[1] / L, gammas[g])),
          saturate_cast<uchar>(L * std::pow(p[2] / L, gammas[g])));
```

### 5.1 Gamma = 0.4 (Dark Image Correction)

Ketika $\gamma < 1$, transformasi memperluas rentang dark pixel. Karena bilangan desimal di antara 0 dan 1 dipangkatkan dengan eksponen yang lebih kecil dari 1 akan menghasilkan nilai yang lebih besar, dark pixel secara efektif dicerahkan.

| Image OG                   | $\gamma = 0.4$                    |
| -------------------------- | --------------------------------- |
| ![OG](output/gamma_10.png) | ![Gamma 0.4](output/gamma_04.png) |

| Image PG                      | PG $\gamma = 0.4$                       |
| ----------------------------- | --------------------------------------- |
| ![PG](output/pg_gamma_10.png) | ![PG Gamma 0.4](output/pg_gamma_04.png) |

### 5.2 Gamma = 1.0 (Identity)

Ketika $\gamma = 1$, transformasi menghasilkan image identik dengan input karena $r^1 = r$.

### 5.3 Gamma = 3.0 (Contrast Enhancement)

Ketika $\gamma > 1$, transformasi mengkompresi dark pixel dan memperluas bright pixel. Bilangan desimal yang sudah kecil (misalnya 0.2) ketika dipangkatkan 3 menjadi sangat kecil ($0.2^3 = 0.008$), sehingga shadow detail dihancurkan dan contrast meningkat drastis.

| Image OG                   | $\gamma = 3.0$                    |
| -------------------------- | --------------------------------- |
| ![OG](output/gamma_10.png) | ![Gamma 3.0](output/gamma_30.png) |

| Image PG                      | PG $\gamma = 3.0$                       |
| ----------------------------- | --------------------------------------- |
| ![PG](output/pg_gamma_10.png) | ![PG Gamma 3.0](output/pg_gamma_30.png) |

**Analisis:** Gamma 0.4 membuat image terlihat lebih pucat dan flat — shadow hilang, warna memudar. Gamma 3.0 secara drastis menggelapkan seluruh shadow region hingga menjadi pure black, namun area bright tetap terjaga, menghasilkan high contrast. Pada dark image PG, gamma 0.4 berhasil memunculkan detail yang sebelumnya tidak terlihat, sedangkan gamma 3.0 membuat image hampir sepenuhnya hitam. Gamma transformation juga merupakan standar industri untuk display correction — monitor menerapkan gamma sekitar 2.5 secara natural, sehingga software mengkompensasi dengan gamma 0.4.

---

## 6. Contrast Stretching

Contrast stretching merupakan piecewise-linear transformation yang memperluas intensity range sehingga mencakup seluruh intensity scale. Transformation function menggunakan dua control point $(r_{min}, 0)$ dan $(r_{max}, L-1)$:

$$s = \frac{(r - r_{min}) \cdot L}{r_{max} - r_{min}}$$

di mana $r_{min}$ dan $r_{max}$ diperoleh menggunakan `cv::minMaxLoc` pada image input.

```cpp
double rmin, rmax;
minMaxLoc(og.reshape(1), &rmin, &rmax);
gContrast.at<Vec3b>(y, x) =
    Vec3b(saturate_cast<uchar>((p[0] - rmin) * L / (rmax - rmin)),
          saturate_cast<uchar>((p[1] - rmin) * L / (rmax - rmin)),
          saturate_cast<uchar>((p[2] - rmin) * L / (rmax - rmin)));
```

| Image OG                   | Hasil Contrast Stretching                |
| -------------------------- | ---------------------------------------- |
| ![OG](output/gamma_10.png) | ![Contrast](output/contrast_stretch.png) |

**Analisis:** Hasil contrast stretching terlihat hampir identik dengan original, menunjukkan bahwa image OG sudah memiliki intensity range yang mendekati full range $[0, L]$. Contrast stretching akan memberikan efek paling dramatis pada image dengan low-contrast di mana seluruh pixel terkumpul di rentang sempit. Transformasi ini secara linear memetakan $[r_{min}, r_{max}]$ ke $[0, L]$.

---

## 7. Bit-Plane Slicing

Setiap pixel dalam image 8-bit terdiri dari 8 bit, di mana bit ke-$n$ merepresentasikan nilai $2^{n-1}$. Image dapat didekomposisi menjadi delapan bit-plane menggunakan bitwise AND operation dengan mask $2^{n-1}$:

$$\text{bit-plane}_n(x, y) = \begin{cases} 255 & \text{jika } f(x,y) \wedge 2^{n-1} \neq 0 \\ 0 & \text{selainnya} \end{cases}$$

```cpp
for (int i = 0; i < 8; ++i)
    gBitplane[i].at<uchar>(y, x) = (z3 & (1 << i)) ? 255 : 0;
```

| Bit-Plane 8 (MSB)             | Bit-Plane 7                   | Bit-Plane 6                   | Bit-Plane 5                   |
| ----------------------------- | ----------------------------- | ----------------------------- | ----------------------------- |
| ![BP8](output/bitplane_8.png) | ![BP7](output/bitplane_7.png) | ![BP6](output/bitplane_6.png) | ![BP5](output/bitplane_5.png) |

| Bit-Plane 4                   | Bit-Plane 3                   | Bit-Plane 2                   | Bit-Plane 1 (LSB)             |
| ----------------------------- | ----------------------------- | ----------------------------- | ----------------------------- |
| ![BP4](output/bitplane_4.png) | ![BP3](output/bitplane_3.png) | ![BP2](output/bitplane_2.png) | ![BP1](output/bitplane_1.png) |

**Analisis:** Bit-plane 8 (MSB) menampilkan siluet dan bentuk utama — area terang (intensity > 128) menjadi putih, area gelap menjadi hitam. Bit-plane 7 menangkap detail transisi dan shading. Semakin turun ke bit-plane rendah, informasi visual semakin berkurang hingga bit-plane 1–2 hanya menampilkan random noise tanpa korelasi visual. Empat bit-plane tertinggi sudah cukup untuk merekonstruksi image yang recognizable, memungkinkan 50% storage saving dalam image compression.

---

## 8. Image Subtraction

Image subtraction didefinisikan sebagai:

$$g(x, y) = f(x, y) - h(x, y)$$

di mana operasi dilakukan secara elementwise pada setiap pasangan pixel yang berkorespondensi. Jika dua image identik, subtraction menghasilkan all-zero (pure black) image.

### 8.1 LSB Change Detection

Original image dikurangi dengan versi yang telah di-zero-kan least significant bit-nya menggunakan mask `0xFE` ($11111110_2$). Secara visual, kedua image tidak dapat dibedakan, tetapi subtraction mengungkapkan lokasi-lokasi di mana LSB bernilai 1.

```cpp
int z3 = (0.21 * p[2]) + (0.71 * p[1]) + (0.07 * p[0]);
int lsb = z3 & 0xFE;
gSubLSB.at<uchar>(y, x) = (z3 != lsb) ? 255 : 0;
```

| Image OG                   | Subtract (OG vs LSB-zeroed)               |
| -------------------------- | ----------------------------------------- |
| ![OG](output/gamma_10.png) | ![Sub LSB](output/subtract_og_vs_lsb.png) |

### 8.2 Resolution Loss Detection

Original image dikurangi dengan low-resolution version dari dirinya sendiri. Image input diperkecil 50% menggunakan `INTER_NEAREST` dan diperbesar kembali ke original size. Pixel yang paling terang dalam difference image menunjukkan area di mana detail information paling banyak hilang.

```cpp
resize(og, lowres, Size(), 0.5, 0.5, INTER_NEAREST);
resize(lowres, lowresUp, og.size(), 0, 0, INTER_NEAREST);
gSubLowres.at<Vec3b>(y, x) = Vec3b(
    saturate_cast<uchar>(p[0] - r[0]),
    saturate_cast<uchar>(p[1] - r[1]),
    saturate_cast<uchar>(p[2] - r[2]));
```

| Image OG                   | Subtract (OG vs Low-res)                        |
| -------------------------- | ----------------------------------------------- |
| ![OG](output/gamma_10.png) | ![Sub Lowres](output/subtract_og_vs_lowres.png) |

### 8.3 Subtraction dengan Image Negative

Mengikuti prinsip *digital subtraction angiography*, original image dikurangi dengan image negative-nya. Teknik ini mensimulasikan proses *mask mode radiography* di mana mask image dan live image dikurangkan untuk mengisolasi perubahan.

```cpp
Vec3b neg = gNegative.at<Vec3b>(y, x);
gSubAngio.at<Vec3b>(y, x) = Vec3b(
    saturate_cast<uchar>(p[0] - neg[0]),
    saturate_cast<uchar>(p[1] - neg[1]),
    saturate_cast<uchar>(p[2] - neg[2]));
```

| Image OG                   | Subtract (OG vs Negative)                        |
| -------------------------- | ------------------------------------------------ |
| ![OG](output/gamma_10.png) | ![Sub Angio](output/subtract_og_vs_negative.png) |

---

## 9. Logical Operations

Logical operation (AND, OR, XOR) bekerja pada pasangan pixel yang berkorespondensi. Pada image 8-bit, operasi ini dilakukan secara bitwise pada setiap bit dari binary representation pixel. Truth table untuk ketiga operasi:

| $a$ | $b$ | $a \wedge b$ (AND) | $a \vee b$ (OR) | $a \oplus b$ (XOR) |
| --- | --- | ------------------ | --------------- | ------------------ |
| 0   | 0   | 0                  | 0               | 0                  |
| 0   | 1   | 0                  | 1               | 1                  |
| 1   | 0   | 0                  | 1               | 1                  |
| 1   | 1   | 1                  | 1               | 0                  |

### 9.1 AND Operation

AND menghasilkan 1 hanya jika kedua bit bernilai 1. Operasi ini berfungsi sebagai filter yang hanya mempertahankan informasi yang shared antara kedua image.

**AND dengan Image Negative:**

```cpp
Vec3b neg = gNegative.at<Vec3b>(y, x);
gAND.at<Vec3b>(y, x) = Vec3b(p[0] & neg[0], p[1] & neg[1], p[2] & neg[2]);
```

![AND](output/bitwise_and.png)

**AND dengan Circle Mask (Region of Interest):**

Operasi AND digunakan untuk *masking*, di mana image di-AND-kan dengan binary mask yang bernilai 255 pada region of interest dan 0 di area lainnya.

```cpp
Mat mask = gC3.clone();
circle(mask, Point(og.cols / 2, og.rows / 2), og.rows / 3,
       Scalar(255, 255, 255), -1);
gANDMask.at<Vec3b>(y, x) = Vec3b(p[0] & m[0], p[1] & m[1], p[2] & m[2]);
```

![AND Mask](output/bitwise_and_mask.png)

### 9.2 OR Operation

OR menghasilkan 1 jika salah satu atau kedua bit bernilai 1. Operasi ini berguna untuk menggabungkan informasi dari dua image.

**OR pada Dua Bit-Plane (Plane 7 dan 8):**

```cpp
gORBitplane.at<uchar>(y, x) =
    gBitplane[6].at<uchar>(y, x) | gBitplane[7].at<uchar>(y, x);
```

![OR Bitplane](output/bitwise_or_bitplane.png)

### 9.3 XOR Operation

XOR (*exclusive OR*) menghasilkan 1 hanya jika kedua bit bernilai berbeda. Operasi ini efektif untuk change detection antara dua image.

**XOR Self (OG vs OG):**

Image di-XOR-kan dengan dirinya sendiri menghasilkan all-black image, membuktikan bahwa $a \oplus a = 0$ untuk semua nilai $a$.

```cpp
gXORSelf.at<Vec3b>(y, x) = Vec3b(p[0] ^ p[0], p[1] ^ p[1], p[2] ^ p[2]);
```

![XOR Self](output/bitwise_xor_self.png)

**XOR dengan Gamma-Corrected Image ($\gamma = 0.4$):**

XOR antara original image dan gamma-corrected version menunjukkan lokasi dan magnitude perubahan intensity yang dihasilkan oleh gamma correction. Area yang lebih terang dalam XOR output menandakan perubahan yang lebih besar.

```cpp
Vec3b gam = gGamma[0].at<Vec3b>(y, x);
gXORGamma.at<Vec3b>(y, x) = Vec3b(p[0] ^ gam[0], p[1] ^ gam[1], p[2] ^ gam[2]);
```

![XOR Gamma](output/bitwise_xor_gamma.png)

---

## 10. Transformasi pada Dark Image (PG)

Untuk mendemonstrasikan efektivitas transformasi pada image dengan karakteristik berbeda, intensity transformation juga diterapkan pada image PG yang memiliki low intensity.

### 10.1 Negative PG

| Image PG                      | Hasil Negative PG                 |
| ----------------------------- | --------------------------------- |
| ![PG](output/pg_gamma_10.png) | ![PG Neg](output/pg_negative.png) |

### 10.2 Gamma Comparison pada Dark Image

| $\gamma = 0.4$ (Brightening)      | $\gamma = 1.0$ (Original)         | $\gamma = 3.0$ (High Contrast)    |
| --------------------------------- | --------------------------------- | --------------------------------- |
| ![PG G04](output/pg_gamma_04.png) | ![PG G10](output/pg_gamma_10.png) | ![PG G30](output/pg_gamma_30.png) |

**Analisis:** Pada dark image, gamma transformation dengan $\gamma = 0.4$ memberikan hasil yang paling signifikan, memunculkan shadow detail yang sebelumnya tidak terlihat. Sebaliknya, $\gamma = 3.0$ semakin menggelapkan image yang sudah gelap, sehingga hampir seluruh visual information hilang. Hal ini mengkonfirmasi bahwa $\gamma < 1$ berfungsi sebagai shadow recovery, sedangkan $\gamma > 1$ berfungsi sebagai contrast amplifier.

---

## 11. Kesimpulan

Berdasarkan hasil percobaan, dapat disimpulkan bahwa:

1. **Log Transformation dan Gamma $< 1$** paling efektif untuk memperbaiki dark image dengan memperluas low intensity range.
2. **Gamma $> 1$** menghasilkan significant contrast enhancement dengan mengkompresi shadow detail.
3. **Contrast Stretching** secara otomatis menyesuaikan intensity range berdasarkan statistik input image.
4. **Bit-Plane Slicing** menunjukkan bahwa visual information utama terkonsentrasi pada empat most significant bit-plane.
5. **Image Subtraction** mampu mengungkapkan perbedaan yang tidak terlihat secara visual.
6. **Logical Operations** berfungsi sebagai fundamental tool untuk masking, merging, dan change detection pada digital image.

---

## Referensi

Gonzalez, R.C. & Woods, R.E. (2018). *Digital Image Processing*, 4th Edition. Pearson.
