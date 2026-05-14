from pymongo import MongoClient
import random
import datetime

# Підключення до локальної MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

categories = ["Electronics", "Clothing", "Books", "Home", "Sports"]
documents = []

print("Генеруємо 100 000 записів. Це займе кілька секунд...")

# Генерація даних
for _ in range(100000):
    documents.append({
        "customer_id": random.randint(1, 1000),
        "category": random.choice(categories),
        "amount": round(random.uniform(5, 500), 2),
        "timestamp": datetime.datetime(2024, random.randint(1, 12), random.randint(1, 28))
    })

# Масова вставка в базу
collection.insert_many(documents)
print("100 000 документів успішно додано до колекції sales!")
