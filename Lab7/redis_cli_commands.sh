#!/bin/bash
# Лабораторна робота №7 — Redis CLI команди
# Кроки 1-4 (виконувались через Docker redis-cli)

# ============================================
# КРОК 1 — Встановлення та перевірка Redis
# ============================================

# Запуск Redis контейнера
docker run --name redis-lab7 -d -p 6379:6379 redis

# Перевірка що контейнер працює
docker ps

# Підключення до redis-cli
# docker exec -it redis-lab7 redis-cli

# Перевірка з'єднання
PING
# Відповідь: PONG

# ============================================
# КРОК 2 — Операції з рядками
# ============================================

SET student "Володимир"
GET student
# Відповідь: "Володимир"

SET mycounter 0
INCR mycounter
# Відповідь: (integer) 1
INCR mycounter
# Відповідь: (integer) 2
GET mycounter
# Відповідь: "2"

# ============================================
# КРОК 3 — Структури даних
# ============================================

# --- LIST ---
LPUSH tasks "Task1"
LPUSH tasks "Task2"
LRANGE tasks 0 -1
# Відповідь: 1) "Task2"  2) "Task1"
LPOP tasks
# Відповідь: "Task2"

# --- SET ---
SADD tech:set "Redis"
SADD tech:set "PostgreSQL"
SADD tech:set "MongoDB"
SMEMBERS tech:set
# Відповідь: "Redis", "PostgreSQL", "MongoDB"
SISMEMBER tech:set "Redis"
# Відповідь: (integer) 1

# --- HASH ---
HSET profile name "Володимир"
HSET profile city "Київ"
HGET profile name
# Відповідь: "Володимир"
HGETALL profile
# Відповідь: name "Володимир" city "Київ"

# --- SORTED SET ---
ZADD scores 85 "Student1"
ZADD scores 92 "Student2"
ZADD scores 74 "Student3"
ZREVRANGE scores 0 -1 WITHSCORES
# Відповідь: Student2(92) -> Student1(85) -> Student3(74)
ZRANK scores "Student1"
# Відповідь: (integer) 1

# ============================================
# КРОК 4 — TTL (час життя ключа)
# ============================================

SET temp:data "Hello" EX 10
# Відповідь: OK

GET temp:data
# Відповідь: "Hello"

TTL temp:data
# Відповідь: (integer) 10  ← залишок секунд

# Після 10 секунд:
GET temp:data
# Відповідь: (nil) ← ключ автоматично видалився

TTL temp:data
# Відповідь: (integer) -2 ← ключ не існує
