#region Parameters
TESTING = False
XMAS_occurence = 0
cross_MAS_occurence = 0
#endregion

#region Functions
def searchXMAS(r, c):
    word = "XMAS"

    if data[r][c] != word[0]:
        return 0
    
    dirs = ((-1,0),(1,0),(0,-1),(0,1),(-1,-1),(-1,1),(1,-1),(1,1))

    xmas_found = 0
    for r_dir, c_dir in dirs:
        i_XMAS = 1
        cR, cC = r + r_dir, c + c_dir

        while i_XMAS < len(word):
            if not (0 <= cR < rows) or not (0 <= cC < columns):
                break

            if data[cR][cC] != word[i_XMAS]:
                break

            i_XMAS += 1
            cR += r_dir
            cC += c_dir

        if i_XMAS == len(word):
            xmas_found += 1
    
    return xmas_found

def searchCrossMAS(r,c):
    word = ""
    if data[r][c] != "A":
        return 0
    
    dirs = ((-1,-1,1,1),(-1,1,1,-1))

    xmas_found = 0
    for r1, c1, r2, c2 in dirs:
        if not (0 <= r + r1 < rows) or not (0 <= r + r2 < rows):
            continue
        if not (0 <= c + c1 < columns) or not (0 <= c + c2 < columns):
            continue
        if data[r+r1][c+c1] == "S" and data[r+r2][c+c2] == "M":
            xmas_found += 1
        elif data[r+r1][c+c1] == "M" and data[r+r2][c+c2] == "S":
            xmas_found += 1
    
    if xmas_found == 2:
        return 1
    return 0
#endregion

#region Main
with open("test.txt" if  TESTING else 'input.txt') as file:
    data = file.read().splitlines()

columns = len(data[0])
rows = len(data)

for row in range(0, rows):
    for col in range(0, columns):
        XMAS_occurence += searchXMAS(row, col)
        cross_MAS_occurence += searchCrossMAS(row,col)

print("Part One Answer: {}".format(XMAS_occurence))
print("Part Two Answer: {}".format(cross_MAS_occurence))

#endregion