import redis
import threading
import time

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

# ==========================================
# 1. ТРАНЗАКЦІЇ
# ==========================================
print("=== 1. Транзакція ===")
pipe = r.pipeline()
pipe.multi()
pipe.set("user:1", "Володимир")
pipe.set("user:2", "Олена")
pipe.incr("visits")
results = pipe.execute()
print(f"Результати транзакції: {results}")

# ==========================================
# 2. LUA-СКРИПТ
# ==========================================
print("\n=== 2. Lua-скрипт ===")
lua_script = """
if redis.call('exists', KEYS[1]) == 0 then
    return redis.call('set', KEYS[1], ARGV[1])
else
    return 'exists'
end
"""
r.delete("luakey")
result1 = r.eval(lua_script, 1, "luakey", "hello")
print(f"Перший виклик: {result1}")
result2 = r.eval(lua_script, 1, "luakey", "hello")
print(f"Другий виклик: {result2}")

# ==========================================
# 3. PUB/SUB
# ==========================================
print("\n=== 3. Pub/Sub ===")

def subscriber():
    r_sub = redis.Redis(host='localhost', port=6379, decode_responses=True)
    pubsub = r_sub.pubsub()
    pubsub.subscribe("news")
    print("Підписник: очікую повідомлення...")
    count = 0
    for message in pubsub.listen():
        if message['type'] == 'message':
            print(f"Отримано: {message['data']}")
            count += 1
            if count >= 2:
                break
    pubsub.unsubscribe()

thread = threading.Thread(target=subscriber)
thread.start()
time.sleep(0.5)

r.publish("news", "Redis is awesome!")
r.publish("news", "Привіт від Володимира!")

thread.join()

# ==========================================
# 4. REDIS STREAMS
# ==========================================
print("\n=== 4. Redis Streams ===")
r.delete("mystream")

r.xadd("mystream", {"sensor-id": "1234", "temperature": "19.8"})
r.xadd("mystream", {"sensor-id": "1234", "temperature": "22.1"})
r.xadd("mystream", {"sensor-id": "5678", "temperature": "18.5"})

events = r.xrange("mystream", "-", "+")
print("Всі події:")
for event_id, data in events:
    print(f"  ID: {event_id} | Дані: {data}")

read = r.xread({"mystream": "0"}, count=2)
print(f"\nXREAD (перші 2): {read[0][1]}")
