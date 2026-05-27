# Indonesian Morphology Reference

Curated from *Tata Bahasa Baku Bahasa Indonesia* (4th ed.) and the Nazief-Adriani stemming algorithm. This reference covers the affix system relevant to the validator's L2 (stemming) and L8 (passive voice) layers.

---

## 1. Affix Classification

Indonesian word formation relies on four types of affixation:

| Type                    | Indonesian | Position               | Productivity |
| ----------------------- | ---------- | ---------------------- | ------------ |
| Prefix (Awalan)         | Awalan     | Before root            | High         |
| Suffix (Akhiran)        | Akhiran    | After root             | High         |
| Infix (Sisipan)         | Sisipan    | Inside root (after C₁) | Low          |
| Confix (Imbuhan Gabung) | Konfiks    | Simultaneous pair      | High         |

---

## 2. Prefixes (Awalan)

### 2.1 Derivational Prefixes

| Prefix | Function                     | Example          |
| ------ | ---------------------------- | ---------------- |
| `meN-` | Active voice verb former     | tulis → menulis  |
| `di-`  | Passive voice marker         | tulis → ditulis  |
| `ber-` | Intransitive/stative verb    | main → bermain   |
| `ter-` | Accidental/superlative       | bawa → terbawa   |
| `peN-` | Agent/instrument noun        | tulis → penulis  |
| `per-` | Causative verb / noun former | tanda → pertanda |
| `ke-`  | Ordinal / abstract noun      | dua → kedua      |
| `se-`  | One / equal to               | hari → sehari    |

### 2.2 Morphophonemic Rules for `meN-`

The nasal (`N`) in `meN-` assimilates to the initial consonant of the root. Some consonants are deleted (luluh) in the process.

| Root Initial     | meN- becomes | Consonant Luluh? | Example                        |
| ---------------- | ------------ | ---------------- | ------------------------------ |
| b, f             | mem-         | No               | baca → membaca                 |
| p                | mem-         | Yes (p drops)    | pakai → memakai                |
| d                | men-         | No               | dapat → mendapat               |
| t                | men-         | Yes (t drops)    | tulis → menulis                |
| c, j             | men-         | No               | cari → mencari                 |
| g, h, kh         | meng-        | No               | gali → menggali                |
| k                | meng-        | Yes (k drops)    | kirim → mengirim               |
| s                | meny-        | Yes (s drops)    | sapu → menyapu                 |
| vowel            | meng-        | No               | ambil → mengambil              |
| l, m, n, r, w, y | me-          | No               | lari → melari, rawat → merawat |

### 2.3 Morphophonemic Rules for `peN-`

Follows the same nasal assimilation as `meN-`:

| Root Initial | peN- becomes | Consonant Luluh? | Example           |
| ------------ | ------------ | ---------------- | ----------------- |
| b, f         | pem-         | No               | baca → pembaca    |
| p            | pem-         | Yes              | pakai → pemakai   |
| d            | pen-         | No               | didik → pendidik  |
| t            | pen-         | Yes              | tulis → penulis   |
| c, j         | pen-         | No               | curi → pencuri    |
| g, h, kh     | peng-        | No               | gali → penggali   |
| k            | peng-        | Yes              | kirim → pengirim  |
| s            | peny-        | Yes              | sapu → penyapu    |
| vowel        | peng-        | No               | ambil → pengambil |
| l, m, n, r   | pe-          | No               | lari → pelari     |

### 2.4 Allomorphs of `ber-`

| Condition            | Form | Example           |
| -------------------- | ---- | ----------------- |
| Default              | ber- | main → bermain    |
| Root starts with `r` | be-  | renang → berenang |
| Root = `ajar`        | bel- | ajar → belajar    |

### 2.5 Allomorphs of `ter-`

| Condition            | Form | Example        |
| -------------------- | ---- | -------------- |
| Default              | ter- | bawa → terbawa |
| Root starts with `r` | te-  | rasa → terasa  |

---

## 3. Suffixes (Akhiran)

### 3.1 Derivational Suffixes

| Suffix | Function                   | Example          |
| ------ | -------------------------- | ---------------- |
| `-kan` | Causative / benefactive    | tulis → tuliskan |
| `-i`   | Locative / repetitive      | dekat → dekati   |
| `-an`  | Noun former (result/place) | tulis → tulisan  |

### 3.2 Inflectional Suffixes (Particles)

These are stripped first by the Nazief-Adriani algorithm:

| Suffix | Function           | Example |
| ------ | ------------------ | ------- |
| `-lah` | Emphasis           | bacalah |
| `-kah` | Question particle  | apakah  |
| `-tah` | Archaic question   | apatah  |
| `-pun` | Inclusive particle | adapun  |

### 3.3 Possessive Pronouns (Klitik)

| Suffix | Meaning     | Example |
| ------ | ----------- | ------- |
| `-ku`  | my          | bukuku  |
| `-mu`  | your        | bukumu  |
| `-nya` | his/her/its | bukunya |

---

## 4. Infixes (Sisipan)

Infixes are inserted after the first consonant of the root word. They are **unproductive** in modern Indonesian — no new words are formed with infixes today.

