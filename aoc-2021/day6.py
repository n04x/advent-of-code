#region modules
#endregion

#region functions
def lanternfishGrowth(lanternfishs_initial, days):
    internal_timer_list = [0] * 9  # 9 to match the numbers of internal timers for each positions in the array

    # store the initial value in an array
    for cycle in lanternfishs_initial:
        internal_timer_list[cycle] += 1

    # loop through each days and shift the cycle count to the left and add new lanternfishs at pos 6 for each fish at pos 0 of the cycle counts
    for _ in range(days):
        new_internal_timer_list = internal_timer_list[1:] + internal_timer_list[:1]
        new_internal_timer_list[6] += internal_timer_list[0] # add new fish at pos 6 of the internal timer list
        internal_timer_list = new_internal_timer_list    
    
    return sum(internal_timer_list)
#endregion

#region main
with open('./input/day6.txt') as file:
    lanternfishs_initial = [int(x) for x in file.read().split(',')]

days1 = 80
days2 = 256
print('Part 1: After {} days, there will be a total of {} lanternfishs'.format(days1, lanternfishGrowth(lanternfishs_initial, days1)))
print('Part 2: After {} days, there will be a total of {} lanternfishs'.format(days2, lanternfishGrowth(lanternfishs_initial, days2)))
#endregion