# Hashing for Algo

arr = [1, 17, 1024, 55, 69, 122]
hashing = []
hashing_ir = []

print("original\t", arr)

def h(x):
    return x % 11

def r(x):
    return (x % 4) + 1

for i in arr:
    hashing.append(h(i))
    hashing_ir.append(h(i) + i * r(i))

print("h(i)\t\t", hashing)
print("h(i)+i*r(i)\t", hashing_ir)