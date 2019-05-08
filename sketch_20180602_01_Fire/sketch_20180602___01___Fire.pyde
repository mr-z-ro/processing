w_max = 5
h_max = 5
W = 800
H = 800
N = 2000
boxes = []

def setup():
    colorMode(RGB, 100)
    for i in range(N):
        l = random(W) # start anywhere along the x
        t = random(H) # start anywhere along the y
        w = random(w_max)
        h = random(h_max)
        rad = random(min(w, h))
        r = 20
        g = 0
        b = 0
        a = random(100)
        boxes.append((l, t, w, h, rad, 80, 0, 0, random(100)))
    
    size(W, H)
    stroke(255)    
    
def draw():
    background(0)
    
    global W
    global H
    global boxes
    
    for i, box in enumerate(boxes):
        l, t, w, h, rad, r, g, b, a = box
        fill(r, g, b, a)
        rect(l, t, w, h, rad)
        # move using the following rules:
        #  - a random amount between -2 and 2 from start
        #  - modulated by where the mouse is in relation to center
        #  - modulated by where the mouse is in relation to the given box
        l = (box[0] + random(5) - random(5) + (mouseX-W/2)*0.01 + (box[0]%W/2 - width/2)/1000) % W
        t = (box[1] + random(5) - random(5) + (mouseY-H/2)*0.01 + (box[1]%H/2 - height/2)/1000) % H
        boxes[i] = (l, t, box[2], box[3], box[4], box[5], box[6], box[7], box[8])
        
