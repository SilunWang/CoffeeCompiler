testList = [5, 160, 7, 98, 0, -33, 24, 56]
target = 7

binarySearch = (list, target) ->
	low = 0
	high = list.length
	while low < high
		mid = low + high;
		mid = parseInt(mid / 2);
		val = list[mid]
		if val is target
			return "target " + target + " found at sorted list[" + mid + "]"
		else if val < target
			low = mid + 1
		else
			high = mid
	return "sorry, the target not found"

quicksort = (array, low, high) ->
	l = low
	r = high
	mid = low + high;
	mid = parseInt(mid / 2);
	pivot = array[low]
	while(l <= r)
		while(array[l] < pivot)
			l = l + 1 
		while(array[r] > pivot)
			r = r - 1 
		if l <= r
			if l < r 
				tmp = array[l]
				array[l] = array[r]
				array[r] = tmp
			l = l + 1
			r = r - 1
	if l < high
		quicksort(array, l, high)
	if r > low
		quicksort(array, low, r)

sTest = testList.slice(0)

quicksort(sTest,0,testList.length-1)
bTest = binarySearch(sTest, target)


