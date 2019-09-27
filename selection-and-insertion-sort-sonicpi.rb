# SELECTION and INSERTION Sort - Earth To Abigail
# Link to tutorial: https://www.earthtoabigail.com/blog/audio-representation-selection-and-insertion-sort-ruby-sonicpi

# Unsorted array based on hirajoshi scale
unsorted_arr = [82, 81, 70, 62, 57, 74, 86, 55, 67, 75, 79, 63, 58, 69, 87, 91]

use_bpm 80

def sorted array, swaps
  in_thread do
    4.times do
      # Marks how many swaps the algorithm performed
      swaps.times do
        sample :elec_blip, amp: rrand(1.5, 2.0), pan: rrand(-1, 1)
        sleep 3.0 / swaps
      end
      sleep 1
    end
  end

  in_thread do
    16.times do
      in_thread do
        sample :bd_tek, amp: 3
        sleep 0.5
        sample :drum_snare_hard
        sleep 0.5
      end
      in_thread do
        4.times do
          sample :drum_cymbal_closed, rate: 2
          sleep 0.25
        end
      end

      8.times do
        sample :drum_cymbal_pedal, rate: 3 if one_in(3)
        sleep 0.125
      end
    end
  end

  4.times do
    use_synth :sine
    array.each {|n| play n, release: 0.3; sleep 0.25}
  end
end


# SELECTION sort
def selection_sort array

  arr = array.dup
  r = arr.length - 1
  swaps = 0

  # Play unsorted array once
  puts arr
  use_synth :sine
  arr.each {|n| play n, release: 0.3; sleep 0.25}

  # Select according to columns
  # Loop once over the entire array
  for i in 0..r
    # Current element is saved as minimum base value
    # Index of smallest value found saved with default value of current index
    min = arr[i]
    min_idx = i

    # Mark when we enter the loop
    sample :bd_tek, amp: 3

    use_synth :sine
    sub = arr[i+1..-1]

    # Debug
    puts sub

    sub.each { |n| play n, release: 0.02, cutoff: 60, decay: 0.05; sleep 0.125}

    # Loop over each subarray
    replacements = 0 # Marks how many times there was a swap
    for j in (i + 1)..r
      # If current element of subarray is smaller then min, replace min value
      # and save current index
      if arr[j] < min
        min = arr[j]
        min_idx = j
        replacements += 1
      end
    end

    # If the initial value has changed (new minimum was found)
    # make the swap between the value at current index and value at min_idx
    in_thread do
      replacements.times do
        sample :drum_cymbal_closed, rate: 2, amp: 1.3
        sleep 0.125
      end
    end

    in_thread do
      if min_idx != i
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
        swaps += 1
        use_synth :tb303
        # Play the note that was swapped with arr[i]
        play arr[min_idx], amp: 0.4, sustain: 0.1, decay: 0.2, release: 0.1, cutoff: 60
      else
        # Marks that no swap was needed
        sample :drum_snare_soft, amp: 1.5, rate: -1
      end
    end

    # Play the selected note
    use_synth :tb303
    play arr[i], cutoff: 70, sustain: 0.1, decay: 0.2, release: 0.1, amp: 0.6
    sleep 2 - (sub.length * 0.125)

  end

  # Play sorted function
  sorted arr, swaps

  return [swaps, arr]

end


# INSERTION Sort
def insertion_sort array
  arr = array.dup
  r = arr.length - 1
  swaps = 0

  # Play unsorted array once
  puts arr # Debug print
  arr.each {|n| play n, release: 0.3; sleep 0.25}

  # Loop over the array
  for i in 1..r
    # Mark when we enter the loop
    sample :bd_tek, amp: 3

    # Define variable j with the value of current index i - 1 (to loop over sub array)
    # Set the key to the current value
    # Loop backwards from current index and overwrite the value of
    # arr[j + 1] with preceding element if it's greater then key
    # Decrease j by 1
    key = arr[i]
    j = i - 1

    overwrites = 0
    while j >= 0 and arr[j] > key
      arr[j + 1] = arr[j]
      j -= 1
      overwrites += 1
    end

    # When we reached the point that key is smaller then arr[j + 1], make the swap
    note_swapped = false
    if arr[j+1] != key
      note_swapped = arr[j+1]
      arr[j+1] = key
      swaps += 1
    else
      # Marks that key was already at the right position
      sample :drum_splash_soft, rate: -1
    end

    # Indicates how many times we needed to overwrite values in order to insert the key
    # at the right place in the array
    in_thread do
      sleep 1
      overwrites.times do
        sample :drum_cymbal_closed, rate: 2, amp: 1.3
        sleep 0.125
      end
    end

    sub = arr[0..i]

    # Debug
    puts sub

    sub.each { |n|

      n === key ?
      (inserted = true; use_synth :tb303) :
      (inserted = false; use_synth :pretty_bell)

      if inserted
        play n, cutoff: 70, release: 0.3, amp: 1
        if note_swapped
          play note_swapped, cutoff: 60, release: 0.3, amp: 0.3
        end

      else
        play n, release: 0.3, amp: 1.6
      end

      sleep 0.125
    }

    sleep 2.0 - (sub.length * 0.125)
  end

  # Play sorted function
  sorted arr, swaps

  return [swaps, arr]
end


with_fx :reverb, room: 0.95 do

  # This provides a drone for ambiance
  live_loop :trembling_bass do
    use_synth :dsaw
    with_fx :slicer, phase: 0.125, smooth: 0.125 do
      play :g2, cutoff: rrand(60, 70), sustain: 4, decay: 1, release: 3, attack: 1, amp: 2.5
      sleep 8
    end
  end

  # This loops the calls to the sorting functions
  live_loop :sorting do
    selection = selection_sort unsorted_arr
    puts selection

    insertion = insertion_sort unsorted_arr
    puts insertion
  end
end
