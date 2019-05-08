add_library('pdf')

def setup():
    size(600, 600)
    background(255)
    
def draw():
    beginRecord(PDF, "line.pdf")
    
    line(0,0, width, height)
    
    endRecord()
    exit()
    
    
