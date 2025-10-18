import time, random, string, base64

# CONFIG
PREFIX = "GGL-"
REQUIRED_WORD = "sandbox"

def generate_nonce(length=5):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def generate_key(custom_seconds=10800):  # default: 3 hours
    now = int(time.time())
    expiry = now + int(custom_seconds)
    nonce = generate_nonce()
    rand = random.randint(100000, 999999)

    raw_key = f"{PREFIX}{REQUIRED_WORD}-{expiry}-{nonce}-{rand}"
    encoded = base64.b64encode(raw_key.encode()).decode()

    print("\n🔐 Encoded Key:")
    print(encoded)
    print("⏳ Expires at:", time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(expiry)))
    print("🕒 Duration:", custom_seconds, "seconds")
    return encoded, expiry

# Example usage
try:
    duration = int(input("⏱️ Enter duration in seconds (e.g., 3600 for 1 hour): "))
except:
    duration = 10800  # fallback to 3 hours

generate_key(duration)
