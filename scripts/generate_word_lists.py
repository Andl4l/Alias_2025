import json
import nltk
import pymorphy2
from nltk.corpus import wordnet as wn
from collections import defaultdict
import random

# Download required NLTK data
nltk.download('wordnet')
nltk.download('averaged_perceptron_tagger')
nltk.download('universal_tagset')

def get_word_difficulty(word, language):
    """Determine word difficulty based on length and complexity"""
    if language == 'en':
        if len(word) <= 4:
            return 'easy'
        elif len(word) <= 6:
            return 'medium'
        elif len(word) <= 8:
            return 'hard'
        else:
            return 'expert'
    else:  # Russian
        if len(word) <= 5:
            return 'easy'
        elif len(word) <= 7:
            return 'medium'
        elif len(word) <= 9:
            return 'hard'
        else:
            return 'expert'

def get_english_words():
    """Get English words from WordNet"""
    words_by_category = defaultdict(set)
    
    # Get nouns
    for synset in wn.all_synsets(wn.NOUN):
        word = synset.lemmas()[0].name()
        if '_' not in word and len(word) >= 3:
            words_by_category['nouns'].add(word.lower())
    
    # Get verbs
    for synset in wn.all_synsets(wn.VERB):
        word = synset.lemmas()[0].name()
        if '_' not in word and len(word) >= 3:
            words_by_category['verbs'].add(word.lower())
    
    # Get adjectives
    for synset in wn.all_synsets(wn.ADJ):
        word = synset.lemmas()[0].name()
        if '_' not in word and len(word) >= 3:
            words_by_category['adjectives'].add(word.lower())
    
    return words_by_category

def get_russian_words():
    """Get Russian words using pymorphy2"""
    morph = pymorphy2.MorphAnalyzer()
    
    # Load OpenCorpora dictionary
    words_by_category = defaultdict(set)
    
    # This is a simplified version. In real implementation,
    # you would need to load words from a proper Russian dictionary
    basic_words = [
        # Add your Russian words here
        # This is just an example, you would need a proper source
        "книга", "дом", "человек", "время", "жизнь",
        "работать", "думать", "говорить", "идти", "делать",
        "красивый", "умный", "большой", "маленький", "хороший"
    ]
    
    for word in basic_words:
        parsed = morph.parse(word)[0]
        if parsed.tag.POS == 'NOUN':
            words_by_category['nouns'].add(word)
        elif parsed.tag.POS == 'VERB':
            words_by_category['verbs'].add(word)
        elif parsed.tag.POS == 'ADJF':
            words_by_category['adjectives'].add(word)
    
    return words_by_category

def generate_word_list(language):
    """Generate word list for specified language"""
    words = []
    
    if language == 'en':
        words_by_category = get_english_words()
    else:
        words_by_category = get_russian_words()
    
    for category, word_set in words_by_category.items():
        # Limit to 300 words per category
        word_list = list(word_set)[:300]
        for word in word_list:
            words.append({
                "text": word,
                "difficulty": get_word_difficulty(word, language),
                "category": category
            })
    
    # Shuffle words
    random.shuffle(words)
    
    return words

def main():
    # Generate English words
    english_words = generate_word_list('en')
    with open('../Alias 2025/Resources/words_en.json', 'w', encoding='utf-8') as f:
        json.dump(english_words, f, ensure_ascii=False, indent=4)
    
    # Generate Russian words
    russian_words = generate_word_list('ru')
    with open('../Alias 2025/Resources/words_ru.json', 'w', encoding='utf-8') as f:
        json.dump(russian_words, f, ensure_ascii=False, indent=4)

if __name__ == '__main__':
    main() 