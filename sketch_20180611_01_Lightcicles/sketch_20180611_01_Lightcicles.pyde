l = 5
matrix = []

def setup():
    size(1200, 800)
    for i in range(0, width, l):
        arr = []
        for j in range(0, int(random(height)), l): # random length array
            arr.append(random(255)) # random value for each "pixel" fill
        matrix.append((i, arr))
    
def draw():
    background(0)
    for i, arr in matrix:
        for j, f in enumerate(arr):
            fill(f)
            rect(i, j*5, l, l)
            #rect(i, height-j*5, l, l)
            if frameCount % 20 > 0:
                arr[j] = arr[max(j-1, 0)] + random(-5)
            if j==0 and f < 10:
                arr[j] = random(255)
