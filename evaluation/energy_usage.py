import sys
from datetime import datetime
import matplotlib.pyplot as plt

def compute_energy(file_path):
    energy = 0.0
    last_time = None
    last_power = None

    data = []

    with open(file_path, 'r') as file:
        for line in file:
            timestamp_str, power_str = line.strip().split(', ')
            timestamp = datetime.strptime(timestamp_str[:-3], '%Y-%m-%d %H:%M:%S.%f')
            power = float(power_str)
            
            if last_time is not None:
                # Calculate the time difference between consecutive measurements in seconds
                delta_t = (timestamp - last_time).total_seconds()
                
                # Compute energy as the sum of power multiplied by time
                energy += (power + last_power) / 2 * delta_t
            
            # Update last time and last power
            last_time = timestamp
            last_power = power

            data.append((timestamp.timestamp(), power))
    
    return energy, data

def makePlot(data, filename):
    times, values = zip(*data)
    start_time = times[0]
    times = [(t - start_time) for t in times]
    plt.plot(times, values)     # Plot the data
    plt.xlabel('Time (seconds)')# Label for the x-axis
    plt.ylabel('Value')         # Label for the y-axis
    plt.title('Line Chart')     # Title of the chart
    plt.savefig(filename)       # Save the chart as an image file
    plt.close()
    
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <input_file> [output_file]")
        sys.exit(1)

    input_file = sys.argv[1]
    total_energy, data = compute_energy(input_file)

    print("Total energy consumed:", total_energy, "Joules")

    if len(sys.argv) > 2:
        output_file = sys.argv[2]

        if (output_file):
            makePlot(data, output_file)

