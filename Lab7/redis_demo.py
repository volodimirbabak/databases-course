import redis
import time

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

print("=== 1. Перевірка з'єднання ===")
print(r.ping())  # True

print("\n=== 2. Рядки ===")
r.set("student", "Володимир")
print(f"student = {r.get('student')}")
r.set("mycounter", 0)
r.incr("mycounter")
r.incr("mycounter")
print(f"mycounter = {r.get('mycounter')}")

print("\n=== 3. Список (List) ===")
r.delete("tasks")
r.lpush("tasks", "Task1", "Task2")
print(f"tasks = {r.lrange('tasks', 0, -1)}")
print(f"lpop = {r.lpop('tasks')}")

print("\n=== 4. Множина (Set) ===")
r.delete("tech:set")
r.sadd("tech:set", "Redis", "PostgreSQL", "MongoDB")
print(f"members = {r.smembers('tech:set')}")
print(f"is Redis member = {r.sismember('tech:set', 'Redis')}")

print("\n=== 5. Хеш (Hash) ===")
r.hset("profile", mapping={"name": "Володимир", "city": "Київ"})
print(f"name = {r.hget('profile', 'name')}")
print(f"all = {r.hgetall('profile')}")

print("\n=== 6. Sorted Set ===")
r.zadd("scores", {"Student1": 85, "Student2": 92, "Student3": 74})
print(f"ranking = {r.zrevrange('scores', 0, -1, withscores=True)}")
print(f"rank of Student1 = {r.zrank('scores', 'Student1')}")

print("\n=== 7. TTL ===")
r.set("temp:data", "Hello", ex=10)
print(f"value = {r.get('temp:data')}")
print(f"ttl = {r.ttl('temp:data')} сек")
time.sleep(11)
print(f"після 11с: {r.get('temp:data')}")  # None
