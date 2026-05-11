import os
import subprocess
import urllib.parse
from bs4 import BeautifulSoup as soup
from urllib.request import urlopen, Request
import aiml
import warnings
import time

warnings.filterwarnings("ignore", category=DeprecationWarning)

WORLD_NEWS_URL = "https://news.google.com/rss/topics/CAAqKggKIiRDQkFTRlFvSUwyMHZNRGx1YlY4U0JYQjBMVUpTR2dKQ1VpZ0FQAQ?hl=pt-BR&gl=BR&ceid=BR%3Apt-419"

kernel = aiml.Kernel()
kernel.verbose(False)

if not hasattr(time, 'clock'):
    time.clock = time.time

def load_aiml():
    try:
        if os.path.exists("std-startup.xml"):
            kernel.bootstrap(learnFiles="std-startup.xml", commands="load aiml b")
        else:
            create_default_startup()
            kernel.bootstrap(learnFiles="std-startup.xml", commands="load aiml b")
    except:
        pass

def create_default_startup():
    startup_content = '''<?xml version="1.0" encoding="UTF-8"?>
<aiml version="1.0.1" encoding="UTF-8">
    <category>
        <pattern>CARREGAR AIML B</pattern>
        <template>
            <learn>base.aiml</learn>
        </template>
    </category>
</aiml>'''
    
    with open("std-startup.xml", "w", encoding="utf-8") as f:
        f.write(startup_content)

def get_ollama_response(prompt):
    try:
        result = subprocess.run(
            ["ollama", "run", "luna", prompt],
            capture_output=True,
            text=True,
            timeout=30
        )
        return result.stdout.strip()
    except:
        return None

def get_news(query):
    string_formatada = urllib.parse.quote(query, encoding='utf-8')
    news_url = "https://news.google.com/rss/search?q=" + string_formatada + "&hl=pt-BR&gl=BR&ceid=BR:pt-419"

    try:
        req = Request(news_url, headers={'User-Agent': 'Mozilla/5.0'})
        with urlopen(req, timeout=15) as Client:
            xml_page = Client.read()

        soup_page = soup(xml_page, "lxml-xml")
        news_list = soup_page.findAll("item")
        
        results = []
        for news in news_list[:3]:
            title = news.title.text.split(' - ')[0]
            results.append(f"- {title}")
        
        return results if results else ["Nenhuma noticia encontrada."]
    except:
        return ["Erro ao buscar noticias."]

def get_world_news():
    try:
        req = Request(WORLD_NEWS_URL, headers={'User-Agent': 'Mozilla/5.0'})
        with urlopen(req, timeout=15) as Client:
            xml_page = Client.read()

        soup_page = soup(xml_page, "lxml-xml")
        news_list = soup_page.findAll("item")
        
        results = []
        for news in news_list[:5]:
            title = news.title.text.split(' - ')[0]
            results.append(f"- {title}")
        
        return results if results else ["Nenhuma noticia mundial encontrada."]
    except:
        return ["Erro ao buscar noticias mundiais."]

def show_banner():
    biohack_path = os.path.expanduser("~/biohack.sh")
    if os.path.exists(biohack_path):
        try:
            subprocess.run([biohack_path], shell=True, check=False)
        except:
            pass

def main():
    os.system("clear")
    

    
    show_banner()
    print("=== Luna Bot ===\n")
    load_aiml()
    print("Comandos:")
    print("  /news [termo] - Buscar noticias")
    print("  /mundo       - Noticias mundiais")
    print("  /help        - Ajuda")
    print("  clear/cls - Limpar tela")
    print("  sair         - Encerrar\n")

    while True:
        user_input = input("> ").strip()
        
        if user_input.lower() in ["sair", "exit", "quit"]:
            print("Encerrando...")
            break
        
        if not user_input:
            continue
        
        if user_input == "/help":
            print("\n[Comandos:]")
            print("  /news [termo] - Buscar noticias sobre um assunto")
            print("  /mundo       - Mostrar noticias mundiais")
            print("  /help        - Mostrar esta ajuda")
            print("  clear/cls - Limpar a tela")
            print("  sair         - Encerrar\n")
            continue
        
        if user_input in ["clear", "cls"]:
            os.system("clear")        
            show_banner()
            print("=== Luna Bot ===\n")
            print("\n[Comandos:]")
            print("  /news [termo] - Buscar noticias sobre um assunto")
            print("  /mundo       - Mostrar noticias mundiais")
            print("  /help        - Mostrar esta ajuda")
            print("  clear/cls - Limpar a tela")
            print("  sair         - Encerrar\n")
            continue
        
        if user_input.startswith("/news "):
            query = user_input[6:]
            if not query:
                print("Erro: Digite um termo para buscar.\n")
                continue
            
            print(f"\nBuscando: {query}")
            news_results = get_news(query)
            print("\nNoticias encontradas:")
            for news in news_results:
                print(news)
            print()
            continue
        
        if user_input == "/mundo":
            print("\nBuscando noticias mundiais...")
            world_news = get_world_news()
            print("\nNoticias Mundiais:")
            for news in world_news:
                print(news)
            print()
            continue
        
        bot_response = kernel.respond(user_input)
        
        if not bot_response or len(bot_response) < 2 or "No match" in bot_response or "Nao entendi" in bot_response:
            bot_response = get_ollama_response(user_input)
            
            if not bot_response:
                bot_response = "Nao consegui processar sua pergunta. Tente novamente."
        
        print(f"{bot_response}\n")

if __name__ == "__main__":
    main()