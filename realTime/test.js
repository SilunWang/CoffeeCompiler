binarySearch = function(array,low,high,target) {
if(low>high) {
return 0;
}
mid = (low+high)/2;
if(array[mid]>target) {
return binarySearch(array,low,mid-1,target);
}
if(array[mid]<target) {
return binarySearch(array,mid+1,high,target);
}
else {
return target;
}
};
main = function() {
array = [1, 2, 4, 7, 9, 12, 54, 111];
low = 0;
high = array.length;
target = 54;
if(target===binarySearch(array,low,high-1,target)) {
return true;
}
else {
return 0;
}
};

