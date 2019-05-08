N = 1000
MAX_R = 5
arr = []

def setup():
    size(1200, 800, P3D)
    
    for _ in range(N):
        arr.append([random(width*1.5)-width*0.25, random(height*1.5)-height*0.25, random(MAX_R), random(255)]) # x, y, r, stroke
    
def draw():
    background(0)
    
    pushMatrix()
    translate(width/2, height/2)
    rotateY(radians((mouseX-width/2) * 30/width))
    rotateX(radians((mouseY-height/2) * 30/height))
    translate(-width/2, -height/2)
    
    for i, p1 in enumerate(arr):
        stroke(p1[3])
        ellipse(p1[0], p1[1], p1[2], p1[2])
        for p2 in arr[:i]:
            if dist(p1[0], p1[1], p2[0], p2[1]) < 40:
                stroke(min(p1[3], p2[3]))
                line(p1[0], p1[1], p2[0], p2[1])
    
    popMatrix()
