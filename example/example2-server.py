import sys
from omniORB import CORBA, PortableServer
import Example, Example__POA

import os

class Echo_i (Example__POA.Echo):
    def echoString(self, mesg):
        print("echoString() called with message:", mesg)
        return f"Echoed {mesg}"
  
orb = CORBA.ORB_init(sys.argv, CORBA.ORB_ID)
poa = orb.resolve_initial_references("RootPOA")
  
ei = Echo_i()
eo = ei._this()


ref_file = f"/tmp/example2_ref.{os.getpid()}.txt"
with open(ref_file, "w") as f:
    print(f"Writing object reference to {ref_file}")
    f.write(orb.object_to_string(eo))

  
poaManager = poa._get_the_POAManager()
poaManager.activate()
  
orb.run()