| Infix  | Example                                |
| ------ | -------------------------------------- |
| `-el-` | tunjuk → telunjuk, gembung → gelembung |
| `-em-` | guruh → gemuruh, getar → gemetar       |
| `-er-` | gigi → gerigi, suling → seruling       |
| `-in-` | sambung → sinambung                    |

---

## 5. Confixes (Imbuhan Gabung / Apitan)

Confixes are prefix-suffix pairs that attach **simultaneously** — removing either half changes the meaning entirely.

| Confix        | Function                  | Example               |
| ------------- | ------------------------- | --------------------- |
| `ke-...-an`   | Abstract noun / state     | indah → keindahan     |
| `peN-...-an`  | Process / place noun      | didik → pendidikan    |
| `per-...-an`  | Place / collective noun   | temu → pertemuan      |
| `ber-...-an`  | Reciprocal / scattered    | hambur → berhamburan  |
| `se-...-nya`  | Superlative               | baik → sebaik-baiknya |
| `meN-...-kan` | Causative transitive verb | tulis → menuliskan    |
| `meN-...-i`   | Locative transitive verb  | dekat → mendekati     |
| `di-...-kan`  | Passive causative         | tulis → dituliskan    |
| `di-...-i`    | Passive locative          | dekat → didekati      |

---

## 6. Borrowed Affixes (Afiks Serapan)

These are common in academic writing but are **not processed** by PySastrawi:

| Affix    | Origin    | Example                   |
| -------- | --------- | ------------------------- |
| `a-`     | Greek     | amoral, asimetris         |
| `anti-`  | Greek     | antibakteri, antisosial   |
| `pra-`   | Sanskrit  | prasejarah, prasarana     |
| `pasca-` | Sanskrit  | pascasarjana, pascapanen  |
| `pro-`   | Latin     | proaktif, prodemokrasi    |
| `non-`   | English   | nonformal, nonaktif       |
| `-isme`  | Greek     | nasionalisme, liberalisme |
| `-isasi` | Lat/Dutch | modernisasi, digitalisasi |
| `-logi`  | Greek     | teknologi, biologi        |
| `-is`    | Greek     | praktis, teoretis         |
| `-wan`   | Sanskrit  | ilmuwan, hartawan         |
| `-wati`  | Sanskrit  | seniwati, wartawati       |

---

## 7. Passive Voice Morphology

This section is directly relevant to our L8 (classify_passive) layer.

### 7.1 Standard Passive (Pasif di-)

Formation: `di-` + verb root (+ optional `oleh` + agent)

```
Buku itu ditulis oleh mahasiswa.
         ↑ di-tulis = standard passive
```

### 7.2 Pasif Persona (Type 2 Passive)

Formation: pronoun + verb root (no prefix)

| Standard Passive    | Pasif Persona |
| ------------------- | ------------- |
| ditulis oleh saya   | saya tulis    |
| ditulis oleh kami   | kami tulis    |
| ditulis oleh kita   | kita tulis    |
| ditulis oleh kamu   | kamu tulis    |
| ditulis oleh mereka | mereka tulis  |

**Rule:** Pasif Persona is preferred in Indonesian academic writing when the agent is a pronoun. It avoids the redundancy of `oleh + pronoun` and produces a more natural, human-sounding sentence.

### 7.3 ter- Passive (Accidental)

Formation: `ter-` + verb root

```
Pintu itu terbuka dengan sendirinya.
          ↑ ter-buka = accidental/unintentional
```

This is distinct from `di-` passive and carries a connotation of unintentional action.

---

## 8. Reduplication (Perulangan)

Not directly used by the validator, but noted for completeness:

| Type     | Pattern     | Example             |
| -------- | ----------- | ------------------- |
| Full     | R + R       | buku → buku-buku    |
| Partial  | C₁ + R      | laki → lelaki       |
| Affixed  | R-R + affix | sayur → sayur-mayur |
| Semantic | R₁ + R₂     | warna → warna-warni |

---

## 9. Stemming Pipeline (Nazief-Adriani / ECS)

The algorithm used by PySastrawi follows this order:

```
1. Dictionary lookup (if found → return root)
2. Strip inflectional suffixes:    -lah, -kah, -tah, -pun
3. Strip possessive suffixes:      -ku, -mu, -nya
4. Strip derivational suffix:      -i, -an, -kan
5. Strip derivational prefix:      di-, ke-, se-, ber-, ter-, meN-, peN-
   └── Apply recoding rules if needed (restore luluh consonant)
6. Check dictionary after each step
7. If no root found → return original word
```

**ECS Enhancement:** Enhanced Confix Stripping adds rules for handling confixes (`ke-...-an`, `peN-...-an`, etc.) where both parts must be removed together.

---

## References

- Alwi, H., Dardjowidjojo, S., Lapoliwa, H., & Moeliono, A. M. (2019). *Tata Bahasa Baku Bahasa Indonesia* (4th ed.). Badan Pengembangan dan Pembinaan Bahasa.
- Asian, J., Williams, H. E., & Tahaghoghi, S. M. M. (2005). Stemming Indonesian. *Australasian Document Computing Symposium*.
- Confix Stripping: Arifin, A. Z., Mahendra, I. P. A. K., & Ciptaningtyas, H. T. (2009). Enhanced Confix Stripping Stemmer and Ants Algorithm for Classifying News Document in Indonesian Language.
