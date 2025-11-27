import json
import sys
dir = "c.json"
itemname = sys.argv[1]
password = sys.argv[2]
try: 
    with open(dir, 'w') as file:
        data = {itemname : password}
        json.dump(data, file, indent=4)
    
    
except Exception as e:
    print(e)