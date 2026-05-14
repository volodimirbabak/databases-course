from pymongo import MongoClient

# Підключення до бази даних MongoDB
client = MongoClient("mongodb://localhost:27017")

# Вибір бази даних і колекції
db = client["performance_test"]
collection = db["sales"]

# Створення індексу для поля "category" у колекції sales
collection.create_index("category")

# Виведення повідомлення
print("Індекс створено")
