# Bubble Sort With Sonic Pi
# Link to tutorial: https://www.earthtoabigail.com/blog/bubble-sort-ruby-sonicpi

unsorted_arr = [81, 79, 69, 59, 55, 71, 83, 52, 64, 74, 76, 62, 57, 67, 86, 88]
use_bpm 90

def sorted arr
  4.times do
    in_thread do
      arr.each { |n|
        play n, release: 0.1
        sleep 0.25
      }
    end
    in_thread do # Keeps track of the One
      sample :bd_tek
      sleep 16
    end
    # Gives a nice and steady rythm that marks we have successfully sorted the list
    sample :loop_breakbeat, beat_stretch: 4, amp: 2
    sleep 4
  end
end

def bubble_sort array
  arr = array.dup
  swaped = false
  r = arr.length - 2

  # DATA - Tracking variables
  array_states = []
  total_swaps = 0
  swaps_per_iter = []
  num_iters = 0
  time_of_exec = 0

  arr.each { |n| play n; sleep 0.25 }

  start_time = Time.now # Start calculating time of execution

  while true do
      swaps = 0
      num_iters += 1 # Keep track on the number of iterations we did so far

      in_thread do
        use_synth :dsaw # Gives a base frequency (take lowest value of array)
        play 52, amp: 0.5, attack: 2, sustain: 6, decay: 2, release: 4, cutoff: 60
        sample :bd_tek # Tracking when we are entering the loop
      end

      in_thread do # Gives a sense of how many iterations we've done so far
        num_iters.times do |i|
          sample :drum_cymbal_closed, amp: 1.0 + (i.to_f / 2.0), rate: 2
          sleep (2.0 / num_iters).round(2)
        end
      end

      for i in 0..r # inclusive range
        play arr[i], release: 0.1
        sleep 0.25
        if arr[i] > arr[i+1]
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swaped = true if !swaped
          sample :elec_blip2, amp: 1.5
          sleep 0.25
          play arr[i] # hear the value which the current value is being compared to
          sleep 0.25
          swaps += 1
        end
      end
      total_swaps += swaps
      swaps_per_iter.push(swaps) # remember how many swaps occured in this iteration

      swaped ? swaped = false : break

      array_states.push(arr.dup) # save a copy of the current state of the array
    end

    time_of_exec = Time.now - start_time

    # Calling sorted function with sorted array
    sorted arr
    # return the sorted array and all the tracking data
    [arr, total_swaps, swaps_per_iter, num_iters, time_of_exec, array_states]
  end

  with_fx :reverb, room: 1 do
    live_loop :sort do
      bubble_sort unsorted_arr
    end
  end
