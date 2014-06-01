binarySearch = (array, low, high, target) ->
	return -1 if low > high
	mid = (low + high) / 2
	if array[mid] > target
		return binarySearch array, low, mid - 1, target
	else if array[mid] < target
		return binarySearch array, mid + 1, high, target
	else
		return target


main = ->
	array = [1, 2, 4, 7, 9, 12, 54, 111]
	low = 0
	high = array.length
	target = 54
	if target == binarySearch array, low, high-1, target
		return true
	else
		return false