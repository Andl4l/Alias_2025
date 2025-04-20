import requests
import json
import random
from bs4 import BeautifulSoup
import os

def download_opencorpora_dict():
    url = "https://opencorpora.org/dict.php?act=export"
    response = requests.get(url)
    if response.status_code == 200:
        with open("dict.opcorpora.xml", "wb") as f:
            f.write(response.content)
        return True
    return False

def parse_opencorpora_dict():
    words_by_category = {
        "nouns": set(),
        "verbs": set(),
        "adjectives": set(),
        "common": set(),
        "nature": set(),
        "technology": set(),
        "science": set(),
        "culture": set(),
        "sports": set(),
        "food": set(),
        "professions": set()
    }
    
    # Категории слов
    categories = {
        "nouns": ["NOUN"],
        "verbs": ["VERB", "INFN"],
        "adjectives": ["ADJF", "ADJS"],
        "common": ["NOUN", "VERB", "ADJF", "ADJS"],
        "nature": ["NOUN", "ADJF"],
        "technology": ["NOUN", "ADJF"],
        "science": ["NOUN", "ADJF"],
        "culture": ["NOUN", "ADJF"],
        "sports": ["NOUN", "ADJF"],
        "food": ["NOUN", "ADJF"],
        "professions": ["NOUN", "ADJF"]
    }
    
    # Ключевые слова для категорий
    category_keywords = {
        "nature": ["природа", "животное", "растение", "погода", "река", "гора", "лес", "море"],
        "technology": ["техника", "компьютер", "телефон", "интернет", "программа", "устройство"],
        "science": ["наука", "физика", "химия", "биология", "математика", "исследование"],
        "culture": ["культура", "искусство", "музыка", "театр", "кино", "литература"],
        "sports": ["спорт", "игра", "соревнование", "команда", "победа", "чемпион"],
        "food": ["еда", "продукт", "блюдо", "напиток", "рецепт", "кухня"],
        "professions": ["профессия", "работа", "специалист", "мастер", "эксперт"]
    }
    
    with open("dict.opcorpora.xml", "r", encoding="utf-8") as f:
        soup = BeautifulSoup(f.read(), "xml")
        
        for lemma in soup.find_all("lemma"):
            word = lemma.find("l").text
            gram = lemma.find("g").text if lemma.find("g") else ""
            
            # Распределяем слова по категориям
            for category, pos_tags in categories.items():
                if any(tag in gram for tag in pos_tags):
                    if category in category_keywords:
                        # Для специальных категорий проверяем ключевые слова
                        if any(keyword in word.lower() for keyword in category_keywords[category]):
                            words_by_category[category].add(word)
                    else:
                        words_by_category[category].add(word)
    
    return words_by_category

def get_word_difficulty(word):
    length = len(word)
    if length <= 5:
        return "easy"
    elif length <= 8:
        return "medium"
    else:
        return "hard"

def main():
    if download_opencorpora_dict():
        words_by_category = parse_opencorpora_dict()
        
        # Convert to the format needed for the game
        words = []
        for category, word_set in words_by_category.items():
            for word in word_set:
                words.append({
                    "text": word,
                    "difficulty": get_word_difficulty(word),
                    "category": category
                })
        
        # Save to JSON
        with open("../Alias 2025/Resources/words_ru.json", "w", encoding="utf-8") as f:
            json.dump(words, f, ensure_ascii=False, indent=4)
        
        print(f"Generated {len(words)} words")
    else:
        print("Failed to download OpenCorpora dictionary")

if __name__ == "__main__":
    main() 