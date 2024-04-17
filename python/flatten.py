import json
import pandas as pd
import json
import sys
from pathlib import Path


# How to use : 
# pip3 install pandas
# python3 flatten.py ~/Downloads/enrique-file.json

def flatten_json(y):
    out = {}
 
    def flatten(x, name=''):
        # If the Nested key-value
        # pair is of dict type
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        # If the Nested key-value
        # pair is of list type
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x
 
    flatten(y)
    return out

if __name__ == "__main__":
    p = Path(sys.argv[1])
    array = json.load(open(p, 'r'))

    array_processed = []
    for a in array:
        array_processed.append(flatten_json(a))
        # f = flatten_json(a)
        # print(f)
    target = f'{p.parent}/{p.stem}.xlsx'
    print(f'Saving file to {target}')
    pd.DataFrame(array_processed).to_excel(target, index=None)