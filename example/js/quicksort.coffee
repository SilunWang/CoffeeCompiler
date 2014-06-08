quicksort = (array, low, high) ->
	l = low
	r = high
	pivot = array[low]

	while l <= r
		while array[l] < pivot
			l = l + 1
		while array[r] > pivot
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
a = [3,2,45,6,1,666]
quicksort(a,0,a.length-1)
a