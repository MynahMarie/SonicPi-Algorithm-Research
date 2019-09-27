unsorted_arr = [36, 12, 908, 3746, 11, 2, 45, 683, 923, 109, 90, 23]

# BUBBLE Sort
def bubble_sort array
  arr = array.dup
  swapped = false
  r = arr.length - 2

  # DATA - Tracking variables
  array_states = []
  total_swaps = 0
  swaps_per_iter = []
  num_iters = 0
  time_of_exec = 0

  start_time = Time.now # Start calculating time of execution

  while true do
    swaps = 0
    num_iters += 1 # Keep track on the number of times we enter the loop

    for i in 0..r # inclusive range
      if arr[i] > arr[i+1]
        arr[i], arr[i+1] = arr[i+1], arr[i]
        swapped = true if !swapped
        swaps += 1
      end
    end
    total_swaps += swaps
    swaps_per_iter.push(swaps) # remember how many swaps occured in this iteration

    swapped ? swapped = false : break

    array_states.push(arr.dup) # save a copy of the current state of the array
  end

  time_of_exec = Time.now - start_time

  # return the sorted array and all the tracking data
  [arr, total_swaps, swaps_per_iter, num_iters, time_of_exec, array_states]
end


# SELECTION sort
def selection_sort array
  arr = array.dup
  r = arr.length - 1
  swaps = 0
  subarrays = []

  # Benchmark time of execution
  start = Time.now

  # loop over the entire array 1 time
  for i in 0..r
    # current element is saved as minimum base value
    # index of smallest value found saved with default value of current index
    min = arr[i]
    min_idx = i
    puts "i = #{i} = min_idx, min = arr[#{i}] = #{arr[i]}"

    # loop over each subarray
    subarr = arr[(i+1)..r]
    subarrays.push(subarr)

    puts "Looping over subarray"
    for j in (i + 1)..r
      puts "j = #{j}, arr[#{j}] = #{arr[j]}"
      # if current element of subarray is smaller then min, replace min value and save current index
      if arr[j] < min
        puts "#{arr[j]} < #{min}"
        min = arr[j]
        min_idx = j
        puts "min = #{arr[j]}, min_idx = #{min_idx}"
      else
        puts "#{arr[j]} >= #{min} PASS"
      end
    end
    puts "Minimum found: min = #{min}, min_idx = #{min_idx}"

    # if the initial value has changed (new minimum was found)
    # make the swap between the value at current index and value at min_idx
    if min_idx != i
      puts "Making a swap: arr[#{i}] = #{arr[i]}, arr[#{min_idx}] = #{arr[min_idx]}"
      arr[i], arr[min_idx] = arr[min_idx], arr[i]
      swaps += 1
    else
      puts "min_idx = #{min_idx} == i Skipping swap!"
    end
  end

  finish = Time.now

  # Return data
  [swaps, arr, (finish - start), subarrays]
end

# INSERTION Sort
def insertion_sort array
  arr = array.dup
  r = arr.length - 1
  swaps = 0
  subarrays = []

  # Benchmark time of execution
  start = Time.now

  # Loop over the array
  for i in 1..r
    # define variable j with the value of current index i - 1 (to loop over sub array)
    # set the key to the current value
    # loop backwards from current index and overwrite the value of
    # arr[j + 1] with preceding element if it's greater then key
    # decrease j by 1
    key = arr[i]
    j = i - 1

    puts "i = #{i}, j = #{j}"
    puts "key = #{key} = arr[#{i}]"

    subarr = arr[0..j]
    subarrays.push(subarr) unless j < 0

    while j >= 0 and arr[j] > key
      puts "#{j} >= 0 AND #{arr[j]} > #{key}" # True
      puts "arr[#{j + 1}] = #{arr[j + 1]}, arr[#{j}] = #{arr[j]}"
      arr[j + 1] = arr[j]
      puts "overwritting value"
      j -= 1
    end
      puts "Done overwritting: arr[#{j + 1}] = #{arr[j + 1]}"

      # when we reached the point that key is smaller then arr[j + 1], make the swap
      if arr[j + 1] != key
        puts "#{arr[j + 1]} != #{key}" # True
        puts "swapping with: key = #{key}, arr[#{j + 1}] = #{arr[j + 1]}"
        arr[j + 1] = key
        swaps += 1 # Mark swap event
        puts "after swap: arr[#{j + 1}] = #{arr[j + 1]}"

      # The key was already at the right position, no need to swap
      else
        puts "#{arr[j + 1]} == #{key} Skipping swap!" # False - no swap
      end
    end

    finish = Time.now

    # return data
    [swaps, arr, (finish - start), subarrays]
end

puts "BUBBLE SORT"
bubble = bubble_sort unsorted_arr
print "Sorted Array:"
print bubble[0]
print "Total Number Of Swaps: #{bubble[1]}"
print "Number Of Swaps Per Iteration: #{bubble[2]}"
print "Total Number Of Iterations: #{bubble[3]}"
print "Time Of Execution: #{bubble[4]}"
print "States Of Array After Each Iteration:"
bubble[5].each { |arr| puts arr }

puts "SELECTION SORT"
selection = selection_sort unsorted_arr
puts "Sorted array: #{selection[1]}"
puts "Number of swaps: #{selection[0]}"
puts "Time of execution: #{selection[2]}"
puts "Subarrays:"
selection[3].each {|s| puts s}

puts "INSERTION SORT"
insertion = insertion_sort unsorted_arr
puts "Sorted array: #{insertion[1]}"
puts "Number of swaps: #{insertion[0]}"
puts "Time of execution: #{insertion[2]}"
puts "Subarrays:"
insertion[3].each {|s| puts s}
