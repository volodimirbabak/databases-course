from pymongo import MongoClient
import time

# Підключення до бази даних
client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

print("Виконуємо пошук без індексу...")

# Фіксуємо час початку
start_time = time.time()

# Виконуємо пошук документів, де категорія "Electronics", і перетворюємо в список
results = list(collection.find({"category": "Electronics"}))

# Фіксуємо час завершення
end_time = time.time()

# Виводимо результати
print(f"Знайдено документів: {len(results)}")
print(f"Time taken: {end_time - start_time:.6f} seconds")
