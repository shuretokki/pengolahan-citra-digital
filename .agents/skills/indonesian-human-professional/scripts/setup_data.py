import json
import os
import urllib.request

DATA_DIR = "/home/shure/Documents/learning/playground/.agents/skills/indonesian-human-professional/data"

BAKU_URLS = [
    "https://raw.githubusercontent.com/lantip/baku-tidak-baku/main/daftar_baku_ivanlanin.json",
    "https://raw.githubusercontent.com/lantip/baku-tidak-baku/main/daftar_baku_lantip.json"
]

KBBI_URLS = [
    f"https://raw.githubusercontent.com/aryakdaniswara/kbbi-dataset-kbbi-v/main/json/kbbi_v_part{i}.json"
    for i in range(1, 5)
]

def download_json(url):
    print(f"Downloading {url}...")
    with urllib.request.urlopen(url) as response:
        return json.loads(response.read().decode())

def setup_baku():
    print("Setting up baku_tidak_baku.json...")
    merged = {}
    for url in BAKU_URLS:
        data = download_json(url)
        # lantip format is usually {"tidak_baku": "baku"}
        # Some might be a list or different structure, let's normalize
        if isinstance(data, dict):
            for k, v in data.items():
                if isinstance(v, str):
                    merged[k.lower()] = v.lower()
        elif isinstance(data, list):
            # If it's a list of objects
            for item in data:
                if "tidak_baku" in item and "baku" in item:
                    merged[item["tidak_baku"].lower()] = item["baku"].lower()

    with open(os.path.join(DATA_DIR, "baku_tidak_baku.json"), "w") as f:
        json.dump(merged, f, indent=2)
    print(f"Saved {len(merged)} mappings to baku_tidak_baku.json")

def setup_kbbi():
    print("Setting up kbbi_roots.json...")
    roots = set()
    for url in KBBI_URLS:
        data = download_json(url)
        for word in data.keys():
            # Filter for single words (no spaces)
            if " " not in word:
                roots.add(word.lower())

    with open(os.path.join(DATA_DIR, "kbbi_roots.json"), "w") as f:
        json.dump(sorted(list(roots)), f, indent=2)
    print(f"Saved {len(roots)} roots to kbbi_roots.json")

def setup_statics():
    print("Setting up static JSON files...")

    # Banned Phrases
    banned = [
        "penting untuk dicatat bahwa", "kesimpulannya", "namun demikian",
        "hal ini menunjukkan bahwa", "dapat diamati bahwa", "selain itu",
        "sebagai catatan", "intinya adalah", "mari kita telaah lebih dalam",
        "tapestri dari", "penting untuk mempertimbangkan", "mari kita selami",
        "lebih-lebih lagi", "sebuah bukti", "saat menavigasi kompleksitas",
        "permadani", "sinergi", "bernuansa", "komprehensif"
    ]
    with open(os.path.join(DATA_DIR, "banned_phrases.json"), "w") as f:
        json.dump(banned, f, indent=2)

    # Heritage Words
    heritage = {
        "suggested": [
            "seiring berjalannya waktu", "bahwasanya", "menurut hemat penulis",
            "adapun", "paparan", "amatan"
        ],
        "replacements": {
            "hasil": "paparan",
            "observasi": "amatan",
            "skripsi": "tugas akhir"
        }
    }
    with open(os.path.join(DATA_DIR, "heritage_words.json"), "w") as f:
        json.dump(heritage, f, indent=2)

    # Bloom's Verbs
    blooms = {
        "C1": ["menyebutkan", "menghafal", "mendaftar", "menamai", "memilih"],
        "C2": ["menjelaskan", "mengklasifikasikan", "meringkas", "membandingkan"],
        "C3": ["melaksanakan", "mempraktikkan", "mendemonstrasikan", "menggunakan"],
        "C4": ["menganalisis", "membedakan", "mengorganisasi", "menghubungkan"],
        "C5": ["memeriksa", "mengkritik", "membuktikan", "membenarkan", "menilai"],
        "C6": ["merancang", "membangun", "merencanakan", "memproduksi"]
    }
    with open(os.path.join(DATA_DIR, "blooms_verbs.json"), "w") as f:
        json.dump(blooms, f, indent=2)

if __name__ == "__main__":
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)
    setup_baku()
    setup_kbbi()
    setup_statics()
    print("Data setup complete.")
