unsorted_arr = [36, 12, 908, 3746, 11, 2, 45, 683, 923, 109, 90, 23]

# BUBBLE Sort
def bubble_sort arr
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

  data = bubble_sort [36, 12, 908, 3746, 11, 2, 45, 683, 923, 109, 90, 23]
  print "Sorted Array:"
  print data[0]
  print "Total Number Of Swaps: #{data[1]}"
  print "Number Of Swaps Per Iteration: #{data[2]}"
  print "Total Number Of Iterations: #{data[3]}"
  print "Time Of Execution: #{data[4]}"
  print "States Of Array After Each Iteration:"
  data[5].each { |arr| puts arr }
