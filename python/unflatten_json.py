#!/usr/bin/python3

import re
import json

EXEMPLE = {
  # "item[0].subitem[0].key": "value1",
  # "item[0].subitem[1].key": "value2",
  # "item[1].subitem[0].key": "value3",
  # "item[1].subitem[1].key": "value4",
  # "item2[0].subitem[0]": "value5",
  # "item2[0].subitem[1]": "value6",
  # "item2[1][0].key1": "value7",
  # "item2[1][1].key2": "value8",
  "key3": "value",
  "key4.nested": "value"
}

# Usage: ./unflatten_json.py

def unflatten(flattened_dict):
  d = {}
  for key, value in flattened_dict.items():
    s = d
    tokens = re.findall(r'\w+', key) # list of words in the key
    for count, (index, next_token) in enumerate(zip(tokens, tokens[1:] + [value]), 1):
      print(count, index, next_token)
      value = next_token if count == len(tokens) else [] if next_token.isdigit() else {}
      if isinstance(s, list):
        index = int(index)
        while index >= len(s):
          s.append(value)
      elif index not in s:
        s[index] = value
      s = s[index]
  return d

if __name__ == "__main__":
  unflattened = unflatten(EXEMPLE)
  print(json.dumps(unflattened, indent=2))