# Morfologi Citra

2

# Morfologi Citra

* Apa yang bisa dilakukan oleh morfologi citra ?

* Operasi morfologi :
    * Fit dan Hit
    * Erosi (Erosion)
    * Dilasi (Dilation)
    * Operasi Gabungan (Compound Operations)

```mermaid
graph BT
    L1_Hit[Hit] --> L2_Dilation[Dilation]
    L1_Fit[Fit] --> L2_Erosion[Erosion]
    L2_Dilation --> L3_Compound[Compound operations]
    L2_Erosion --> L3_Compound

    subgraph Levels
        direction LR
        Level1[Level 1:]
        Level2[Level 2:]
        Level3[Level 3:]
    end

    %% Positioning labels next to nodes
    Level1 --- L1_Hit
    Level2 --- L2_Dilation
    Level3 --- L3_Compound

    style Levels fill:none,stroke:none
    style Level1 fill:none,stroke:none
    style Level2 fill:none,stroke:none
    style Level3 fill:none,stroke:none
```

3

# Kegunaan Morfologi

* Remove Noise
    - Small Objects

![Microscopic image with noise](page_3_image_3_v2.jpg)
![Binary image with significant noise](page_3_image_2_v2.jpg)
![Binary image with noise removed, showing only small objects](page_3_image_1_v2.jpg)

* Fill holes

![Binary image of shapes with internal holes](page_3_image_4_v2.jpg)
![Binary image of shapes with holes filled](page_3_image_5_v2.jpg)

4

# Kegunaan Morfologi

## 🞇 Isolate Objects

![Original grayscale image of overlapping circular objects](page_4_image_1_v2.jpg)
![Binary image of the circular objects](page_4_image_3_v2.jpg)
![Image showing isolated circular objects after morphological processing](page_4_image_2_v2.jpg)

![Binary image containing dots and lines](page_4_image_4_v2.jpg)
![Image showing only the dots isolated from the lines using morphological operations](page_4_image_5_v2.jpg)

5

# Cara Kerja Morfologi Citra

* Konversi citra ke dalam bentuk Grayscale
* Lakukan binerisasi citra $\rightarrow$ Thresholding
* Morfologi

![Citra mikroskopis sel dalam skala abu-abu (grayscale)](page_5_image_2_v2.jpg)
![Hasil binerisasi citra dengan thresholding, menunjukkan bintik-bintik putih pada latar belakang hitam dengan banyak noise](page_5_image_1_v2.jpg)
![Hasil operasi morfologi pada citra biner, menunjukkan objek-objek utama yang lebih bersih dan terpisah tanpa noise kecil](page_5_image_3_v2.jpg)

* Dapat juga diterapkan pada citra grayscale

6

# Hit dan Fit untuk Citra 1D

![Diagram showing an input image array [1, 0, 0, 0, 1, 1, 1, 0, 1, 1], a structuring element [1, 1, 1], and an output image array with a placeholder 0/1. Arrows indicate the process of applying the SE to the input image. Text "Desain SE sesuai keinginan" is next to the SE.](xkui)

**Hit: If just one of the '1's in the SE match with the input => output = 1, otherwise output = 0**

**Fit: If all '1's in the SE match with input => output = 1, otherwise output = 0**

7

# Dilasi (Dilation) berdasarkan Operasi Hit

![Diagram showing the dilation process using a structuring element on an input image array to produce an output image array.](page_7_image_1_v2.jpg)

**Input image**

**Structuring Element (SE)**

$$g(x) = f(x) \oplus SE$$

**Output Image**

**Hit: If just one of the '1's in the SE match with the input => output = 1, otherwise output = 0**

8

# Contoh Dilasi

![Diagram showing a dilation operation with an Input array, a Structuring Element (SE), and an Output array. The Input array is [1, 0, 0, 0, 1, 1, 1, 0, 1, 1]. The SE is [1, 1, 1]. The Output array shows the first two results as [EMPTY, 1, 0, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY].](zszn)


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

9

# Contoh Dilasi


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Diagram showing a 1D dilation operation with an Input array, a Structuring Element (SE), and the resulting Output array.](page_9_image_1_v2.jpg)

