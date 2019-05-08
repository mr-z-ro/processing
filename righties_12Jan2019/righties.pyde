#add_library('pdf')

w = 800
h = 800
horiz = True
shrinkRate = 2
maxSets = 4000

def setup():
    size(w, h)
    background(255)
    strokeWeight(1)
    frameRate(2)

def draw(): 
    background(255)
    global horiz
    
    #beginRecord(PDF, "righties.pdf")
    
    for i in range(maxSets):
        
        print "Set number: %s" % format(i)
        
        x = random(w)
        y = random(h)
        xMult = -1 + int(random(2)) * 2
        yMult = -1 + int(random(2)) * 2
        maxL = w/4
        
        while x < w and y < h and maxL > 0:
            if int(random(4)) != 1:
                stroke(0)
            else:
                stroke(255, 0, 0)
                
            l = random(maxL)
            if horiz:
                line(x,y,x+xMult*l,y)
                x = random(x, x+xMult*l)
                horiz = False
            else:
                line(x,y,x,y+yMult*l)
                y = random(y, y+yMult*l)
                horiz = True
                
            maxL = maxL - shrinkRate
        
        
    #endRecord()

    
