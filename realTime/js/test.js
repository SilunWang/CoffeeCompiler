var testList;
testList = [9, 2, 3, 7, 88, 45];
var target;
target = 7;
var binarySearch;
binarySearch = function(list, target) {
    var low;
    low = 0;
    var high;
    high = list.length;
    while(low<high) {
        var mid;
        mid = (low+high)/2;
        var val;
        val = list[mid];
        if(val===target) {
            return "target found at list[" + mid + "]";
        }
        else if(val<target) {
            low = mid+1;
        }
        else {
            high = mid;
        }
        return "sorry, the target not found";
    }
};
var bTest;
bTest = binarySearch(testList, target);
var quicksort;
quicksort = function(array, low, high) {
    var l;
    l = low;
    var r;
    r = high;
    var mid;
    mid = (low+high)/2;
    var pivot;
    pivot = array[low];
    while(l<=r) {
        while(array[l]<pivot) {
            l = l+1;
        }
        while(array[r]>pivot) {
            r = r-1;
        }
        if(l<=r) {
            if(l<r) {
                var tmp;
                tmp = array[l];
                array[l] = array[r];
                array[r] = tmp;
            }
            l = l+1;
            r = r-1;
        }
    }
    if(l<high) {
        quicksort(array, l, high);
    }
    if(r>low) {
        quicksort(array, low, r);
    }
};
var sTest;
sTest = [9, 2, 3, 7, 88, 45];
quicksort(sTest, 0, testList.length-1);

