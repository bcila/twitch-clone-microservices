from kafka import KafkaConsumer
from model import ToxicityModel
import json

consumer = KafkaConsumer(
    "chat.messages",
    bootstrap_servers="kafka:9092",
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    auto_offset_reset='latest'
)

model = ToxicityModel()
THRESHOLD = 0.75  # Toxicity threshold

print("AI Agent listening on Kafka topic: chat.messages...")

for message in consumer:
    msg = message.value.get("text", "")
    username = message.value.get("user", "unknown")

    score = model.predict(msg)
    print(f"[{username}] -> \"{msg}\" | Toxicity: {score:.2f}")

    if score > THRESHOLD:
        print(f"⚠️  Uygunsuz mesaj tespit edildi: {msg}")
        # Take action here, e.g., notify admin, log the message, etc.
