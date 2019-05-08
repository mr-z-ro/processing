N = 800
stars = []
a_x = 0
a_y = 0

def setup():
    size(1200, 800, P3D)
    for _ in range(N):
        stars.append(Star(random(-width/2, width/2), 
                          random(-height/2, height/2), 
                          random(-width/2, width/2),
                          random(220),
                          random(2, 5)))

def draw():
    global a_x, a_y
    
    background(0)
    translate(width/2, height/2)
    
    if mouseX:
        s_y = 0.1 * abs((mouseX-width/2.0)/(width/2.0))
        a_y = (a_y-s_y, a_y+s_y)[mouseX > width/2]
        rotateY(a_y)
        
    if mouseY:
        s_x = 0.1 * abs((mouseY-height/2.0)/(height/1.0))
        a_x = (a_x-s_x, a_x+s_x)[mouseY < height/2]
        rotateX(a_x)
    
    for i, star in enumerate(stars):
        star.plot()
        star.plotLines(stars[:i])
    
class Star:
    
    def __init__(self, x, y, z, s, w):
        self.x = x
        self.y = y
        self.z = z
        self.s = s
        self.w = w
        
    def plot(self):
        stroke(self.s)
        strokeWeight(self.w)
        point(self.x, self.y, self.z)
        
    def plotLines(self, other_stars):
        for star in other_stars:
            if dist(self.x, self.y, self.z, star.x, star.y, star.z) < 65:
                stroke(min(self.s, star.s))
                strokeWeight(1)
                line(self.x, self.y, self.z, star.x, star.y, star.z)
