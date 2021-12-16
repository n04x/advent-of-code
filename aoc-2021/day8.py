#region modules
import re
#endregion

#region functions

#endregion

#region main
with open('./input/test.txt') as file:
    data = re.findall(r'(.*) \| (.*)', file.read())
    data = [(ins.split(), outs.split()) for ins, outs in data]

uniques = (2, 3, 4, 7)
    
#endregion