testList = [5, 7, 98, 33, 24, 56]
target = 7

binarySearch = (list, target) ->
	low = 0
	high = list.length
	while low < high
		mid = (low + high) / 2;
		val = list[mid]
		if val is target
			return "target found at list[" + mid + "]"
		else if val < target
			low = mid + 1
		else
			high = mid
		return "sorry, the target not found"

bTest = binarySearch(testList, target)