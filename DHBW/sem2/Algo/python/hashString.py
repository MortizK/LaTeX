def hashString(string, n):
    h = 0
    b = 31
    for i in range(len(string)):
        h = (h * b + ord(string[i])) % n
    return h

# Übung: Horner Schema

n = 101
b_ = 31

D = ord('D')
H = ord('H')
B = ord('B')
W = ord('W')

print(D, H, B, W)

print(D % n)
print(((D % n) * b_ + H) % n)
print(((((D % n) * b_ + H) % n) * b_ + B) % n)
print(((((((D % n) * b_ + H) % n) * b_ + B) % n) * b_ + W) % n)

print("DHBW\t\t", hashString("DHBW", n))
print("Stuttgart\t", hashString("Stuttgart", n))