10

# Contoh Dilasi


**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_10_image_2_v2.jpg)


**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_10_image_2_v2.jpg)


**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

11

# Contoh Dilasi



**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_11_image_1_v2.jpg)

**SE**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Down arrow](page_11_image_1_v2.jpg)

**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

12

# Contoh Dilasi


**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_12_image_2_v2.jpg)


**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_12_image_2_v2.jpg)


**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

13

# Contoh Dilasi


**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>


**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>


**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

14

# Contoh Dilasi



**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![arrow down](page_14_image_1_v2.jpg)

**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
  </tbody>
</table>

**Object (1) menjadi lebih besar dan holes (0) menjadi terisi dengan object atau hilang**

15

# Erosi (Erosion) berdasarkan Operasi Fit

![Diagram showing the erosion process on a 1D binary image using a structuring element. An input image array [1, 0, 0, 0, 1, 1, 1, 0, 1, 1] is processed by a structuring element [1, 1, 1]. The formula g(x) = f(x) ⊖ SE is shown. The output image shows a '0' at the second position, illustrating the 'Fit' operation.](zjfn)

$$g(x) = f(x) \ominus SE$$

**Fit: If all '1's in the SE match with input => output = 1, otherwise output = 0**

16

# Contoh Erosi








<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Diagram illustrating the erosion process with an Input array, a Structuring Element (SE), and the resulting Output array.](page_16_image_1_v2.jpg)

17

# Contoh Erosi



**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_17_image_1_v2.jpg)

**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Down arrow](page_17_image_1_v2.jpg)

**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

18

# Contoh Erosi



**Input**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![down arrow](page_18_image_1_v2.jpg)

**SE**
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![down arrow](page_18_image_1_v2.jpg)

**Output**
<table>
  <tbody>
    <tr>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

19

# Contoh Erosi


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>↓</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Diagram showing the process of morphological erosion on a 1D binary array using a structuring element (SE).](page_19_image_1_v2.jpg)

20

# Contoh Erosi


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>0</td>
        <td> </td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Diagram showing an erosion operation with an Input array, a Structuring Element (SE), and the resulting Output array.](page_20_image_1_v2.jpg)

Output

21

# Contoh Erosi

![Diagram showing an erosion operation on a 1D binary array. An input array [1, 0, 0, 0, 1, 1, 1, 0, 1, 1] is processed with a structuring element (SE) [1, 1, 1] to produce an output array [EMPTY, 0, 0, 0, 0, 1, 0, 0, EMPTY, EMPTY]. Yellow arrows indicate the flow from Input to SE and then to Output.](mcum)


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

22

# Contoh Erosi


<table>
  <tbody>
    <tr>
        <td>Input</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>SE</td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td>Output</td>
        <td> </td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Diagram showing the erosion process on a binary array. The Input array is [1, 0, 0, 0, 1, 1, 1, 0, 1, 1]. The Structuring Element (SE) is [1, 1, 1]. The resulting Output array is [0, 0, 0, 0, 1, 0, 0, 0], showing that the object (represented by 1s) has become smaller.](gbho)

**Object (1) menjadi lebih kecil**

23

# Morfologi Citra

