import requests
import json
import random
import os

def download_english_dict():
    url = "https://raw.githubusercontent.com/dwyl/english-words/master/words.txt"
    response = requests.get(url)
    if response.status_code == 200:
        with open("english_words.txt", "w", encoding="utf-8") as f:
            f.write(response.text)
        return True
    return False

def parse_english_dict():
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
    
    # Keywords for categories
    category_keywords = {
        "nature": ["tree", "flower", "animal", "mountain", "river", "sea", "forest", "weather"],
        "technology": ["computer", "phone", "internet", "program", "device", "tech", "digital"],
        "science": ["science", "physics", "chemistry", "biology", "math", "research", "experiment"],
        "culture": ["art", "music", "theater", "movie", "literature", "culture", "dance"],
        "sports": ["sport", "game", "team", "win", "champion", "play", "competition"],
        "food": ["food", "meal", "dish", "drink", "recipe", "cook", "kitchen"],
        "professions": ["job", "work", "profession", "expert", "master", "specialist"]
    }
    
    with open("english_words.txt", "r", encoding="utf-8") as f:
        for word in f:
            word = word.strip().lower()
            
            # Skip words that are too short or contain non-alphabetic characters
            if len(word) < 3 or not word.isalpha():
                continue
            
            # Add to common category
            words_by_category["common"].add(word)
            
            # Add to specific categories based on keywords
            for category, keywords in category_keywords.items():
                if any(keyword in word for keyword in keywords):
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
    if download_english_dict():
        words_by_category = parse_english_dict()
        
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
        with open("../Alias 2025/Resources/words_en.json", "w", encoding="utf-8") as f:
            json.dump(words, f, ensure_ascii=False, indent=4)
        
        print(f"Generated {len(words)} words")
    else:
        print("Failed to download English dictionary")

if __name__ == "__main__":
    main() 