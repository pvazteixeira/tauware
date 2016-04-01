import wiiboard
import pygame
import time

def main():

        f = open('workfile', 'w')
        
	board = wiiboard.Wiiboard()

	pygame.init()
	
	address = board.discover()
        print address
        # 34:AF:2C:2B:E4:01
	board.connect(address) #The wii board must be in sync mode at this time
        #board.connect("34:AF:2C:2B:E4:01")

        
	time.sleep(1.0)
	board.setLight(True)
	done = False

	while (not done):
		#time.sleep(0.005)
		for event in pygame.event.get():
			if event.type == wiiboard.WIIBOARD_MASS:

                                #print " --- "
                                # print "Top left:" + event.mass.topLeft
                                # print "Top right" + event.mass.topRight
                                # print "bottom left:" + event.mass.bottomLeft
                                # print "bottom right" + event.mass.bottomRight
                                #dx = 0.225 # half-x distance between sensors
                                #dy = 0.12  # half-y distance between sensors
                                #x = (dx/(event.mass.totalWeight+1))*( (event.mass.topRight+event.mass.bottomRight) - (event.mass.topLeft + event.mass.bottomLeft) )
                                #y = (dy/(event.mass.totalWeight+1))*( (event.mass.topRight+event.mass.topLeft) - (event.mass.bottomRight + event.mass.bottomLeft) )
                                #print "x=",x
                                #print "y+",y
                                millis = int(round(time.time() * 1000000))

                                s = str(millis) + str(",") + str(event.mass.topRight) + str(",") + str(event.mass.bottomRight) + str(",") + str(event.mass.bottomLeft) + str(",") + str(event.mass.topLeft) + str("\n") 
                                
                                f.write(s)
                                # x length
				#if (event.mass.totalWeight > 10):   #10KG. otherwise you would get alot of useless small events!
				#	print "--Mass event--   Total weight: " + `event.mass.totalWeight` + ". Top left: " + `event.mass.topLeft`
				#etc for topRight, bottomRight, bottomLeft. buttonPressed and buttonReleased also available but easier to use in seperate event
                                

                                
			elif event.type == wiiboard.WIIBOARD_BUTTON_PRESS:
				print "Button pressed!"

			elif event.type == wiiboard.WIIBOARD_BUTTON_RELEASE:
				print "Button released"
				done = True
			
			#Other event types:
			#wiiboard.WIIBOARD_CONNECTED
			#wiiboard.WIIBOARD_DISCONNECTED

	board.disconnect()
	pygame.quit()

#Run the script if executed
if __name__ == "__main__":
	main()
