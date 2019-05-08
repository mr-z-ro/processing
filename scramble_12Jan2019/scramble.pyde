# Inspired by: http://loremipsum-404.tumblr.com/post/130153850657
# 11 Jan 2019

add_library('pdf')

w = 400
h = 550

def setup():
    size(w, h)
    background(255)
    stroke(0)
    frameRate(1)
    
def draw():
    beginRecord(PDF, "noiselines.pdf")
    
    background(255)
    nLines = 200 
    nSteps = 200
    noiseCenterX = width/3
    noiseCenterY = 2*height/3
    
    for i in range(nLines):
        x = i*width/nLines
        y = 0
        for j in range(nSteps):
            
            if dist(x, y, noiseCenterX, noiseCenterY) > 40:
                multiplier = 1
            else:
                multiplier = dist(x, y, noiseCenterX, noiseCenterY)/2
            
            x_next = i*width/nLines + random(-width/(2*nLines), width/(2*nLines))*multiplier
            y_next = y + random(2*height/nSteps)*multiplier
            line(x, y, x_next, y_next)
            
            x = x_next
            y = y_next
            
            if y > 0.7*height:
                break
    endRecord()
    exit()       