* Structuring Elements (SE) dapat terdiri dari sebarang ukuran sesuai dengan kebutuhan
* Nilai dari elemen adalah **0** atau **1**, namun dimungkinkan memiliki nilai yang lain (termasuk tidak ada nilainya)
* Nilai kosong pada SE berarti bebas (*don't care*)

![Illustration of a 3x3 Box structuring element with 1s in all cells and the center 1 circled.](page_23_image_5_v2.jpg)

![Illustration of a 3x3 Disc structuring element with 1s in a cross pattern and the center 1 circled.](page_23_image_4_v2.jpg)

![Illustration of a 7x7 structuring element grid with a circular pattern of 1s and the center 1 circled.](page_23_image_2_v2.jpg)


<table>
  <tbody>
    <tr>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>①</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

![Illustration of a 3x3 structuring element grid with values 1, 0, and empty cells. The center 0 is circled.](page_23_image_1_v2.jpg)

24

# Dilasi (2-Dimensi) $\leftarrow$ Hit

$$g(x, y) = f(x, y) \oplus SE$$

## Structuring Element

![3x3 grid of 1s representing a structuring element](page_24_image_3_v2.jpg)

![Binary image grid before dilation](page_24_image_1_v2.jpg)

$\longrightarrow$

![Binary image grid after dilation](page_24_image_2_v2.jpg)

* Objects tergabung (holes terisi object)

* Sudut yang tajam dihaluskan

25

# Contoh Dilasi

![Comparison of an original image showing a square with a hole and its dilated version with rounded corners and a smaller hole.](page_25_image_1_v2.jpg)


<table>
  <tbody>
    <tr>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>①</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
    </tr>
    <tr>
        <td> </td>
        <td> </td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Structuring element:
disc => rounded corners

26

# Erosi (2-Dimensi) $\leftarrow$ Fit

$$g(x, y) = f(x, y) \ominus SE$$

## Structuring Element


<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

![Binary image grid showing a shape composed of 1s on a background of 0s](page_26_image_2_v2.jpg)

$\rightarrow$

![Binary image grid showing the result of erosion, where the original shape has been reduced to a thinner line of 1s](page_26_image_3_v2.jpg)

* Objects menjadi lebih kecil

27

# Contoh Erosi

![Diagram showing an example of erosion in image processing. On the left, a white square with a small black hole inside on a black background. An arrow points to the right image, which shows the same square but slightly smaller (eroded), resulting in the internal black hole appearing larger.](page_27_image_1_v2.jpg)

28

# Aplikasi Menghitung Koin

* Kesulitan menghitung koin pada gambar di bawah disebabkan tergabungnya object koin

![Grayscale image of overlapping coins](page_28_image_1_v2.jpg)

* Solusi: Thresholding dan Erosi utk memisahkannya!

![Binary image of coins after thresholding showing merged objects](page_28_image_2_v2.jpg)

![Binary image of coins after erosion showing separated objects](page_28_image_3_v2.jpg)

29

## Compound Operations

- Menggabungkan operasi Erosion dan Dilation kedalam level operasi yang lebih tinggi (more advanced)

- Mencari garis tepi (*outline*)

- *Opening*: mengisolasi objects dan menghilangkan object-object kecil (lebih baik daripada Erosion)

- *Closing*: mengisi holes pada citra (lebih baik daripada Dilation)

30

# Mencari garis tepi (outline)

* Operasi Dilasi (object menjadi lebih besar)
* Substraksi citra asal dengan citra hasil dilasi
* Didapatkan outline

![Original binary image of a die face with one dot](page_30_image_3_v2.jpg)
![Dilated binary image of the die face, showing thicker edges and a smaller hole](page_30_image_2_v2.jpg)
![Resulting outline image after subtraction, showing only the edges of the die and the dot](page_30_image_1_v2.jpg)

31

# Opening

* Motivasi: menghilangkan object-object kecil TETAPI tetap mempertahankan ukuran aslinya
* Opening = Erosion + Dilation
        - Gunakan SE yang sama
        - Hampir sama dengan erosi tetapi tidak terlalu *destructive*
* Math:

$$f(x, y) \circ SE = (f(x, y) \ominus SE) \oplus SE$$

* Opening adalah *idempotent*: operasi opening yang diulang-ulang tidak memberikan dampak yang berkelanjutan!

32

# Contoh Opening


SE
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

## Erosion &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Dilation

![Grid representation of an image before erosion](page_32_image_1_v2.jpg) ![Arrow pointing right](page_32_image_4_v2.jpg) ![Grid representation of the image after erosion](page_32_image_3_v2.jpg) ![Arrow pointing right](page_32_chart_1_v2.jpg) ![Grid representation of the image after dilation (Opening result)](page_32_image_2_v2.jpg)

33

# Contoh Opening

* 9x3 and 3x9 Structuring Elements

![Original image with various white lines on a black background](page_33_image_1_v2.jpg)
![Yellow arrow pointing right](page_33_image_2_v2.jpg)
![Result of opening with a vertical structuring element, showing only vertical lines](page_33_image_5_v2.jpg)
![Yellow arrow pointing right](page_33_image_3_v2.jpg)
![Result of opening with a horizontal structuring element, showing only horizontal lines](page_33_image_4_v2.jpg)

34

# Contoh Opening

* Structuring Element: 11 pixel disc

![Original image of a cell colony](page_34_image_1_v2.jpg) ![Arrow pointing right](page_34_image_3_v2.jpg) ![Image after 3x erosion](page_34_image_2_v2.jpg) ![Arrow pointing right](page_34_image_5_v2.jpg) ![Image after 3x dilation](page_34_image_4_v2.jpg)

(show: cell_colony, 3 x erosion, 3 x dilation)

35

# Closing

* Motivasi: Mengisi holes TETAPI tetap menjaga ukuran aslinya
* Opening = Dilation + Erosion
    - Gunakan SE yang sama
    - Hampir sama dengan dilasi tetapi tidak terlalu *destructive*
* Math:

$$f(x, y) \bullet SE = (f(x, y) \oplus SE) \ominus SE$$

* Closing adalah *idempotent*: operasi closing yang diulang-ulang tidak memberikan dampak yang berkelanjutan!

36

# Closing

🞇 Structuring element: 3x3 square

![Binary grid representation of an image before a closing operation](page_36_image_1_v2.jpg)
$\rightarrow$
![Binary grid representation of the image after a closing operation](page_36_image_2_v2.jpg)

37

# Contoh Closing

* Operasi Closing dengan 22 piksel disc
* Menutupi holes yang kecil

![Original image showing a white circle with many black dots of various sizes inside it, on a black background.](page_37_image_1_v2.jpg)
![Yellow arrow pointing from left to right.](page_37_image_3_v2.jpg)
![Resulting image after closing operation, showing the same white circle but with only the larger black dots remaining, smaller ones have been filled.](page_37_image_2_v2.jpg)

38

# Contoh Closing

* Improve segmentation
    1. Threshold
    2. Closing dengan ukuran 20 piksel disc

![Original grayscale image of a telephone handset on a tiled floor](page_38_image_1_v2.jpg)
![Binary image after thresholding showing the handset with some internal holes](page_38_image_3_v2.jpg)
![Binary image after closing operation showing the handset with holes filled](page_38_image_2_v2.jpg)

(show: blobs-holes, 1 x dilation, 1 x erosion)

39

# Kombinasi Opening dan Closing

```mermaid
graph LR
    A[image: original binary image of a person with noise] --> B(Closing)
    B --> C[image: image after closing operation, noise inside the silhouette is filled]
    C --> D(Opening)
    D --> E[image: image after opening operation, small noise outside the silhouette is removed]
```

![Diagram showing the combination of Closing and Opening operations on a binary image of a person to remove noise.](page_39_image_1_v2.jpg)

40

# Kombinasi Opening dan Closing

![A series of images showing the process of opening and closing operations on a noisy fingerprint image. It includes the original noisy image (A), the structuring element (B), the eroded image (A ⊖ B), the opening of A (A ∘ B), the dilation of the opening, and the closing of the opening.](page_40_image_6_v2.jpg)

**FIGURE 9.11**

(a) Noisy image.

(b) Structuring element.

(c) Eroded image.

(d) Opening of *A*.

(e) Dilation of the opening.

(f) Closing of the opening. (Original image for this example courtesy of the National Institute of Standards and Technology.)

41

## Ringkasan

* Morphology

* Fit and Hit operations

* Erosion (based on Fit): Make objects smaller

  * Separate objects, remove small objects (noise)

* Dilation (based on Hit): Make objects bigger

  * Remove holes in objects

* Compound operations

  * Finding the outlines of the objects

  * Opening (Erosion + Dilation)

    * As Erosion but less destructive

  * Closing (Dilation + Erosion)

    * As Dilation but less destructive

42

# Latihan

* Diberikan citra biner:
    * Dilation
    * Erosion
    * Closing
    * Opening
* Structuring element:


<table>
  <tbody>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
  </tbody>
</table>
<table>
  <tbody>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

# Thank You !